const express = require('express');
const router  = express.Router();
const pool    = require('../db');
const { authMiddleware, adminMiddleware, managerMiddleware } = require('../middleware/auth');

// Haversine in km (Serverseite)
function calcKm(punkte) {
  let km = 0;
  const R = 6371;
  for (let i = 1; i < punkte.length; i++) {
    const a = punkte[i-1], b = punkte[i];
    const dLat = (b.lat - a.lat) * Math.PI / 180;
    const dLng = (b.lng - a.lng) * Math.PI / 180;
    const s = Math.sin(dLat/2)**2 + Math.cos(a.lat*Math.PI/180)*Math.cos(b.lat*Math.PI/180)*Math.sin(dLng/2)**2;
    km += R * 2 * Math.atan2(Math.sqrt(s), Math.sqrt(1-s));
  }
  return Math.round(km * 10) / 10;
}

// ── Auftraggeber ──────────────────────────────────────────────────────────────

router.get('/auftraggeber', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query('SELECT * FROM auftraggeber WHERE aktiv=true ORDER BY name');
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/auftraggeber', managerMiddleware, async (req, res) => {
  const { name, gutschrift_prozent, stundensatz, notiz, fahrzeit_bezahlt } = req.body;
  if (!name) return res.status(400).json({ error: 'Name erforderlich' });
  try {
    const r = await pool.query(
      `INSERT INTO auftraggeber (name, gutschrift_prozent, stundensatz, notiz, fahrzeit_bezahlt)
       VALUES ($1,$2,$3,$4,$5) RETURNING *`,
      [name, gutschrift_prozent || 0, stundensatz || 0, notiz || null, fahrzeit_bezahlt !== false]
    );
    res.status(201).json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/auftraggeber/:id', managerMiddleware, async (req, res) => {
  const { name, gutschrift_prozent, stundensatz, notiz, aktiv, fahrzeit_bezahlt } = req.body;
  try {
    const r = await pool.query(
      `UPDATE auftraggeber SET name=$1, gutschrift_prozent=$2, stundensatz=$3, notiz=$4, aktiv=$5,
       fahrzeit_bezahlt=$6 WHERE id=$7 RETURNING *`,
      [name, gutschrift_prozent||0, stundensatz||0, notiz||null, aktiv!==false,
       fahrzeit_bezahlt !== false, req.params.id]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.delete('/auftraggeber/:id', adminMiddleware, async (req, res) => {
  try {
    await pool.query('UPDATE auftraggeber SET aktiv=false WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Fahrzeugkosten-Einstellungen (vor /:id !) ─────────────────────────────────

router.get('/einstellungen', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query('SELECT * FROM fahrzeug_einstellungen WHERE id=1');
    res.json(r.rows[0] || { diesel_preis: 1.80, verbrauch_100km: 8, maut_pro_km: 0, abnuetzung_pro_km: 0.15 });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/einstellungen', adminMiddleware, async (req, res) => {
  const { diesel_preis, verbrauch_100km, maut_pro_km, abnuetzung_pro_km } = req.body;
  try {
    const r = await pool.query(
      `INSERT INTO fahrzeug_einstellungen (id, diesel_preis, verbrauch_100km, maut_pro_km, abnuetzung_pro_km, aktualisiert_am)
       VALUES (1, $1, $2, $3, $4, NOW())
       ON CONFLICT (id) DO UPDATE SET
         diesel_preis=$1, verbrauch_100km=$2, maut_pro_km=$3, abnuetzung_pro_km=$4, aktualisiert_am=NOW()
       RETURNING *`,
      [diesel_preis || 1.80, verbrauch_100km || 8, maut_pro_km || 0, abnuetzung_pro_km || 0.15]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Auswertung (vor /:id !) ────────────────────────────────────────────────────

router.get('/auswertung', managerMiddleware, async (req, res) => {
  const { von, bis, auftraggeber_id, mitarbeiter_id } = req.query;
  try {
    let q = `SELECT p.*, m.soll_stunden FROM projekt_auftraege p
             LEFT JOIN mitarbeiter m ON m.id = p.mitarbeiter_id
             WHERE 1=1`;
    const params = [];
    if (von)             { params.push(von);             q += ` AND p.erstellt_am::date >= $${params.length}`; }
    if (bis)             { params.push(bis);             q += ` AND p.erstellt_am::date <= $${params.length}`; }
    if (auftraggeber_id) { params.push(auftraggeber_id); q += ` AND p.auftraggeber_id = $${params.length}`; }
    if (mitarbeiter_id)  { params.push(mitarbeiter_id);  q += ` AND p.mitarbeiter_id = $${params.length}`; }
    q += ' ORDER BY p.erstellt_am DESC';
    const r = await pool.query(q, params);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Geplante Aufträge ─────────────────────────────────────────────────────────

router.get('/geplant', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `SELECT * FROM projekt_auftraege WHERE status='geplant'
       ORDER BY sort_order ASC, geplant_datum ASC NULLS LAST, erstellt_am ASC`
    );
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Sortierung geplanter Aufträge speichern ────────────────────────────────────

router.post('/geplant/sort', authMiddleware, async (req, res) => {
  const { reihenfolge } = req.body; // [{id, sort_order}]
  try {
    for (const item of (reihenfolge||[])) {
      await pool.query('UPDATE projekt_auftraege SET sort_order=$1 WHERE id=$2', [item.sort_order, item.id]);
    }
    res.json({ success: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Mitarbeiterkosten-Einstellungen ───────────────────────────────────────────

router.get('/ma-kosten', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query('SELECT * FROM ma_kosten_einstellungen WHERE id=1');
    res.json(r.rows[0] || { stundensatz_fa:55, stundensatz_ha:45, stundensatz_gf:35, warnschwelle:55 });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/ma-kosten', adminMiddleware, async (req, res) => {
  const { stundensatz_fa, stundensatz_ha, stundensatz_gf, warnschwelle } = req.body;
  try {
    const r = await pool.query(
      `INSERT INTO ma_kosten_einstellungen (id, stundensatz_fa, stundensatz_ha, stundensatz_gf, warnschwelle, aktualisiert_am)
       VALUES (1,$1,$2,$3,$4,NOW())
       ON CONFLICT (id) DO UPDATE SET
         stundensatz_fa=EXCLUDED.stundensatz_fa, stundensatz_ha=EXCLUDED.stundensatz_ha,
         stundensatz_gf=EXCLUDED.stundensatz_gf, warnschwelle=EXCLUDED.warnschwelle,
         aktualisiert_am=NOW()
       RETURNING *`,
      [stundensatz_fa||55, stundensatz_ha||45, stundensatz_gf||35, warnschwelle||55]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Geplanten Auftrag starten ─────────────────────────────────────────────────

router.put('/:id/starten', authMiddleware, async (req, res) => {
  const { tour_id, tour_position } = req.body;
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET status='fahrt', fahrt_start=NOW(), mitarbeiter_id=$1, mitarbeiter_name=$2,
           tour_id=COALESCE($3, tour_id), tour_position=COALESCE($4, tour_position)
       WHERE id=$5 RETURNING *`,
      [req.user.id, req.user.name, tour_id||null, tour_position||1, req.params.id]
    );
    if (!r.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Zum nächsten Auftrag weiterfahren (Verbindungsfahrt starten) ──────────────

router.put('/:id/weiter', authMiddleware, async (req, res) => {
  const { naechster_id, besonderheiten, notiz } = req.body;
  const now = new Date();
  try {
    const cur = await pool.query('SELECT * FROM projekt_auftraege WHERE id=$1', [req.params.id]);
    if (!cur.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    const p = cur.rows[0];
    // Aktuellen Auftrag abschließen
    await pool.query(
      `UPDATE projekt_auftraege
       SET status='abgeschlossen', fahrt_ende=$1, abgeschlossen_am=$1,
           fahrzeit_zurueck_min=ROUND(EXTRACT(EPOCH FROM ($1-abfahrt_zeit))/60),
           naechster_auftrag_id=$2,
           besonderheiten=COALESCE($3,besonderheiten), notiz=COALESCE($4,notiz)
       WHERE id=$5`,
      [now, naechster_id||null, besonderheiten||null, notiz||null, req.params.id]
    );
    // Nächsten Auftrag in FAHRT starten (Verbindungsfahrt beginnt jetzt)
    const tourId = p.tour_id || require('crypto').randomUUID().split('-')[0];
    const nextPos = (p.tour_position||1) + 1;
    const r2 = await pool.query(
      `UPDATE projekt_auftraege
       SET status='fahrt', fahrt_start=$1, mitarbeiter_id=$2, mitarbeiter_name=$3,
           tour_id=$4, tour_position=$5
       WHERE id=$6 RETURNING *`,
      [now, req.user.id, req.user.name, tourId, nextPos, naechster_id]
    );
    // Tour-ID auch auf Vorgänger setzen wenn noch nicht gesetzt
    await pool.query(
      `UPDATE projekt_auftraege SET tour_id=$1, tour_position=$2 WHERE id=$3 AND tour_id IS NULL`,
      [tourId, p.tour_position||1, req.params.id]
    );
    res.json(r2.rows[0] || null);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── iCal-Kalender-Feed (token-basiert, kein Session-Cookie nötig) ─────────────

router.get('/ical', async (req, res) => {
  const token = process.env.ICAL_TOKEN || 'solano-ical-2025';
  if (req.query.token !== token) return res.status(401).send('Unauthorized');
  try {
    const r = await pool.query(
      `SELECT * FROM projekt_auftraege
       WHERE geplant_datum IS NOT NULL
       ORDER BY geplant_datum ASC`
    );
    const lines = [
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Solano Services//Auftraege//DE',
      'CALSCALE:GREGORIAN',
      'METHOD:PUBLISH',
      'X-WR-CALNAME:Solano Aufträge',
      'X-WR-TIMEZONE:Europe/Vienna',
      // VTIMEZONE für Europe/Vienna (CET/CEST)
      'BEGIN:VTIMEZONE',
      'TZID:Europe/Vienna',
      'BEGIN:STANDARD',
      'DTSTART:19701025T030000',
      'RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10',
      'TZOFFSETFROM:+0200',
      'TZOFFSETTO:+0100',
      'TZNAME:CET',
      'END:STANDARD',
      'BEGIN:DAYLIGHT',
      'DTSTART:19700329T020000',
      'RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3',
      'TZOFFSETFROM:+0100',
      'TZOFFSETTO:+0200',
      'TZNAME:CEST',
      'END:DAYLIGHT',
      'END:VTIMEZONE',
    ];
    for (const p of r.rows) {
      const dt = p.geplant_datum.toISOString().split('T')[0].replace(/-/g, '');
      const title = [p.auftraggeber_name, p.kundenname].filter(Boolean).join(' – ');
      const adresse = [p.adresse_strasse, [p.adresse_plz, p.adresse_ort].filter(Boolean).join(' '), p.adresse_land].filter(Boolean).join(', ');
      const desc = [p.auftragsnummer ? 'Nr. ' + p.auftragsnummer : null, p.anzahl_mitarbeiter ? p.anzahl_mitarbeiter + ' MA' : null, p.notiz].filter(Boolean).join(' · ');
      lines.push('BEGIN:VEVENT');
      lines.push(`UID:solano-${p.id}@solano`);
      if (p.geplant_uhrzeit) {
        // Termin mit Uhrzeit
        const [hh, mm] = p.geplant_uhrzeit.slice(0, 5).split(':');
        const startSec = parseInt(hh) * 3600 + parseInt(mm) * 60;
        const durMin = parseInt(p.geplant_dauer_min) || 120;
        const endSec = startSec + durMin * 60;
        const endHh = String(Math.floor(endSec / 3600) % 24).padStart(2, '0');
        const endMm = String(Math.floor((endSec % 3600) / 60)).padStart(2, '0');
        // Falls Termin über Mitternacht geht: Folgetag
        const endDt = endSec >= 86400 ? (() => {
          const d = new Date(p.geplant_datum); d.setDate(d.getDate() + 1);
          return d.toISOString().split('T')[0].replace(/-/g, '');
        })() : dt;
        lines.push(`DTSTART;TZID=Europe/Vienna:${dt}T${hh}${mm}00`);
        lines.push(`DTEND;TZID=Europe/Vienna:${endDt}T${endHh}${endMm}00`);
      } else {
        // Ganztags-Event
        const dtEnd = new Date(p.geplant_datum);
        dtEnd.setDate(dtEnd.getDate() + 1);
        const dtEndStr = dtEnd.toISOString().split('T')[0].replace(/-/g, '');
        lines.push(`DTSTART;VALUE=DATE:${dt}`);
        lines.push(`DTEND;VALUE=DATE:${dtEndStr}`);
      }
      lines.push(`SUMMARY:${(title||'Auftrag').replace(/\n/g,' ')}`);
      if (adresse) lines.push(`LOCATION:${adresse.replace(/\n/g,' ')}`);
      if (desc) lines.push(`DESCRIPTION:${desc.replace(/\n/g,' ')}`);
      lines.push('STATUS:CONFIRMED');
      lines.push('END:VEVENT');
    }
    lines.push('END:VCALENDAR');
    const ics = lines.join('\r\n') + '\r\n';
    res.setHeader('Content-Type', 'text/calendar; charset=utf-8');
    res.setHeader('Content-Disposition', 'inline; filename="solano-auftraege.ics"');
    res.send(ics);
  } catch (err) { res.status(500).send('Fehler: ' + err.message); }
});

// ── Alle laufenden Aufträge (Admin/Manager) ───────────────────────────────────

router.get('/laufend', managerMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `SELECT p.*, m.name AS mitarbeiter_name_anzeige
       FROM projekt_auftraege p
       LEFT JOIN mitarbeiter m ON m.id = p.mitarbeiter_id
       WHERE p.status NOT IN ('abgeschlossen','geplant')
       ORDER BY p.erstellt_am DESC`
    );
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Aktiver Auftrag des aktuellen Nutzers ─────────────────────────────────────

router.get('/aktiv', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `SELECT * FROM projekt_auftraege
       WHERE mitarbeiter_id=$1 AND status NOT IN ('abgeschlossen','pausiert','geplant')
       ORDER BY erstellt_am DESC LIMIT 1`,
      [req.user.id]
    );
    res.json(r.rows[0] || null);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Liste ─────────────────────────────────────────────────────────────────────

router.get('/', authMiddleware, async (req, res) => {
  const { limit = 30 } = req.query;
  const isManager = !!(req.user.ist_admin || req.user.ist_chef);
  try {
    let q = `SELECT * FROM projekt_auftraege WHERE 1=1`;
    const params = [];
    if (!isManager) { params.push(req.user.id); q += ` AND mitarbeiter_id=$${params.length}`; }
    params.push(parseInt(limit) || 30);
    q += ` ORDER BY erstellt_am DESC LIMIT $${params.length}`;
    const r = await pool.query(q, params);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Neuer Auftrag ─────────────────────────────────────────────────────────────

router.post('/', authMiddleware, async (req, res) => {
  const { auftraggeber_id, auftraggeber_name, auftragsnummer, anzahl_mitarbeiter, notiz, geplant,
          kundenname, adresse, adresse_strasse, adresse_plz, adresse_ort, adresse_land,
          geplant_datum, ma_typen } = req.body;
  const status = geplant ? 'geplant' : 'fahrt';
  try {
    const r = await pool.query(
      `INSERT INTO projekt_auftraege
         (mitarbeiter_id, mitarbeiter_name, auftraggeber_id, auftraggeber_name,
          auftragsnummer, anzahl_mitarbeiter, notiz, status, fahrt_start,
          kundenname, adresse, adresse_strasse, adresse_plz, adresse_ort, adresse_land,
          geplant_datum, ma_typen)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,${geplant?'NULL':'NOW()'},$9,$10,$11,$12,$13,$14,$15,$16) RETURNING *`,
      [req.user.id, req.user.name, auftraggeber_id||null, auftraggeber_name||null,
       auftragsnummer||null, anzahl_mitarbeiter||2, notiz||null, status,
       kundenname||null, adresse||null,
       adresse_strasse||null, adresse_plz||null, adresse_ort||null, adresse_land||null,
       geplant_datum||null, JSON.stringify(ma_typen||[])]
    );
    res.status(201).json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Phase weiterrücken: fahrt → arbeit → rueckfahrt → abgeschlossen ──────────

router.put('/:id/phase', authMiddleware, async (req, res) => {
  const { km, gps_punkte, besonderheiten, notiz } = req.body;
  try {
    const cur = await pool.query('SELECT * FROM projekt_auftraege WHERE id=$1', [req.params.id]);
    if (!cur.rows.length) return res.status(404).json({ error: 'Auftrag nicht gefunden' });
    const p = cur.rows[0];

    const sets = [], params = [req.params.id];

    if (p.status === 'fahrt') {
      sets.push(`status='arbeit'`, `ankunft=NOW()`);
      sets.push(`fahrzeit_hin_min=ROUND(EXTRACT(EPOCH FROM (NOW()-fahrt_start))/60)`);
      if (km !== undefined) { params.push(parseFloat(km)||0); sets.push(`km_hin=$${params.length}`); }
    } else if (p.status === 'arbeit') {
      sets.push(`status='rueckfahrt'`, `abfahrt_zeit=NOW()`);
      sets.push(`arbeitszeit_min=ROUND(EXTRACT(EPOCH FROM (NOW()-ankunft))/60)`);
    } else if (p.status === 'rueckfahrt') {
      sets.push(`status='abgeschlossen'`, `fahrt_ende=NOW()`, `abgeschlossen_am=NOW()`);
      sets.push(`fahrzeit_zurueck_min=ROUND(EXTRACT(EPOCH FROM (NOW()-abfahrt_zeit))/60)`);
      if (km !== undefined) { params.push(parseFloat(km)||0); sets.push(`km_zurueck=$${params.length}`); }
    } else {
      return res.status(400).json({ error: 'Auftrag bereits abgeschlossen' });
    }

    if (besonderheiten !== undefined) { params.push(besonderheiten||null); sets.push(`besonderheiten=$${params.length}`); }
    if (notiz !== undefined) { params.push(notiz||null); sets.push(`notiz=$${params.length}`); }
    if (gps_punkte && gps_punkte.length) {
      params.push(JSON.stringify(gps_punkte));
      sets.push(`gps_punkte=gps_punkte || $${params.length}::jsonb`);
    }

    const r = await pool.query(
      `UPDATE projekt_auftraege SET ${sets.join(',')} WHERE id=$1 RETURNING *`, params
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Gutschrift erfassen ───────────────────────────────────────────────────────

router.put('/:id/gutschrift', managerMiddleware, async (req, res) => {
  const { gutschrift_betrag, gutschrift_datum, gutschrift_nummer, arbeitszeit_manuell_min, fahrtkosten_pauschale } = req.body;
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET gutschrift_betrag=$1, gutschrift_datum=$2, gutschrift_nummer=$3,
           arbeitszeit_manuell_min=COALESCE($4, arbeitszeit_manuell_min),
           fahrtkosten_pauschale=$5
       WHERE id=$6 RETURNING *`,
      [gutschrift_betrag||null, gutschrift_datum||null, gutschrift_nummer||null,
       arbeitszeit_manuell_min!=null?arbeitszeit_manuell_min:null,
       parseFloat(fahrtkosten_pauschale)||0, req.params.id]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Auftrag zurückstellen (→ geplant, kein Löschen) ──────────────────────────

router.put('/:id/zurueckstellen', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET status='geplant', fahrt_start=NULL, ankunft=NULL, abfahrt_zeit=NULL,
           fahrt_ende=NULL, abgeschlossen_am=NULL,
           arbeitszeit_min=NULL, fahrzeit_hin_min=NULL, fahrzeit_zurueck_min=NULL
       WHERE id=$1 RETURNING *`,
      [req.params.id]
    );
    if (!r.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Admin: Auftrag sofort abschließen ─────────────────────────────────────────

router.put('/:id/abschliessen-admin', managerMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET status='abgeschlossen', abgeschlossen_am=NOW(),
           fahrt_ende=COALESCE(fahrt_ende,NOW()),
           arbeitszeit_min=COALESCE(arbeitszeit_min,
             CASE WHEN ankunft IS NOT NULL THEN ROUND(EXTRACT(EPOCH FROM (NOW()-ankunft))/60) ELSE 0 END)
       WHERE id=$1 RETURNING *`,
      [req.params.id]
    );
    if (!r.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Allgemeines Update ────────────────────────────────────────────────────────

router.put('/:id', authMiddleware, async (req, res) => {
  const { notiz, besonderheiten, anzahl_mitarbeiter, auftragsnummer,
          km_hin, km_zurueck, arbeitszeit_manuell_min, arbeitszeit_min,
          fahrzeit_hin_min, fahrzeit_zurueck_min,
          auftraggeber_id, auftraggeber_name, kundenname, adresse,
          adresse_strasse, adresse_plz, adresse_ort, adresse_land,
          rapport_erforderlich, rapport_beschreibung,
          geplant_datum, geplant_uhrzeit, geplant_dauer_min,
          ma_typen, sort_order, fahrtkosten_pauschale } = req.body;
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET notiz=$1, besonderheiten=$2, anzahl_mitarbeiter=$3, auftragsnummer=$4,
           km_hin=COALESCE($5, km_hin), km_zurueck=COALESCE($6, km_zurueck),
           arbeitszeit_manuell_min=COALESCE($7, arbeitszeit_manuell_min),
           auftraggeber_id=COALESCE($8, auftraggeber_id),
           auftraggeber_name=COALESCE($9, auftraggeber_name),
           kundenname=COALESCE($10, kundenname), adresse=COALESCE($11, adresse),
           rapport_erforderlich=COALESCE($12, rapport_erforderlich),
           rapport_beschreibung=COALESCE($13, rapport_beschreibung),
           adresse_strasse=COALESCE($14, adresse_strasse),
           adresse_plz=COALESCE($15, adresse_plz),
           adresse_ort=COALESCE($16, adresse_ort),
           adresse_land=COALESCE($17, adresse_land),
           geplant_datum=COALESCE($18, geplant_datum),
           ma_typen=COALESCE($19::jsonb, ma_typen),
           sort_order=COALESCE($20, sort_order),
           arbeitszeit_min=COALESCE($21, arbeitszeit_min),
           fahrzeit_hin_min=COALESCE($22, fahrzeit_hin_min),
           fahrzeit_zurueck_min=COALESCE($23, fahrzeit_zurueck_min),
           fahrtkosten_pauschale=COALESCE($24, fahrtkosten_pauschale),
           geplant_uhrzeit=COALESCE($25, geplant_uhrzeit),
           geplant_dauer_min=COALESCE($26, geplant_dauer_min)
       WHERE id=$27 RETURNING *`,
      [notiz||null, besonderheiten||null, anzahl_mitarbeiter||2, auftragsnummer||null,
       km_hin!=null?km_hin:null, km_zurueck!=null?km_zurueck:null,
       arbeitszeit_manuell_min!=null?arbeitszeit_manuell_min:null,
       auftraggeber_id||null, auftraggeber_name||null,
       kundenname||null, adresse||null,
       rapport_erforderlich!=null?rapport_erforderlich:null,
       rapport_beschreibung!=null?rapport_beschreibung:null,
       adresse_strasse||null, adresse_plz||null, adresse_ort||null, adresse_land||null,
       geplant_datum||null,
       ma_typen!=null?JSON.stringify(ma_typen):null,
       sort_order!=null?sort_order:null,
       arbeitszeit_min!=null?arbeitszeit_min:null,
       fahrzeit_hin_min!=null?fahrzeit_hin_min:null,
       fahrzeit_zurueck_min!=null?fahrzeit_zurueck_min:null,
       fahrtkosten_pauschale!=null?parseFloat(fahrtkosten_pauschale):null,
       geplant_uhrzeit||null,
       geplant_dauer_min!=null?parseInt(geplant_dauer_min):null,
       req.params.id]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Neuer Termin (Multi-Session) ──────────────────────────────────────────────
router.put('/:id/neuer-termin', authMiddleware, async (req, res) => {
  try {
    const cur = await pool.query('SELECT * FROM projekt_auftraege WHERE id=$1', [req.params.id]);
    if (!cur.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    const p = cur.rows[0];
    // Aktuelle Session in sessions-Array speichern
    const neueSession = {
      datum: new Date().toISOString().split('T')[0],
      arbeitszeit_min: parseInt(p.arbeitszeit_min)||0,
      anzahl_mitarbeiter: parseInt(p.anzahl_mitarbeiter)||2,
      km_hin: parseFloat(p.km_hin||0),
      km_zurueck: parseFloat(p.km_zurueck||0),
      fahrzeit_hin_min: parseInt(p.fahrzeit_hin_min)||0,
      fahrzeit_zurueck_min: parseInt(p.fahrzeit_zurueck_min)||0,
    };
    const sessions = [...(p.sessions||[]), neueSession];
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET status='pausiert', sessions=$1,
           fahrt_start=NULL, ankunft=NULL, abfahrt_zeit=NULL, fahrt_ende=NULL,
           arbeitszeit_min=0, fahrzeit_hin_min=0, fahrzeit_zurueck_min=0,
           km_hin=0, km_zurueck=0, gps_punkte='[]'
       WHERE id=$2 RETURNING *`,
      [JSON.stringify(sessions), req.params.id]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Auftrag fortsetzen (pausiert → fahrt) ─────────────────────────────────────
router.put('/:id/fortsetzen', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege SET status='fahrt' WHERE id=$1 RETURNING *`,
      [req.params.id]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Löschen ───────────────────────────────────────────────────────────────────

router.delete('/:id', managerMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM projekt_auftraege WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;
