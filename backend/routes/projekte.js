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

// ── Aktiver Auftrag des aktuellen Nutzers ─────────────────────────────────────

router.get('/aktiv', authMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `SELECT * FROM projekt_auftraege
       WHERE mitarbeiter_id=$1 AND status != 'abgeschlossen'
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
  const { auftraggeber_id, auftraggeber_name, auftragsnummer, anzahl_mitarbeiter, notiz } = req.body;
  try {
    const r = await pool.query(
      `INSERT INTO projekt_auftraege
         (mitarbeiter_id, mitarbeiter_name, auftraggeber_id, auftraggeber_name,
          auftragsnummer, anzahl_mitarbeiter, notiz, status, fahrt_start)
       VALUES ($1,$2,$3,$4,$5,$6,$7,'fahrt',NOW()) RETURNING *`,
      [req.user.id, req.user.name, auftraggeber_id||null, auftraggeber_name||null,
       auftragsnummer||null, anzahl_mitarbeiter||2, notiz||null]
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
  const { montagewert_netto, gutschrift_betrag, gutschrift_datum, gutschrift_nummer } = req.body;
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET montagewert_netto=$1, gutschrift_betrag=$2, gutschrift_datum=$3, gutschrift_nummer=$4
       WHERE id=$5 RETURNING *`,
      [montagewert_netto||null, gutschrift_betrag||null, gutschrift_datum||null, gutschrift_nummer||null, req.params.id]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Allgemeines Update ────────────────────────────────────────────────────────

router.put('/:id', authMiddleware, async (req, res) => {
  const { notiz, besonderheiten, anzahl_mitarbeiter, auftragsnummer } = req.body;
  try {
    const r = await pool.query(
      `UPDATE projekt_auftraege
       SET notiz=$1, besonderheiten=$2, anzahl_mitarbeiter=$3, auftragsnummer=$4
       WHERE id=$5 RETURNING *`,
      [notiz||null, besonderheiten||null, anzahl_mitarbeiter||2, auftragsnummer||null, req.params.id]
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
