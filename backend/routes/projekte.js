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
  const { name, gutschrift_prozent, stundensatz, notiz } = req.body;
  if (!name) return res.status(400).json({ error: 'Name erforderlich' });
  try {
    const r = await pool.query(
      `INSERT INTO auftraggeber (name, gutschrift_prozent, stundensatz, notiz)
       VALUES ($1,$2,$3,$4) RETURNING *`,
      [name, gutschrift_prozent || 0, stundensatz || 0, notiz || null]
    );
    res.status(201).json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/auftraggeber/:id', managerMiddleware, async (req, res) => {
  const { name, gutschrift_prozent, stundensatz, notiz, aktiv } = req.body;
  try {
    const r = await pool.query(
      `UPDATE auftraggeber SET name=$1, gutschrift_prozent=$2, stundensatz=$3, notiz=$4, aktiv=$5
       WHERE id=$6 RETURNING *`,
      [name, gutschrift_prozent||0, stundensatz||0, notiz||null, aktiv!==false, req.params.id]
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
      `SELECT * FROM projekt_auftraege WHERE status='geplant' ORDER BY erstellt_am ASC`
    );
    res.json(r.rows);
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

// ── Zum nächsten Auftrag weiterfahren (rueckfahrt-Ende = Ankunft Nächster) ────

router.put('/:id/weiter', authMiddleware, async (req, res) => {
  const { km, naechster_id, besonderheiten, notiz } = req.body;
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
           km_verbindung=$2, naechster_auftrag_id=$3,
           besonderheiten=COALESCE($4,besonderheiten), notiz=COALESCE($5,notiz)
       WHERE id=$6`,
      [now, parseFloat(km)||0, naechster_id||null, besonderheiten||null, notiz||null, req.params.id]
    );
    // Nächsten Auftrag in Arbeit starten (Verbindungsfahrt war die Anfahrt)
    const tourId = p.tour_id || require('crypto').randomUUID().split('-')[0];
    const nextPos = (p.tour_position||1) + 1;
    const r2 = await pool.query(
      `UPDATE projekt_auftraege
       SET status='arbeit', fahrt_start=$1, ankunft=$1, mitarbeiter_id=$2, mitarbeiter_name=$3,
           tour_id=$4, tour_position=$5,
           km_hin=$6, fahrzeit_hin_min=ROUND(EXTRACT(EPOCH FROM ($1-$7::timestamptz))/60)
       WHERE id=$8 RETURNING *`,
      [now, req.user.id, req.user.name, tourId, nextPos,
       parseFloat(km)||0, p.abfahrt_zeit||now, naechster_id]
    );
    // Tour-ID auch auf Vorgänger setzen wenn noch nicht gesetzt
    await pool.query(
      `UPDATE projekt_auftraege SET tour_id=$1, tour_position=$2 WHERE id=$3 AND tour_id IS NULL`,
      [tourId, p.tour_position||1, req.params.id]
    );
    res.json(r2.rows[0] || null);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Aktiver Auftrag des aktuellen Nutzers ─────────────────────────────────────

router.get('/aktiv', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `SELECT * FROM projekt_auftraege
       WHERE mitarbeiter_id=$1 AND status NOT IN ('abgeschlossen','pausiert')
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
  const { auftraggeber_id, auftraggeber_name, auftragsnummer, anzahl_mitarbeiter, notiz, geplant, kundenname, adresse } = req.body;
  const status = geplant ? 'geplant' : 'fahrt';
  try {
    const r = await pool.query(
      `INSERT INTO projekt_auftraege
         (mitarbeiter_id, mitarbeiter_name, auftraggeber_id, auftraggeber_name,
          auftragsnummer, anzahl_mitarbeiter, notiz, status, fahrt_start, kundenname, adresse)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,${geplant?'NULL':'NOW()'},$9,$10) RETURNING *`,
      [req.user.id, req.user.name, auftraggeber_id||null, auftraggeber_name||null,
       auftragsnummer||null, anzahl_mitarbeiter||2, notiz||null, status,
       kundenname||null, adresse||null]
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
  const { gutschrift_betrag, gutschrift_datum, gutschrift_nummer, arbeitszeit_manuell_min } = req.body;
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET gutschrift_betrag=$1, gutschrift_datum=$2, gutschrift_nummer=$3,
           arbeitszeit_manuell_min=COALESCE($4, arbeitszeit_manuell_min)
       WHERE id=$5 RETURNING *`,
      [gutschrift_betrag||null, gutschrift_datum||null, gutschrift_nummer||null,
       arbeitszeit_manuell_min||null, req.params.id]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Allgemeines Update ────────────────────────────────────────────────────────

router.put('/:id', authMiddleware, async (req, res) => {
  const { notiz, besonderheiten, anzahl_mitarbeiter, auftragsnummer, km_hin, km_zurueck, arbeitszeit_manuell_min, auftraggeber_id, auftraggeber_name, kundenname, adresse, rapport_erforderlich, rapport_beschreibung } = req.body;
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
           rapport_beschreibung=COALESCE($13, rapport_beschreibung)
       WHERE id=$14 RETURNING *`,
      [notiz||null, besonderheiten||null, anzahl_mitarbeiter||2, auftragsnummer||null,
       km_hin!=null?km_hin:null, km_zurueck!=null?km_zurueck:null,
       arbeitszeit_manuell_min!=null?arbeitszeit_manuell_min:null,
       auftraggeber_id||null, auftraggeber_name||null,
       kundenname||null, adresse||null,
       rapport_erforderlich!=null?rapport_erforderlich:null,
       rapport_beschreibung!=null?rapport_beschreibung:null,
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
