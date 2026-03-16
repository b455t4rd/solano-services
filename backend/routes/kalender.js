const express = require('express');
const router  = express.Router();
const pool    = require('../db');
const { authMiddleware, managerMiddleware, adminMiddleware } = require('../middleware/auth');

// GET /api/kalender/settings  (managerMiddleware) – ohne Passwort
router.get('/settings', managerMiddleware, async (req, res) => {
  try {
    const r = await pool.query('SELECT id, exchange_url, exchange_user, sync_intervall_min, letzter_sync FROM kalender_settings WHERE id=1');
    if (!r.rows.length) return res.json({ id:1, exchange_url:'', exchange_user:'', sync_intervall_min:15, letzter_sync:null });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// PUT /api/kalender/settings  (adminMiddleware)
router.put('/settings', adminMiddleware, async (req, res) => {
  const { exchange_url, exchange_user, exchange_pass, sync_intervall_min } = req.body;
  try {
    const r = await pool.query(
      `INSERT INTO kalender_settings (id, exchange_url, exchange_user, exchange_pass, sync_intervall_min)
       VALUES (1,$1,$2,$3,$4)
       ON CONFLICT (id) DO UPDATE SET
         exchange_url       = EXCLUDED.exchange_url,
         exchange_user      = EXCLUDED.exchange_user,
         exchange_pass      = COALESCE(NULLIF(EXCLUDED.exchange_pass,''), kalender_settings.exchange_pass),
         sync_intervall_min = EXCLUDED.sync_intervall_min
       RETURNING id, exchange_url, exchange_user, sync_intervall_min, letzter_sync`,
      [exchange_url||null, exchange_user||null, exchange_pass||null, sync_intervall_min||15]
    );
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST /api/kalender/sync  (managerMiddleware) – manueller Sync
router.post('/sync', managerMiddleware, async (req, res) => {
  try {
    const sr = await pool.query('SELECT * FROM kalender_settings WHERE id=1');
    if (!sr.rows.length || !sr.rows[0].exchange_url)
      return res.status(400).json({ error: 'Exchange-Einstellungen nicht konfiguriert' });
    const settings = sr.rows[0];
    if (!settings.exchange_user || !settings.exchange_pass)
      return res.status(400).json({ error: 'Exchange Benutzername oder Passwort fehlt' });

    const count = await syncFromExchange(settings);
    await pool.query('UPDATE kalender_settings SET letzter_sync=NOW() WHERE id=1');
    res.json({ success:true, count, letzter_sync: new Date().toISOString() });
  } catch (err) {
    console.error('Kalender-Sync Fehler:', err.message);
    res.status(500).json({ error: err.message });
  }
});

// GET /api/kalender/events  (authMiddleware)
router.get('/events', authMiddleware, async (req, res) => {
  try {
    const { von, bis, mitarbeiter_id } = req.query;
    let q = 'SELECT * FROM kalender_events WHERE 1=1';
    const params = [];

    if (von) { params.push(von); q += ` AND start_zeit >= $${params.length}`; }
    if (bis)  { params.push(bis); q += ` AND start_zeit <= $${params.length}`; }

    // Mitarbeiter sehen nur eigene Events
    const isMgr = req.user.ist_admin || req.user.ist_chef;
    if (!isMgr) {
      params.push(req.user.id);
      params.push(`%${req.user.name}%`);
      q += ` AND (mitarbeiter_ids @> ARRAY[$${params.length-1}]::INTEGER[] OR organisator ILIKE $${params.length})`;
    } else if (mitarbeiter_id) {
      params.push(parseInt(mitarbeiter_id));
      q += ` AND mitarbeiter_ids @> ARRAY[$${params.length}]::INTEGER[]`;
    }

    q += ' ORDER BY start_zeit ASC';
    const r = await pool.query(q, params);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── EWS SYNC ─────────────────────────────────────────────────────────────────
async function syncFromExchange(settings) {
  let NtlmClient;
  try { NtlmClient = require('node-ews'); }
  catch(e) { throw new Error('node-ews nicht installiert. Bitte "npm install node-ews" ausführen.'); }

  const ews = new NtlmClient({
    username: settings.exchange_user,
    password: settings.exchange_pass,
    host:     settings.exchange_url,
    auth:     'ntlm'
  });

  const now    = new Date();
  const future = new Date(now);
  future.setDate(future.getDate() + 60);

  const ewsArgs = {
    attributes: { Traversal: 'Shallow' },
    ItemShape: { BaseShape: 'AllProperties' },
    CalendarView: {
      attributes: {
        MaxReturnsPerPage: '200',
        StartDate: now.toISOString(),
        EndDate:   future.toISOString()
      }
    },
    ParentFolderIds: {
      DistinguishedFolderId: { attributes: { Id: 'calendar' } }
    }
  };

  const result = await ews.run('FindItem', ewsArgs);
  const rootFolder = result?.ResponseMessages?.FindItemResponseMessage?.RootFolder;
  if (!rootFolder) return 0;

  const itemsRaw = rootFolder?.Items?.CalendarItem;
  if (!itemsRaw) return 0;
  const items = Array.isArray(itemsRaw) ? itemsRaw : [itemsRaw];

  let count = 0;
  for (const item of items) {
    try {
      const ewsId = item?.ItemId?.attributes?.Id || item?.ItemId?.Id || null;
      if (!ewsId) continue;

      const titel       = item.Subject || '(Kein Betreff)';
      const start_zeit  = item.Start   || null;
      const end_zeit    = item.End     || null;
      const ort         = item.Location || null;
      const beschreibung = typeof item.Body === 'string' ? item.Body : (item.Body?._ || null);
      const organisator  = item.Organizer?.Mailbox?.Name || item.Organizer?.Mailbox?.EmailAddress || null;

      await pool.query(
        `INSERT INTO kalender_events (id,titel,start_zeit,end_zeit,ort,beschreibung,organisator,mitarbeiter_ids,synced_at)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,NOW())
         ON CONFLICT (id) DO UPDATE SET
           titel=EXCLUDED.titel, start_zeit=EXCLUDED.start_zeit, end_zeit=EXCLUDED.end_zeit,
           ort=EXCLUDED.ort, beschreibung=EXCLUDED.beschreibung, organisator=EXCLUDED.organisator,
           synced_at=NOW()`,
        [ewsId, titel, start_zeit, end_zeit, ort,
         beschreibung ? String(beschreibung).substring(0,2000) : null,
         organisator, []]
      );
      count++;
    } catch(e) { console.error('Fehler bei Kalendereintrag:', e.message); }
  }
  return count;
}

// ── AUTO-SYNC ─────────────────────────────────────────────────────────────────
let _syncTimer = null;
async function scheduleAutoSync() {
  try {
    const r = await pool.query('SELECT * FROM kalender_settings WHERE id=1');
    if (!r.rows.length || !r.rows[0].exchange_url || !r.rows[0].exchange_pass) return;
    const settings = r.rows[0];
    const ms = (settings.sync_intervall_min || 15) * 60 * 1000;
    if (_syncTimer) clearTimeout(_syncTimer);
    _syncTimer = setTimeout(async () => {
      try {
        await syncFromExchange(settings);
        await pool.query('UPDATE kalender_settings SET letzter_sync=NOW() WHERE id=1');
        console.log('Kalender Auto-Sync:', new Date().toISOString());
      } catch(e) { console.error('Kalender Auto-Sync Fehler:', e.message); }
      scheduleAutoSync();
    }, ms);
  } catch(e) { setTimeout(scheduleAutoSync, 60000); }
}
setTimeout(scheduleAutoSync, 10000);

module.exports = router;
