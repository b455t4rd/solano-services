const express = require('express');
const router = express.Router();
const pool = require('../db');
const webpush = require('web-push');
const { authMiddleware, adminMiddleware, managerMiddleware } = require('../middleware/auth');

webpush.setVapidDetails(
  process.env.VAPID_EMAIL || 'mailto:info@solano.at',
  process.env.VAPID_PUBLIC_KEY,
  process.env.VAPID_PRIVATE_KEY
);

// VAPID Public Key abrufen (Frontend braucht ihn zur Subscription)
router.get('/vapid-public-key', authMiddleware, (req, res) => {
  res.json({ publicKey: process.env.VAPID_PUBLIC_KEY });
});

// Push-Subscription speichern (eigenes Gerät anmelden)
router.post('/subscribe', authMiddleware, async (req, res) => {
  const { subscription } = req.body;
  if (!subscription?.endpoint) return res.status(400).json({ error: 'Ungültige Subscription' });
  try {
    await pool.query(`
      INSERT INTO push_subscriptions (mitarbeiter_id, mitarbeiter_name, subscription_json)
      VALUES ($1, $2, $3)
      ON CONFLICT ((subscription_json::json->>'endpoint'))
      DO UPDATE SET mitarbeiter_id=$1, mitarbeiter_name=$2, subscription_json=$3
    `, [req.user.id, req.user.name, JSON.stringify(subscription)]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Push-Nachricht senden (Admin only)
router.post('/senden', adminMiddleware, async (req, res) => {
  const { nachricht, mitarbeiter_ids } = req.body; // mitarbeiter_ids: [] = alle
  if (!nachricht) return res.status(400).json({ error: 'Nachricht erforderlich' });
  try {
    let query = 'SELECT * FROM push_subscriptions';
    const params = [];
    if (mitarbeiter_ids?.length) {
      query += ' WHERE mitarbeiter_id = ANY($1)';
      params.push(mitarbeiter_ids);
    }
    const subs = await pool.query(query, params);

    let erfolg = 0, fehler = 0;
    const payload = JSON.stringify({ title: 'SolanoServices', body: nachricht, icon: '/Logo.png' });
    for (const row of subs.rows) {
      try {
        await webpush.sendNotification(JSON.parse(row.subscription_json), payload);
        erfolg++;
      } catch (e) {
        fehler++;
        // Abgelaufene Subscriptions löschen
        if (e.statusCode === 410) {
          await pool.query('DELETE FROM push_subscriptions WHERE id=$1', [row.id]);
        }
      }
    }

    const empfaenger = mitarbeiter_ids?.length
      ? subs.rows.map(r => r.mitarbeiter_name).join(', ')
      : 'Alle';
    await pool.query(
      'INSERT INTO push_log (gesendet_von, empfaenger, nachricht, erfolg, fehler) VALUES ($1,$2,$3,$4,$5)',
      [req.user.name, empfaenger, nachricht, erfolg, fehler]
    );

    res.json({ erfolg, fehler, gesamt: subs.rows.length });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Push-Log abrufen (Admin only)
router.get('/log', adminMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM push_log ORDER BY gesendet_am DESC LIMIT 100'
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Push-Log löschen (Admin only)
router.delete('/log', adminMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM push_log');
    res.json({ success: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// Alle angemeldeten Geräte (Manager+ für Übersicht)
router.get('/abonnenten', managerMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, mitarbeiter_id, mitarbeiter_name, erstellt_am FROM push_subscriptions ORDER BY mitarbeiter_name'
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
