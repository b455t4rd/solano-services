const express = require('express');
const router = express.Router();
const pool = require('../db');
const webpush = require('web-push');
const { authMiddleware, managerMiddleware } = require('../middleware/auth');

webpush.setVapidDetails(
  process.env.VAPID_EMAIL || 'mailto:info@solano.at',
  process.env.VAPID_PUBLIC_KEY,
  process.env.VAPID_PRIVATE_KEY
);

// Alle Nachrichten abrufen (Manager: alle; Mitarbeiter: eigene)
router.get('/', authMiddleware, async (req, res) => {
  try {
    let result;
    if (req.user.ist_admin || req.user.ist_chef) {
      result = await pool.query(
        'SELECT * FROM nachrichten ORDER BY gesendet_am DESC LIMIT 200'
      );
    } else {
      result = await pool.query(
        'SELECT * FROM nachrichten WHERE an_id=$1 ORDER BY gesendet_am DESC',
        [req.user.id]
      );
    }
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Anzahl ungelesener Nachrichten (für Badge)
router.get('/ungelesen', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT COUNT(*) FROM nachrichten WHERE an_id=$1 AND gelesen=false',
      [req.user.id]
    );
    res.json({ anzahl: parseInt(result.rows[0].count) });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Nachricht senden + Push auslösen (Manager only)
router.post('/', managerMiddleware, async (req, res) => {
  const { an_id, an_name, text } = req.body;
  if (!an_id || !text) return res.status(400).json({ error: 'Empfänger und Text erforderlich' });
  try {
    const result = await pool.query(
      `INSERT INTO nachrichten (von_id, von_name, an_id, an_name, text)
       VALUES ($1,$2,$3,$4,$5) RETURNING *`,
      [req.user.id, req.user.name, an_id, an_name, text]
    );
    const nachricht = result.rows[0];

    // Push senden
    const subs = await pool.query(
      'SELECT subscription_json FROM push_subscriptions WHERE mitarbeiter_id=$1',
      [an_id]
    );
    const payload = JSON.stringify({
      title: `Nachricht von ${req.user.name}`,
      body: text,
      icon: '/Logo.png',
      data: { url: '/?page=nachrichten' }
    });
    for (const row of subs.rows) {
      try {
        await webpush.sendNotification(JSON.parse(row.subscription_json), payload);
      } catch (e) {
        if (e.statusCode === 410) {
          await pool.query('DELETE FROM push_subscriptions WHERE subscription_json=$1', [row.subscription_json]);
        }
      }
    }

    res.json(nachricht);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Nachricht beantworten: ja oder nein (eigene Nachrichten)
router.put('/:id/antwort', authMiddleware, async (req, res) => {
  const { antwort } = req.body; // 'ja' oder 'nein'
  if (!['ja', 'nein'].includes(antwort)) return res.status(400).json({ error: 'Antwort muss "ja" oder "nein" sein' });
  try {
    const result = await pool.query(
      `UPDATE nachrichten SET antwort=$1, antwort_am=NOW(), gelesen=true
       WHERE id=$2 AND an_id=$3 RETURNING *`,
      [antwort, req.params.id, req.user.id]
    );
    if (!result.rows.length) return res.status(404).json({ error: 'Nachricht nicht gefunden' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Als gelesen markieren
router.put('/:id/gelesen', authMiddleware, async (req, res) => {
  try {
    await pool.query(
      'UPDATE nachrichten SET gelesen=true WHERE id=$1 AND an_id=$2',
      [req.params.id, req.user.id]
    );
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
