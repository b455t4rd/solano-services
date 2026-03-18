const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, adminMiddleware, managerMiddleware } = require('../middleware/auth');

// Alle TODOs (Manager+) – optional ?erledigt=false für nur offene
router.get('/', managerMiddleware, async (req, res) => {
  const { erledigt } = req.query;
  try {
    let query = `
      SELECT t.*, a.name as anlage_name, a.adresse,
        COALESCE(
          json_agg(
            json_build_object('id', tz.mitarbeiter_id, 'name', tz.mitarbeiter_name)
          ) FILTER (WHERE tz.mitarbeiter_id IS NOT NULL),
          '[]'
        ) as zuweisungen
      FROM todos t
      LEFT JOIN anlagen a ON a.id = t.anlage_id
      LEFT JOIN todo_zuweisungen tz ON tz.todo_id = t.id
    `;
    if (erledigt === 'false') query += ' WHERE t.erledigt = false';
    query += ' GROUP BY t.id, a.name, a.adresse ORDER BY t.erstellt_am DESC';
    const result = await pool.query(query);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Meine zugewiesenen TODOs (Mitarbeiter)
router.get('/meine', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT t.*, a.name as anlage_name, a.adresse
      FROM todos t
      LEFT JOIN anlagen a ON a.id = t.anlage_id
      JOIN todo_zuweisungen tz ON tz.todo_id = t.id AND tz.mitarbeiter_id = $1
      WHERE t.erledigt = false
      ORDER BY t.erstellt_am DESC
    `, [req.user.id]);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// TODO erstellen (Mitarbeiter während Einsatz)
router.post('/', authMiddleware, async (req, res) => {
  const { anlage_id, einsatz_id, beschreibung } = req.body;
  if (!beschreibung) return res.status(400).json({ error: 'Beschreibung erforderlich' });
  try {
    const result = await pool.query(
      `INSERT INTO todos (anlage_id, einsatz_id, mitarbeiter, mitarbeiter_id, beschreibung)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [anlage_id || null, einsatz_id || null, req.user.name, req.user.id, beschreibung]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// TODO zuweisen (Manager+): body { zuweisungen: [{id, name}] }
router.put('/:id/zuweisen', managerMiddleware, async (req, res) => {
  const { zuweisungen } = req.body; // array of {id, name}
  if (!Array.isArray(zuweisungen)) return res.status(400).json({ error: 'zuweisungen muss ein Array sein' });
  try {
    await pool.query('DELETE FROM todo_zuweisungen WHERE todo_id=$1', [req.params.id]);
    for (const z of zuweisungen) {
      await pool.query(
        'INSERT INTO todo_zuweisungen (todo_id, mitarbeiter_id, mitarbeiter_name) VALUES ($1,$2,$3) ON CONFLICT DO NOTHING',
        [req.params.id, z.id, z.name]
      );
    }
    // Aktualisiere auch die legacy-Spalten (erste Zuweisung)
    const first = zuweisungen[0] || null;
    await pool.query(
      'UPDATE todos SET zugewiesen_an_id=$1, zugewiesen_an=$2 WHERE id=$3',
      [first?.id || null, first?.name || null, req.params.id]
    );
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// TODO erledigt/offen markieren (Manager oder zugewiesener Mitarbeiter)
router.put('/:id', authMiddleware, async (req, res) => {
  try {
    // Berechtigung: Manager darf alles; Mitarbeiter nur eigene zugewiesenen TODOs
    const isManager = req.user.ist_admin || req.user.ist_chef;
    if (!isManager) {
      const zuweisung = await pool.query(
        'SELECT 1 FROM todo_zuweisungen WHERE todo_id=$1 AND mitarbeiter_id=$2',
        [req.params.id, req.user.id]
      );
      if (!zuweisung.rows.length) {
        return res.status(403).json({ error: 'Kein Zugriff' });
      }
    }
    const current = await pool.query('SELECT erledigt FROM todos WHERE id=$1', [req.params.id]);
    if (!current.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    const neu = !current.rows[0].erledigt;
    const result = await pool.query(
      `UPDATE todos SET erledigt=$1, erledigt_am=$2, erledigt_von=$3 WHERE id=$4 RETURNING *`,
      [neu, neu ? new Date() : null, neu ? req.user.name : null, req.params.id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// TODO löschen (Manager+)
router.delete('/:id', managerMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM todos WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── PRIVATE TODOS (nur eigene, 100% privat) ──

// Eigene private Todos abrufen
router.get('/privat', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM todos_privat WHERE mitarbeiter_id=$1 ORDER BY erstellt_am DESC',
      [req.user.id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Neues privates Todo anlegen
router.post('/privat', authMiddleware, async (req, res) => {
  const { beschreibung } = req.body;
  if (!beschreibung) return res.status(400).json({ error: 'Beschreibung erforderlich' });
  try {
    const result = await pool.query(
      'INSERT INTO todos_privat (mitarbeiter_id, beschreibung) VALUES ($1,$2) RETURNING *',
      [req.user.id, beschreibung]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Privates Todo toggle erledigt
router.put('/privat/:id', authMiddleware, async (req, res) => {
  try {
    const check = await pool.query(
      'SELECT erledigt FROM todos_privat WHERE id=$1 AND mitarbeiter_id=$2',
      [req.params.id, req.user.id]
    );
    if (!check.rows.length) return res.status(403).json({ error: 'Kein Zugriff' });
    const result = await pool.query(
      'UPDATE todos_privat SET erledigt=$1 WHERE id=$2 AND mitarbeiter_id=$3 RETURNING *',
      [!check.rows[0].erledigt, req.params.id, req.user.id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Privates Todo löschen
router.delete('/privat/:id', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'DELETE FROM todos_privat WHERE id=$1 AND mitarbeiter_id=$2 RETURNING id',
      [req.params.id, req.user.id]
    );
    if (!result.rows.length) return res.status(403).json({ error: 'Kein Zugriff' });
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
