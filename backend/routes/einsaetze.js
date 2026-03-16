const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, adminMiddleware, managerMiddleware } = require('../middleware/auth');

// WICHTIG: Spezifische Routen vor /:id definieren!

// Admin: Alle Berichte (Query-Param-Filter)
router.get('/berichte', managerMiddleware, async (req, res) => {
  const { von, bis, anlage_id, mitarbeiter, sparte } = req.query;
  try {
    let query = `
      SELECT e.*,
        EXTRACT(EPOCH FROM (COALESCE(e.end_zeit, e.start_zeit) - e.start_zeit))/60 as dauer_minuten,
        COUNT(ea.id) as aufgaben_erledigt,
        (SELECT COUNT(*) FROM aufgaben auf
         WHERE auf.anlage_id = e.anlage_id
           AND (auf.sparte = e.sparte OR auf.sparte IS NULL OR auf.sparte = '')) as aufgaben_gesamt,
        a.name as anlage_name, a.adresse, a.in_winterdienst, a.in_gebaeudereinigung,
        e.gps_check_ok
      FROM einsaetze e
      LEFT JOIN erledigte_aufgaben ea ON ea.einsatz_id = e.id
      JOIN anlagen a ON a.id = e.anlage_id
      WHERE e.datum >= COALESCE($1::date, CURRENT_DATE - INTERVAL '30 days')
        AND e.datum <= COALESCE($2::date, CURRENT_DATE)
    `;
    const params = [von || null, bis || null];
    if (anlage_id) { params.push(anlage_id); query += ` AND e.anlage_id = $${params.length}`; }
    if (mitarbeiter) { params.push(mitarbeiter); query += ` AND e.mitarbeiter = $${params.length}`; }
    if (sparte) { params.push(sparte); query += ` AND e.sparte = $${params.length}`; }
    query += ' GROUP BY e.id, a.name, a.adresse, a.in_winterdienst, a.in_gebaeudereinigung ORDER BY e.datum DESC, e.start_zeit DESC';
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Einsatz starten
router.post('/start', authMiddleware, async (req, res) => {
  const { anlage_id, sparte, gps_check_ok } = req.body;
  if (!anlage_id) return res.status(400).json({ error: 'anlage_id erforderlich' });
  try {
    const result = await pool.query(
      `INSERT INTO einsaetze (anlage_id, mitarbeiter, mitarbeiter_id, datum, start_zeit, sparte, gps_check_ok)
       VALUES ($1, $2, $3, CURRENT_DATE, NOW(), $4, $5) RETURNING *`,
      [anlage_id, req.user.name, req.user.id, sparte || 'winterdienst', gps_check_ok ?? null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Einsatz beenden
router.put('/:id/ende', authMiddleware, async (req, res) => {
  const { notiz } = req.body;
  try {
    const result = await pool.query(
      'UPDATE einsaetze SET end_zeit=NOW(), notiz=$1 WHERE id=$2 RETURNING *',
      [notiz || null, req.params.id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Aufgabe umschalten (erledigt / nicht erledigt)
router.post('/:id/aufgabe', authMiddleware, async (req, res) => {
  const { aufgabe_id } = req.body;
  try {
    const existing = await pool.query(
      'SELECT id FROM erledigte_aufgaben WHERE einsatz_id=$1 AND aufgabe_id=$2',
      [req.params.id, aufgabe_id]
    );
    if (existing.rows.length) {
      await pool.query(
        'DELETE FROM erledigte_aufgaben WHERE einsatz_id=$1 AND aufgabe_id=$2',
        [req.params.id, aufgabe_id]
      );
      res.json({ erledigt: false });
    } else {
      await pool.query(
        'INSERT INTO erledigte_aufgaben (einsatz_id, aufgabe_id) VALUES ($1, $2)',
        [req.params.id, aufgabe_id]
      );
      res.json({ erledigt: true });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Alle Einsätze (Admin: alle; Mitarbeiter: nur eigene)
router.get('/', authMiddleware, async (req, res) => {
  const { datum, anlage_id } = req.query;
  try {
    let query = `
      SELECT e.*, a.name as anlage_name, a.adresse, a.sparte,
        EXTRACT(EPOCH FROM (COALESCE(e.end_zeit, e.start_zeit) - e.start_zeit))/60 as dauer_minuten
      FROM einsaetze e
      JOIN anlagen a ON a.id = e.anlage_id
      WHERE 1=1
    `;
    const params = [];
    if (!req.user.ist_admin) {
      params.push(req.user.id);
      query += ` AND e.mitarbeiter_id = $${params.length}`;
    }
    if (datum) { params.push(datum); query += ` AND e.datum = $${params.length}`; }
    if (anlage_id) { params.push(anlage_id); query += ` AND e.anlage_id = $${params.length}`; }
    query += ' ORDER BY e.start_zeit DESC LIMIT 200';
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Nicht erledigte Aufgaben eines Einsatzes
router.get('/:id/unerledigt', authMiddleware, async (req, res) => {
  try {
    const ei = await pool.query('SELECT anlage_id, sparte FROM einsaetze WHERE id=$1', [req.params.id]);
    if (!ei.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    const { anlage_id, sparte } = ei.rows[0];
    const result = await pool.query(`
      SELECT auf.id, auf.bezeichnung FROM aufgaben auf
      WHERE auf.anlage_id = $1
        AND (auf.sparte = $2 OR auf.sparte IS NULL OR auf.sparte = '')
        AND auf.id NOT IN (SELECT aufgabe_id FROM erledigte_aufgaben WHERE einsatz_id = $3)
    `, [anlage_id, sparte || 'winterdienst', req.params.id]);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Einsatz Details (inkl. erledigte Aufgaben + Fotos)
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const einsatz = await pool.query(`
      SELECT e.*, a.name as anlage_name, a.adresse, a.sparte,
        EXTRACT(EPOCH FROM (COALESCE(e.end_zeit, NOW()) - e.start_zeit))/60 as dauer_minuten
      FROM einsaetze e
      JOIN anlagen a ON a.id = e.anlage_id
      WHERE e.id = $1
    `, [req.params.id]);
    if (!einsatz.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });

    const erledigte = await pool.query(`
      SELECT ea.aufgabe_id, auf.bezeichnung
      FROM erledigte_aufgaben ea
      JOIN aufgaben auf ON auf.id = ea.aufgabe_id
      WHERE ea.einsatz_id = $1
    `, [req.params.id]);

    const fotos = await pool.query(
      'SELECT * FROM einsatz_fotos WHERE einsatz_id=$1 ORDER BY hochgeladen_am',
      [req.params.id]
    );

    res.json({
      ...einsatz.rows[0],
      erledigte_aufgaben: erledigte.rows,
      fotos: fotos.rows
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Einsatz löschen (Admin)
router.delete('/:id', managerMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM erledigte_aufgaben WHERE einsatz_id=$1', [req.params.id]);
    await pool.query('DELETE FROM einsatz_fotos WHERE einsatz_id=$1', [req.params.id]);
    await pool.query('DELETE FROM gps_punkte WHERE einsatz_id=$1', [req.params.id]);
    await pool.query('DELETE FROM todos WHERE einsatz_id=$1', [req.params.id]);
    await pool.query('DELETE FROM einsaetze WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
