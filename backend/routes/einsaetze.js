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
        (SELECT COUNT(DISTINCT ea2.aufgabe_id) FROM erledigte_aufgaben ea2
         JOIN einsaetze e2 ON e2.id = ea2.einsatz_id
         WHERE e2.anlage_id = e.anlage_id AND e2.datum = e.datum
           AND (e2.sparte = e.sparte OR e2.sparte IS NULL OR e2.sparte = '')) as aufgaben_erledigt,
        (SELECT COUNT(*) FROM aufgaben auf
         WHERE auf.anlage_id = e.anlage_id
           AND (auf.sparte = e.sparte OR auf.sparte IS NULL OR auf.sparte = '')) as aufgaben_gesamt,
        (SELECT COUNT(*) FROM einsatz_fotos ef WHERE ef.einsatz_id = e.id) as foto_count,
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
    // Doppel-Start verhindern: existiert bereits ein offener Einsatz für diesen MA in dieser Anlage heute?
    // Unabhängig von Sparte – derselbe MA darf nicht 2x gleichzeitig in derselben Anlage sein
    const existing = await pool.query(
      `SELECT * FROM einsaetze WHERE mitarbeiter_id=$1 AND anlage_id=$2 AND datum=CURRENT_DATE
       AND end_zeit IS NULL LIMIT 1`,
      [req.user.id, anlage_id]
    );
    if (existing.rows.length > 0) return res.status(201).json(existing.rows[0]);

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

// Alle aktiven Einsätze (kein Ende)
router.get('/aktiv', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT e.id, e.anlage_id, e.mitarbeiter, e.mitarbeiter_id, e.start_zeit, e.sparte,
        a.name as anlage_name, a.adresse,
        EXTRACT(EPOCH FROM (NOW() - e.start_zeit))/60 as dauer_minuten
      FROM einsaetze e
      JOIN anlagen a ON a.id = e.anlage_id
      WHERE e.end_zeit IS NULL
      ORDER BY e.anlage_id, e.start_zeit ASC
    `);
    res.json(result.rows);
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

// Nicht erledigte Aufgaben eines Einsatzes (kombiniert über alle MA an dieser Anlage+Datum+Sparte)
router.get('/:id/unerledigt', authMiddleware, async (req, res) => {
  try {
    const ei = await pool.query('SELECT anlage_id, sparte, datum FROM einsaetze WHERE id=$1', [req.params.id]);
    if (!ei.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    const { anlage_id, sparte, datum } = ei.rows[0];
    // Aufgaben die in KEINEM Einsatz (gleiche Anlage+Datum+Sparte) erledigt wurden
    const result = await pool.query(`
      SELECT auf.id, auf.bezeichnung FROM aufgaben auf
      WHERE auf.anlage_id = $1
        AND (auf.sparte = $2 OR auf.sparte IS NULL OR auf.sparte = '')
        AND auf.id NOT IN (
          SELECT ea.aufgabe_id FROM erledigte_aufgaben ea
          JOIN einsaetze e2 ON e2.id = ea.einsatz_id
          WHERE e2.anlage_id = $1
            AND e2.datum = $3
            AND (e2.sparte = $2 OR e2.sparte IS NULL OR e2.sparte = '')
        )
    `, [anlage_id, sparte || 'winterdienst', datum]);
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

    // Kombinierte erledigte Aufgaben über ALLE MA an dieser Anlage+Datum+Sparte
    // Subquery direkt auf einsaetze-Tabelle, um a.sparte/e.sparte Namenskonflikt zu vermeiden
    const alleErledigte = await pool.query(`
      SELECT DISTINCT ea.aufgabe_id, auf.bezeichnung
      FROM erledigte_aufgaben ea
      JOIN aufgaben auf ON auf.id = ea.aufgabe_id
      JOIN einsaetze e2 ON e2.id = ea.einsatz_id
      JOIN (SELECT anlage_id, datum, sparte FROM einsaetze WHERE id = $1) ref
        ON e2.anlage_id = ref.anlage_id
        AND e2.datum = ref.datum
        AND (e2.sparte = ref.sparte OR e2.sparte IS NULL OR e2.sparte = '')
    `, [req.params.id]);

    const fotos = await pool.query(
      'SELECT * FROM einsatz_fotos WHERE einsatz_id=$1 ORDER BY hochgeladen_am',
      [req.params.id]
    );

    res.json({
      ...einsatz.rows[0],
      erledigte_aufgaben: erledigte.rows,
      alle_erledigte_aufgaben: alleErledigte.rows,
      fotos: fotos.rows.map(f => ({ ...f, mitarbeiter_name: einsatz.rows[0].mitarbeiter }))
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
    await pool.query('DELETE FROM gps_tracks WHERE einsatz_id=$1', [req.params.id]);
    await pool.query('DELETE FROM todos WHERE einsatz_id=$1', [req.params.id]);
    await pool.query('DELETE FROM einsaetze WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/monate', managerMiddleware, async (req, res) => {
  try {
    const r = await pool.query(`
      SELECT TO_CHAR(datum, 'YYYY-MM') as monat,
             COUNT(DISTINCT CONCAT(anlage_id::text, '_', datum::text, '_', COALESCE(sparte,''))) as anzahl
      FROM einsaetze
      GROUP BY 1
      ORDER BY 1 DESC
      LIMIT 48
    `);
    res.json(r.rows);
  } catch(err){ res.status(500).json({error: err.message}); }
});

module.exports = router;
