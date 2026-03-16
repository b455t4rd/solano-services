const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, adminMiddleware, managerMiddleware } = require('../middleware/auth');

// Aufgaben einer Anlage (optional nach Sparte filtern)
router.get('/anlage/:anlage_id', authMiddleware, async (req, res) => {
  const { sparte } = req.query;
  try {
    let query = 'SELECT * FROM aufgaben WHERE anlage_id=$1';
    const params = [req.params.anlage_id];
    if (sparte) {
      params.push(sparte);
      query += ` AND sparte=$${params.length}`;
    }
    query += ' ORDER BY sparte, reihenfolge, id';
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Aufgabe erstellen (Admin only)
router.post('/', managerMiddleware, async (req, res) => {
  const { anlage_id, bezeichnung, reihenfolge, sparte } = req.body;
  if (!anlage_id || !bezeichnung) return res.status(400).json({ error: 'anlage_id und bezeichnung erforderlich' });
  try {
    const result = await pool.query(
      'INSERT INTO aufgaben (anlage_id, bezeichnung, reihenfolge, sparte) VALUES ($1, $2, $3, $4) RETURNING *',
      [anlage_id, bezeichnung, reihenfolge || 0, sparte || 'winterdienst']
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Aufgabe aktualisieren (Admin only)
router.put('/:id', managerMiddleware, async (req, res) => {
  const { bezeichnung, reihenfolge, sparte } = req.body;
  try {
    const result = await pool.query(
      'UPDATE aufgaben SET bezeichnung=$1, reihenfolge=$2, sparte=COALESCE($3, sparte) WHERE id=$4 RETURNING *',
      [bezeichnung, reihenfolge || 0, sparte || null, req.params.id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Aufgabe löschen (Admin only)
router.delete('/:id', managerMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM aufgaben WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
