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

// Alarm auslösen (Manager+)
router.post('/ausloesen', managerMiddleware, async (req, res) => {
  try {
    // Alle Mitarbeiter mit winterdienst_alarm=true + aktive Push-Subscriptions
    const subs = await pool.query(`
      SELECT ps.subscription_json, ps.mitarbeiter_id, ps.mitarbeiter_name
      FROM push_subscriptions ps
      JOIN mitarbeiter m ON m.id = ps.mitarbeiter_id
      WHERE m.winterdienst_alarm = true AND m.aktiv = true
    `);

    // Alarm-Log Eintrag
    const logResult = await pool.query(
      'INSERT INTO alarm_log (gesendet_von, empfaenger_count) VALUES ($1, $2) RETURNING id',
      [req.user.name, subs.rows.length]
    );
    const alarmId = logResult.rows[0].id;

    const payload = JSON.stringify({
      title: '🚨 WINTERDIENST ALARM',
      body: 'Sofortige Alarmierung! Bitte App öffnen und bestätigen.',
      icon: '/Logo.png',
      data: { url: `/?page=alarm&id=${alarmId}`, alarm: true }
    });

    let erfolg = 0, fehler = 0;
    for (const row of subs.rows) {
      try {
        await webpush.sendNotification(JSON.parse(row.subscription_json), payload);
        erfolg++;
      } catch (e) {
        fehler++;
        if (e.statusCode === 410) {
          await pool.query('DELETE FROM push_subscriptions WHERE subscription_json=$1', [row.subscription_json]);
        }
      }
    }

    res.json({ alarmId, erfolg, fehler, gesamt: subs.rows.length });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Alarm bestätigen (Mitarbeiter)
router.post('/:id/bestaetigen', authMiddleware, async (req, res) => {
  try {
    await pool.query(
      `INSERT INTO alarm_bestaetigung (alarm_id, mitarbeiter_id, mitarbeiter_name)
       VALUES ($1, $2, $3) ON CONFLICT (alarm_id, mitarbeiter_id) DO NOTHING`,
      [req.params.id, req.user.id, req.user.name]
    );
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Alarm-Log mit Bestätigungen (Manager+)
router.get('/log', managerMiddleware, async (req, res) => {
  try {
    const logs = await pool.query('SELECT * FROM alarm_log ORDER BY gesendet_am DESC LIMIT 50');
    const best = await pool.query('SELECT * FROM alarm_bestaetigung ORDER BY bestaetigt_am DESC');
    const result = logs.rows.map(l => ({
      ...l,
      bestaetigungen: best.rows.filter(b => b.alarm_id === l.id)
    }));
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
