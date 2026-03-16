const express = require('express');
const router = express.Router();
const pool = require('../db');
const { adminMiddleware, authMiddleware } = require('../middleware/auth');

// PIN-Verifikation (für gefährliche Aktionen)
router.post('/verify-pin', authMiddleware, async (req, res) => {
  const { pin } = req.body;
  if (!pin) return res.status(400).json({ error: 'PIN erforderlich' });
  try {
    const r = await pool.query(
      'SELECT id FROM mitarbeiter WHERE pin=$1 AND ist_admin=true AND aktiv=true',
      [pin]
    );
    res.json({ ok: r.rows.length > 0 });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Alarme löschen
router.delete('/reset/alarme', adminMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM alarm_bestaetigung');
    await pool.query('DELETE FROM alarm_log');
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Nachrichten löschen
router.delete('/reset/nachrichten', adminMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM nachrichten');
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// TODOs löschen
router.delete('/reset/todos', adminMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM todo_zuweisungen');
    await pool.query('DELETE FROM todos');
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Einsätze & Berichte löschen
router.delete('/reset/einsaetze', adminMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM gps_tracks');
    await pool.query('DELETE FROM erledigte_aufgaben');
    await pool.query('DELETE FROM einsatz_fotos');
    await pool.query('DELETE FROM einsaetze');
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Anlagen löschen (cascaded)
router.delete('/reset/anlagen', adminMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM gps_tracks');
    await pool.query('DELETE FROM erledigte_aufgaben');
    await pool.query('DELETE FROM einsatz_fotos');
    await pool.query('DELETE FROM einsaetze');
    await pool.query('DELETE FROM todo_zuweisungen');
    await pool.query('DELETE FROM todos');
    await pool.query('DELETE FROM benutzer_anlage_reihenfolge');
    await pool.query('DELETE FROM aufgaben');
    await pool.query('DELETE FROM anlagen');
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
