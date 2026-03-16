const express = require('express');
const router  = express.Router();
const pool    = require('../db');
const https   = require('https');
const http    = require('http');
const { URL }  = require('url');
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

// POST /api/kalender/sync  (managerMiddleware)
router.post('/sync', managerMiddleware, async (req, res) => {
  try {
    const sr = await pool.query('SELECT * FROM kalender_settings WHERE id=1');
    if (!sr.rows.length || !sr.rows[0].exchange_url)
      return res.status(400).json({ error: 'CalDAV-URL nicht konfiguriert' });
    const settings = sr.rows[0];
    if (!settings.exchange_user || !settings.exchange_pass)
      return res.status(400).json({ error: 'Benutzername oder Passwort fehlt' });

    const count = await syncFromCalDAV(settings);
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

// ── CalDAV HTTP-Anfrage ───────────────────────────────────────────────────────
function caldavRequest(method, urlStr, auth, body, extraHeaders = {}) {
  return new Promise((resolve, reject) => {
    const u   = new URL(urlStr);
    const lib = u.protocol === 'https:' ? https : http;
    const authHeader = 'Basic ' + Buffer.from(`${auth.user}:${auth.pass}`).toString('base64');

    const headers = {
      'Authorization': authHeader,
      'Content-Type':  'application/xml; charset=utf-8',
      'Depth':         '1',
      ...extraHeaders
    };
    if (body) headers['Content-Length'] = Buffer.byteLength(body);

    const req = lib.request({
      hostname: u.hostname,
      port:     u.port || (u.protocol === 'https:' ? 443 : 80),
      path:     u.pathname + u.search,
      method,
      headers,
      rejectUnauthorized: false // für self-signed Zertifikate (on-premises)
    }, res => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve({ status: res.statusCode, body: data }));
    });
    req.on('error', reject);
    if (body) req.write(body);
    req.end();
  });
}

// ── iCal Parser ───────────────────────────────────────────────────────────────
function parseIcal(icalStr) {
  const events = [];
  // Zeilenumbrüche normalisieren (RFC 5545 folded lines)
  const text = icalStr.replace(/\r\n /g, '').replace(/\r\n\t/g, '').replace(/\r\n/g, '\n');
  const veventBlocks = text.match(/BEGIN:VEVENT[\s\S]*?END:VEVENT/g) || [];

  for (const block of veventBlocks) {
    const get = (key) => {
      const m = block.match(new RegExp(`^${key}[;:][^\n]*`, 'm'));
      if (!m) return null;
      return m[0].replace(new RegExp(`^${key}[^:]*:`), '').trim();
    };

    const uid        = get('UID');
    const summary    = (get('SUMMARY') || '(Kein Betreff)').replace(/\\n/g, ' ').replace(/\\,/g, ',');
    const dtstart    = get('DTSTART');
    const dtend      = get('DTEND');
    const location   = (get('LOCATION') || '').replace(/\\n/g, ' ').replace(/\\,/g, ',') || null;
    const desc       = (get('DESCRIPTION') || '').replace(/\\n/g, '\n').replace(/\\,/g, ',').substring(0, 2000) || null;
    const organizer  = get('ORGANIZER')?.replace(/.*CN=/,'')?.split(':')[0] || null;

    if (!uid) continue;

    const parseDate = (d) => {
      if (!d) return null;
      // Format: 20260315T090000Z oder 20260315T090000 oder 20260315
      const clean = d.replace(/;.*/, ''); // strip TZID params
      if (clean.length === 8) return `${clean.slice(0,4)}-${clean.slice(4,6)}-${clean.slice(6,8)}T00:00:00Z`;
      return `${clean.slice(0,4)}-${clean.slice(4,6)}-${clean.slice(6,8)}T${clean.slice(9,11)}:${clean.slice(11,13)}:${clean.slice(13,15)}${clean.endsWith('Z')?'Z':''}`;
    };

    events.push({ uid, summary, dtstart: parseDate(dtstart), dtend: parseDate(dtend), location, desc, organizer });
  }
  return events;
}

// ── CalDAV Sync ────────────────────────────────────────────────────────────────
async function syncFromCalDAV(settings) {
  const auth = { user: settings.exchange_user, pass: settings.exchange_pass };
  const baseUrl = settings.exchange_url.replace(/\/$/, '');

  // Datum-Range: heute bis +60 Tage
  const now    = new Date();
  const future = new Date(now);
  future.setDate(future.getDate() + 60);

  const fmt = (d) => d.toISOString().replace(/[-:]/g,'').split('.')[0] + 'Z';

  const reportBody = `<?xml version="1.0" encoding="utf-8"?>
<C:calendar-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">
  <D:prop><D:getetag/><C:calendar-data/></D:prop>
  <C:filter>
    <C:comp-filter name="VCALENDAR">
      <C:comp-filter name="VEVENT">
        <C:time-range start="${fmt(now)}" end="${fmt(future)}"/>
      </C:comp-filter>
    </C:comp-filter>
  </C:filter>
</C:calendar-query>`;

  const resp = await caldavRequest('REPORT', baseUrl, auth, reportBody, { 'Depth': '1' });

  if (resp.status < 200 || resp.status >= 400) {
    throw new Error(`CalDAV Server Fehler ${resp.status}: ${resp.body.substring(0, 300)}`);
  }

  // Alle calendar-data Blöcke aus der XML-Antwort extrahieren
  const calDataBlocks = resp.body.match(/<[^>]*calendar-data[^>]*>([\s\S]*?)<\/[^>]*calendar-data>/gi) || [];

  // HTML-Entities dekodieren
  const decode = (s) => s.replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&amp;/g,'&').replace(/&#13;/g,'');

  let count = 0;
  for (const block of calDataBlocks) {
    const icalContent = decode(block.replace(/<[^>]+>/g, ''));
    const events = parseIcal(icalContent);

    for (const ev of events) {
      try {
        await pool.query(
          `INSERT INTO kalender_events (id,titel,start_zeit,end_zeit,ort,beschreibung,organisator,mitarbeiter_ids,synced_at)
           VALUES ($1,$2,$3,$4,$5,$6,$7,$8,NOW())
           ON CONFLICT (id) DO UPDATE SET
             titel=EXCLUDED.titel, start_zeit=EXCLUDED.start_zeit, end_zeit=EXCLUDED.end_zeit,
             ort=EXCLUDED.ort, beschreibung=EXCLUDED.beschreibung, organisator=EXCLUDED.organisator,
             synced_at=NOW()`,
          [ev.uid, ev.summary, ev.dtstart, ev.dtend, ev.location, ev.desc, ev.organizer, []]
        );
        count++;
      } catch(e) { console.error('Fehler bei Event:', ev.uid, e.message); }
    }
  }
  return count;
}

// ── Auto-Sync ──────────────────────────────────────────────────────────────────
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
        await syncFromCalDAV(settings);
        await pool.query('UPDATE kalender_settings SET letzter_sync=NOW() WHERE id=1');
        console.log('Kalender Auto-Sync:', new Date().toISOString());
      } catch(e) { console.error('Kalender Auto-Sync Fehler:', e.message); }
      scheduleAutoSync();
    }, ms);
  } catch(e) { setTimeout(scheduleAutoSync, 60000); }
}
setTimeout(scheduleAutoSync, 10000);

module.exports = router;
