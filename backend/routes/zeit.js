const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, managerMiddleware } = require('../middleware/auth');

// ── Heutiger Status (eigene Einträge) ─────────────────────────────────────────
router.get('/heute', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `SELECT * FROM zeiterfassung WHERE mitarbeiter_id=$1 AND datum=CURRENT_DATE ORDER BY zeitpunkt ASC`,
      [req.user.id]
    );
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Stempeln (eigener Eintrag, optional rückwirkend) ─────────────────────────
router.post('/stempeln', authMiddleware, async (req, res) => {
  const { typ, notiz, zeitpunkt } = req.body;
  const erlaubt = ['kommen','gehen','pause_start','pause_ende','urlaub','krankenstand'];
  if (!erlaubt.includes(typ)) return res.status(400).json({ error: 'Ungültiger Typ' });
  try {
    const zp = zeitpunkt ? new Date(zeitpunkt) : new Date();
    const datum = zp.toISOString().split('T')[0];
    const r = await pool.query(
      `INSERT INTO zeiterfassung (mitarbeiter_id,mitarbeiter_name,typ,zeitpunkt,datum,notiz)
       VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`,
      [req.user.id, req.user.name, typ, zp, datum, notiz||null]
    );
    res.status(201).json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Manager: Eintrag für beliebigen MA hinzufügen (mit Audit) ─────────────────
router.post('/eintragen', managerMiddleware, async (req, res) => {
  const { mitarbeiter_id, typ, zeitpunkt, notiz } = req.body;
  const erlaubt = ['kommen','gehen','pause_start','pause_ende','urlaub','krankenstand'];
  if (!erlaubt.includes(typ) || !mitarbeiter_id || !zeitpunkt)
    return res.status(400).json({ error: 'mitarbeiter_id, typ und zeitpunkt erforderlich' });
  try {
    const ma = await pool.query('SELECT name FROM mitarbeiter WHERE id=$1', [mitarbeiter_id]);
    if (!ma.rows.length) return res.status(404).json({ error: 'Mitarbeiter nicht gefunden' });
    const zp = new Date(zeitpunkt);
    const datum = zp.toISOString().split('T')[0];
    const r = await pool.query(
      `INSERT INTO zeiterfassung
         (mitarbeiter_id,mitarbeiter_name,typ,zeitpunkt,datum,notiz,geaendert_von_id,geaendert_von_name,geaendert_am)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,NOW()) RETURNING *`,
      [mitarbeiter_id, ma.rows[0].name, typ, zp, datum, notiz||null, req.user.id, req.user.name]
    );
    res.status(201).json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Manager: Eintrag korrigieren (mit Audit) ──────────────────────────────────
router.put('/korrigieren/:id', managerMiddleware, async (req, res) => {
  const { zeitpunkt, notiz, typ } = req.body;
  try {
    const alt = await pool.query('SELECT * FROM zeiterfassung WHERE id=$1', [req.params.id]);
    if (!alt.rows.length) return res.status(404).json({ error: 'Eintrag nicht gefunden' });

    const sets = [], params = [];
    if (zeitpunkt !== undefined) {
      const zp = new Date(zeitpunkt);
      params.push(zp); sets.push(`zeitpunkt=$${params.length}`);
      params.push(zp.toISOString().split('T')[0]); sets.push(`datum=$${params.length}`);
      if (!alt.rows[0].original_zeitpunkt) {
        params.push(alt.rows[0].zeitpunkt); sets.push(`original_zeitpunkt=$${params.length}`);
      }
    }
    if (notiz !== undefined) { params.push(notiz); sets.push(`notiz=$${params.length}`); }
    if (typ)                 { params.push(typ);   sets.push(`typ=$${params.length}`); }
    params.push(req.user.id);   sets.push(`geaendert_von_id=$${params.length}`);
    params.push(req.user.name); sets.push(`geaendert_von_name=$${params.length}`);
    sets.push(`geaendert_am=NOW()`);
    params.push(req.params.id);
    const r = await pool.query(
      `UPDATE zeiterfassung SET ${sets.join(',')} WHERE id=$${params.length} RETURNING *`, params
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Aktuell eingestempelte MA (Manager+) ─────────────────────────────────────
router.get('/eingestempelt', managerMiddleware, async (req, res) => {
  try {
    // MA die heute 'kommen' haben aber kein 'gehen'
    const r = await pool.query(
      `SELECT DISTINCT ON (z.mitarbeiter_id)
         z.mitarbeiter_id, z.mitarbeiter_name, z.zeitpunkt AS kommen_seit
       FROM zeiterfassung z
       WHERE z.datum = CURRENT_DATE AND z.typ = 'kommen'
         AND NOT EXISTS (
           SELECT 1 FROM zeiterfassung g
           WHERE g.mitarbeiter_id = z.mitarbeiter_id
             AND g.datum = CURRENT_DATE AND g.typ = 'gehen'
         )
       ORDER BY z.mitarbeiter_id, z.zeitpunkt ASC`
    );
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Admin: MA manuell ausstempeln ─────────────────────────────────────────────
router.post('/ausstempeln-admin', managerMiddleware, async (req, res) => {
  const { mitarbeiter_id, zeitpunkt } = req.body;
  if (!mitarbeiter_id) return res.status(400).json({ error: 'mitarbeiter_id fehlt' });
  try {
    const zp = zeitpunkt ? new Date(zeitpunkt) : new Date();
    const datum = zp.toISOString().split('T')[0];
    // MA-Name holen
    const mRow = await pool.query('SELECT name FROM mitarbeiter WHERE id=$1', [mitarbeiter_id]);
    const maName = mRow.rows[0]?.name || 'Unbekannt';
    const r = await pool.query(
      `INSERT INTO zeiterfassung (mitarbeiter_id, mitarbeiter_name, typ, zeitpunkt, datum, notiz)
       VALUES ($1,$2,'gehen',$3,$4,'Admin-Ausstempelung') RETURNING *`,
      [mitarbeiter_id, maName, zp, datum]
    );
    res.status(201).json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Auswertung (Manager+) mit Soll/Ist/Saldo ─────────────────────────────────
router.get('/auswertung', managerMiddleware, async (req, res) => {
  const { von, bis, mitarbeiter_id } = req.query;
  try {
    let q = `SELECT z.*, m.soll_stunden, m.beschaeftigung
             FROM zeiterfassung z
             JOIN mitarbeiter m ON m.id = z.mitarbeiter_id
             WHERE 1=1`;
    const p = [];
    if (von)            { p.push(von);            q += ` AND z.datum>=$${p.length}`; }
    if (bis)            { p.push(bis);            q += ` AND z.datum<=$${p.length}`; }
    if (mitarbeiter_id) { p.push(mitarbeiter_id); q += ` AND z.mitarbeiter_id=$${p.length}`; }
    q += ' ORDER BY z.mitarbeiter_id, z.datum, z.zeitpunkt';
    const rows = (await pool.query(q, p)).rows;

    // Feiertage laden
    let fqP = [], fq = 'SELECT datum FROM feiertage WHERE 1=1';
    if (von) { fqP.push(von); fq += ` AND datum>=$${fqP.length}`; }
    if (bis) { fqP.push(bis); fq += ` AND datum<=$${fqP.length}`; }
    const ftSet = new Set((await pool.query(fq, fqP)).rows.map(r =>
      (r.datum instanceof Date ? r.datum : new Date(r.datum)).toISOString().split('T')[0]
    ));

    // Gruppieren nach MA + Tag
    const tage = {};
    for (const r of rows) {
      const datStr = (r.datum instanceof Date ? r.datum : new Date(r.datum)).toISOString().split('T')[0];
      const key = `${r.mitarbeiter_id}_${datStr}`;
      if (!tage[key]) tage[key] = {
        mitarbeiter_id: r.mitarbeiter_id,
        name: r.mitarbeiter_name,
        datum: datStr,
        soll_stunden: parseFloat(r.soll_stunden) || 38.5,
        beschaeftigung: r.beschaeftigung || 'vollzeit',
        eintraege: []
      };
      tage[key].eintraege.push(r);
    }

    const auswertung = Object.values(tage).map(t => {
      const e = t.eintraege;
      let kommen = null, gehen = null, pauseMin = 0, urlaub = false, krankenstand = false;

      const istFeiertag = ftSet.has(t.datum);
      const dow = new Date(t.datum).getDay(); // 0=So,6=Sa
      const istWE = dow === 0 || dow === 6;

      for (const x of e) {
        if (x.typ === 'urlaub')      { urlaub = true; }
        if (x.typ === 'krankenstand'){ krankenstand = true; }
        if (x.typ === 'kommen' && !kommen) kommen = new Date(x.zeitpunkt);
        if (x.typ === 'gehen')              gehen  = new Date(x.zeitpunkt);
      }

      // Pausen
      let lastPS = null;
      for (const x of e) {
        if (x.typ === 'pause_start') lastPS = new Date(x.zeitpunkt);
        if (x.typ === 'pause_ende' && lastPS) {
          pauseMin += (new Date(x.zeitpunkt) - lastPS) / 60000;
          lastPS = null;
        }
      }

      // Soll pro Tag (Wochenstunden / 5 Werktage)
      const sollTag = (t.soll_stunden / 5) * 60; // Minuten

      let nettoMin = 0, sollMin = 0;
      if (istWE || istFeiertag) {
        sollMin = 0;
        if (kommen && gehen) nettoMin = Math.max(0, (gehen - kommen) / 60000 - pauseMin);
      } else if (urlaub || krankenstand) {
        sollMin  = sollTag;
        nettoMin = sollTag; // gilt als erfüllt
      } else {
        sollMin = sollTag;
        if (kommen && gehen) {
          nettoMin = Math.max(0, (gehen - kommen) / 60000 - pauseMin);
        } else if (kommen) {
          nettoMin = Math.max(0, (new Date() - kommen) / 60000 - pauseMin);
        }
      }

      return {
        mitarbeiter_id: t.mitarbeiter_id,
        name:           t.name,
        datum:          t.datum,
        kommen:         kommen?.toISOString() || null,
        gehen:          gehen?.toISOString()  || null,
        pause_minuten:  Math.round(pauseMin),
        netto_minuten:  Math.round(nettoMin),
        soll_minuten:   Math.round(sollMin),
        saldo_minuten:  Math.round(nettoMin - sollMin),
        urlaub,
        krankenstand,
        ist_feiertag:   istFeiertag,
        ist_wochenende: istWE,
        eintraege:      e
      };
    });

    res.json(auswertung);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Feiertage ─────────────────────────────────────────────────────────────────
router.get('/feiertage', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query('SELECT * FROM feiertage ORDER BY datum');
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Monatsfreigabe ────────────────────────────────────────────────────────────
router.get('/freigabe', managerMiddleware, async (req, res) => {
  try {
    const r = await pool.query('SELECT * FROM zeiterfassung_freigabe ORDER BY monat DESC, mitarbeiter_name');
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/freigabe', managerMiddleware, async (req, res) => {
  const { mitarbeiter_id, monat } = req.body; // monat = 'YYYY-MM'
  if (!mitarbeiter_id || !monat) return res.status(400).json({ error: 'mitarbeiter_id und monat erforderlich' });
  try {
    const ma = await pool.query('SELECT name FROM mitarbeiter WHERE id=$1', [mitarbeiter_id]);
    if (!ma.rows.length) return res.status(404).json({ error: 'Mitarbeiter nicht gefunden' });
    const r = await pool.query(
      `INSERT INTO zeiterfassung_freigabe
         (mitarbeiter_id,mitarbeiter_name,monat,freigegeben_von_id,freigegeben_von_name)
       VALUES ($1,$2,$3,$4,$5)
       ON CONFLICT (mitarbeiter_id,monat) DO UPDATE SET
         freigegeben_von_id=$4, freigegeben_von_name=$5, freigegeben_am=NOW()
       RETURNING *`,
      [mitarbeiter_id, ma.rows[0].name, monat+'-01', req.user.id, req.user.name]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.delete('/freigabe', managerMiddleware, async (req, res) => {
  const { mitarbeiter_id, monat } = req.query;
  try {
    await pool.query('DELETE FROM zeiterfassung_freigabe WHERE mitarbeiter_id=$1 AND monat=$2',
      [mitarbeiter_id, monat+'-01']);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Alle Einträge eines Tages löschen (Manager+) ─────────────────────────────
router.delete('/tag', managerMiddleware, async (req, res) => {
  const { mitarbeiter_id, datum } = req.query;
  if (!mitarbeiter_id || !datum) return res.status(400).json({ error: 'mitarbeiter_id und datum erforderlich' });
  try {
    await pool.query('DELETE FROM zeiterfassung WHERE mitarbeiter_id=$1 AND datum=$2', [mitarbeiter_id, datum]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Einzelnen Eintrag löschen (Manager+) ─────────────────────────────────────
router.delete('/:id', managerMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM zeiterfassung WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;
