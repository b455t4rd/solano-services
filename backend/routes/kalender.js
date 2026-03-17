const express = require('express');
const router  = express.Router();
const pool    = require('../db');
const https   = require('https');
const http    = require('http');
const { URL } = require('url');
const { authMiddleware, managerMiddleware, adminMiddleware } = require('../middleware/auth');

// ── GET /api/kalender/settings ────────────────────────────────────────────────
router.get('/settings', managerMiddleware, async (req, res) => {
  try {
    const r = await pool.query('SELECT id, exchange_url, exchange_user, sync_intervall_min, letzter_sync FROM kalender_settings WHERE id=1');
    if (!r.rows.length) return res.json({ id:1, exchange_url:'', exchange_user:'', sync_intervall_min:15, letzter_sync:null });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── PUT /api/kalender/settings ────────────────────────────────────────────────
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

// ── POST /api/kalender/sync ───────────────────────────────────────────────────
router.post('/sync', managerMiddleware, async (req, res) => {
  try {
    const sr = await pool.query('SELECT * FROM kalender_settings WHERE id=1');
    if (!sr.rows.length || !sr.rows[0].exchange_url)
      return res.status(400).json({ error: 'CalDAV-URL nicht konfiguriert' });
    const s = sr.rows[0];
    if (!s.exchange_user || !s.exchange_pass)
      return res.status(400).json({ error: 'Benutzername oder Passwort fehlt' });

    const count = await syncCalDAV(s);
    await pool.query('UPDATE kalender_settings SET letzter_sync=NOW() WHERE id=1');
    res.json({ success:true, count, letzter_sync: new Date().toISOString() });
  } catch (err) {
    console.error('Kalender-Sync Fehler:', err.message);
    res.status(500).json({ error: err.message });
  }
});

// ── GET /api/kalender/events ──────────────────────────────────────────────────
router.get('/events', authMiddleware, async (req, res) => {
  try {
    const { von, bis } = req.query;
    let q = 'SELECT * FROM kalender_events WHERE 1=1';
    const params = [];
    if (von) { params.push(von); q += ` AND start_zeit >= $${params.length}`; }
    if (bis)  { params.push(bis); q += ` AND start_zeit <= $${params.length}`; }
    q += ' ORDER BY start_zeit ASC';
    const r = await pool.query(q, params);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── HTTP-Request mit Basic Auth ───────────────────────────────────────────────
function basicRequest(method, urlStr, username, password, body, extraHeaders = {}) {
  return new Promise((resolve, reject) => {
    const u   = new URL(urlStr);
    const lib = u.protocol === 'https:' ? https : http;
    const auth = 'Basic ' + Buffer.from(`${username}:${password}`).toString('base64');

    const headers = {
      'Authorization': auth,
      'Content-Type':  'text/xml; charset=utf-8',
      'Depth':         '1',
      ...extraHeaders
    };
    if (body) headers['Content-Length'] = Buffer.byteLength(body, 'utf8');

    const opts = {
      hostname: u.hostname,
      port:     u.port || (u.protocol === 'https:' ? 443 : 80),
      path:     u.pathname + u.search,
      method,
      headers,
      rejectUnauthorized: false
    };

    const req = lib.request(opts, r => {
      let data = '';
      r.on('data', c => data += c);
      r.on('end', () => resolve({ status: r.statusCode, headers: r.headers, body: data }));
    });
    req.on('error', reject);
    req.setTimeout(15000, () => { req.destroy(); reject(new Error('Timeout')); });
    if (body) req.write(body);
    req.end();
  });
}

// ── iCal Parser ───────────────────────────────────────────────────────────────
function parseIcal(text) {
  const events = [];
  const norm = text.replace(/\r\n /g,'').replace(/\r\n\t/g,'').replace(/\r\n/g,'\n').replace(/\r/g,'\n');
  const blocks = norm.match(/BEGIN:VEVENT[\s\S]*?END:VEVENT/g) || [];

  for (const b of blocks) {
    const get = key => {
      const m = b.match(new RegExp(`^${key}[;:][^\n]*`, 'm'));
      if (!m) return null;
      return m[0].replace(new RegExp(`^${key}[^:]*:`), '').trim();
    };
    const parseDate = d => {
      if (!d) return null;
      const c = d.replace(/;.*/, '');
      if (c.length === 8) return `${c.slice(0,4)}-${c.slice(4,6)}-${c.slice(6,8)}T00:00:00Z`;
      const date = `${c.slice(0,4)}-${c.slice(4,6)}-${c.slice(6,8)}`;
      const time = c.length >= 15 ? `${c.slice(9,11)}:${c.slice(11,13)}:${c.slice(13,15)}` : '00:00:00';
      return `${date}T${time}${c.endsWith('Z')?'Z':''}`;
    };

    const uid = get('UID'); if (!uid) continue;
    events.push({
      uid,
      summary:   (get('SUMMARY') || '(Kein Betreff)').replace(/\\n/g,' ').replace(/\\,/g,','),
      dtstart:   parseDate(get('DTSTART')),
      dtend:     parseDate(get('DTEND')),
      location:  (get('LOCATION') || '').replace(/\\n/g,' ').replace(/\\,/g,',') || null,
      desc:      (get('DESCRIPTION') || '').replace(/\\n/g,'\n').replace(/\\,/g,',').substring(0,2000) || null,
      organizer: get('ORGANIZER')?.replace(/.*CN=/,'')?.split(':')[0] || null
    });
  }
  return events;
}

// ── CalDAV Sync (SmarterMail Basic Auth) ─────────────────────────────────────
async function syncCalDAV(settings) {
  const baseUrl  = settings.exchange_url.replace(/\/$/, '');
  const username = settings.exchange_user;
  const password = settings.exchange_pass;

  // SmarterMail CalDAV Kalender-Pfad ermitteln
  // Typische Pfade: /DAV/user@domain.com/Calendar/ oder /webdav/user/Calendar/
  const caldavPaths = [
    `${baseUrl}/${username}/Calendar/`,
    `${baseUrl}/${username}/Kalender/`,
    `${baseUrl}/`,
  ];

  const now    = new Date();
  const future = new Date(now); future.setDate(future.getDate() + 90);
  const fmt    = d => d.toISOString().replace(/[-:]/g,'').split('.')[0] + 'Z';

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

  let resp = null;
  let usedPath = null;

  // Alle Pfade probieren
  for (const path of caldavPaths) {
    try {
      const r = await basicRequest('REPORT', path, username, password, reportBody, { 'Depth': '1' });
      if (r.status === 207 || r.status === 200) { resp = r; usedPath = path; break; }
      if (r.status === 401) throw new Error('Authentifizierung fehlgeschlagen (401) – E-Mail/Passwort prüfen');
    } catch(e) {
      if (e.message.includes('401')) throw e;
      // nächsten Pfad probieren
    }
  }

  if (!resp) {
    // Fallback: PROPFIND zur Kalender-Erkennung
    const propfind = await basicRequest('PROPFIND', baseUrl + '/', username, password,
      `<?xml version="1.0"?><D:propfind xmlns:D="DAV:"><D:prop><D:resourcetype/><D:displayname/></D:prop></D:propfind>`,
      { 'Depth': '1' });
    if (propfind.status === 401) throw new Error('Authentifizierung fehlgeschlagen (401) – E-Mail/Passwort prüfen');
    throw new Error(`Kalender-Pfad nicht gefunden. Server antwortete: ${propfind.status}. Basis-URL prüfen.`);
  }

  // calendar-data aus Multistatus-Response extrahieren
  const decode = s => s.replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&amp;/g,'&').replace(/&#13;/g,'');
  const calBlocks = resp.body.match(/<[^>]*:?calendar-data[^>]*>([\s\S]*?)<\/[^>]*:?calendar-data>/gi) || [];

  let count = 0;
  for (const block of calBlocks) {
    const ical = decode(block.replace(/<[^>]+>/g, ''));
    for (const ev of parseIcal(ical)) {
      try {
        await pool.query(
          `INSERT INTO kalender_events (id,titel,start_zeit,end_zeit,ort,beschreibung,organisator,mitarbeiter_ids,synced_at)
           VALUES ($1,$2,$3,$4,$5,$6,$7,$8,NOW())
           ON CONFLICT (id) DO UPDATE SET
             titel=EXCLUDED.titel, start_zeit=EXCLUDED.start_zeit, end_zeit=EXCLUDED.end_zeit,
             ort=EXCLUDED.ort, beschreibung=EXCLUDED.beschreibung, organisator=EXCLUDED.organisator, synced_at=NOW()`,
          [ev.uid, ev.summary, ev.dtstart, ev.dtend, ev.location, ev.desc, ev.organizer, []]
        );
        count++;
      } catch(e) { console.error('CalDAV Event Fehler:', ev.uid, e.message); }
    }
  }
  console.log(`CalDAV Sync: ${count} Events von ${usedPath}`);
  return count;
}

// ── Auto-Sync ─────────────────────────────────────────────────────────────────
let _timer = null;
async function scheduleAutoSync() {
  try {
    const r = await pool.query('SELECT * FROM kalender_settings WHERE id=1');
    if (!r.rows.length || !r.rows[0].exchange_url || !r.rows[0].exchange_pass) return;
    const s  = r.rows[0];
    const ms = (s.sync_intervall_min || 15) * 60 * 1000;
    if (_timer) clearTimeout(_timer);
    _timer = setTimeout(async () => {
      try {
        await syncCalDAV(s);
        await pool.query('UPDATE kalender_settings SET letzter_sync=NOW() WHERE id=1');
      } catch(e) { console.error('Auto-Sync Fehler:', e.message); }
      scheduleAutoSync();
    }, ms);
  } catch(e) { setTimeout(scheduleAutoSync, 60000); }
}
setTimeout(scheduleAutoSync, 15000);

module.exports = router;
