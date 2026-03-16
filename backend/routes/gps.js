const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, adminMiddleware, managerMiddleware } = require('../middleware/auth');

// GPS Punkt speichern
router.post('/', authMiddleware, async (req, res) => {
  const { einsatz_id, lat, lng, genauigkeit } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO gps_tracks (einsatz_id, lat, lng, zeitpunkt, genauigkeit) VALUES ($1, $2, $3, NOW(), $4) RETURNING id',
      [einsatz_id, lat, lng, genauigkeit || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Batch GPS Punkte (für Offline-Sync)
router.post('/batch', authMiddleware, async (req, res) => {
  const { punkte } = req.body;
  if (!Array.isArray(punkte) || !punkte.length) {
    return res.status(400).json({ error: 'Keine Punkte übergeben' });
  }
  try {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      for (const p of punkte) {
        await client.query(
          'INSERT INTO gps_tracks (einsatz_id, lat, lng, zeitpunkt, genauigkeit) VALUES ($1, $2, $3, $4, $5)',
          [p.einsatz_id, p.lat, p.lng, p.zeitpunkt || new Date(), p.genauigkeit || null]
        );
      }
      await client.query('COMMIT');
      res.json({ gespeichert: punkte.length });
    } catch (e) {
      await client.query('ROLLBACK');
      throw e;
    } finally {
      client.release();
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Aktuelle Positionen aller Mitarbeiter im aktiven Einsatz (Admin)
router.get('/aktuell', managerMiddleware, async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT DISTINCT ON (e.mitarbeiter_id)
        e.mitarbeiter_id, e.mitarbeiter, g.lat, g.lng, g.zeitpunkt, g.genauigkeit,
        a.name as anlage_name, a.adresse
      FROM gps_tracks g
      JOIN einsaetze e ON e.id = g.einsatz_id
      JOIN anlagen a ON a.id = e.anlage_id
      WHERE e.end_zeit IS NULL
        AND g.zeitpunkt > NOW() - INTERVAL '2 hours'
      ORDER BY e.mitarbeiter_id, g.zeitpunkt DESC
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
