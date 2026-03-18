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

// Projekte löschen
router.delete('/reset/projekte', adminMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM projekt_auftraege');
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Firmendaten laden
router.get('/firma', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM firma_einstellungen WHERE id=1');
    res.json(result.rows[0] || {});
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Firmendaten speichern (nur Admin)
router.put('/firma', adminMiddleware, async (req, res) => {
  const { name, anschrift, uid_atu, logo_base64 } = req.body;
  try {
    const result = await pool.query(
      `INSERT INTO firma_einstellungen (id, name, anschrift, uid_atu, logo_base64)
       VALUES (1, $1, $2, $3, $4)
       ON CONFLICT (id) DO UPDATE SET
         name=EXCLUDED.name, anschrift=EXCLUDED.anschrift,
         uid_atu=EXCLUDED.uid_atu, logo_base64=EXCLUDED.logo_base64
       RETURNING *`,
      [name || null, anschrift || null, uid_atu || null, logo_base64 || null]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
