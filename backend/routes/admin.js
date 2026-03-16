const express = require('express');
const router = express.Router();
const pool = require('../db');
const { adminMiddleware } = require('../middleware/auth');

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
