require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3001;

// Uploads-Ordner anlegen falls nicht vorhanden
const uploadDir = process.env.UPLOAD_DIR || './uploads';
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.resolve(uploadDir)));

// API Routes
app.use('/api/mitarbeiter', require('./routes/mitarbeiter'));
app.use('/api/anlagen', require('./routes/anlagen'));
app.use('/api/aufgaben', require('./routes/aufgaben'));
app.use('/api/einsaetze', require('./routes/einsaetze'));
app.use('/api/gps', require('./routes/gps'));
app.use('/api/fotos', require('./routes/fotos'));
app.use('/api/todos', require('./routes/todos'));
app.use('/api/push',  require('./routes/push'));
app.use('/api/nachrichten', require('./routes/nachrichten'));
app.use('/api/alarm',      require('./routes/alarm'));
app.use('/api/admin',      require('./routes/admin'));
app.use('/api/zeit',       require('./routes/zeit'));
app.use('/api/kalender',   require('./routes/kalender'));
app.use('/api/projekte',   require('./routes/projekte'));

// Health Check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', zeit: new Date().toISOString() });
});

// Frontend ausliefern (SPA)
const frontendDir = path.join(__dirname, '../frontend');
app.use(express.static(frontendDir, { etag: false, maxAge: 0 }));
app.get('*', (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.sendFile(path.join(frontendDir, 'index.html'));
});

// ── Automatische Datensicherung (Cron) ───────────────────────────────────────
try {
  const cron = require('node-cron');
  const fsB = require('fs');
  const pathB = require('path');
  const { execSync: execB } = require('child_process');
  const BACKUP_DIR_C = pathB.join(__dirname, '../backups');
  // Jede Minute prüfen ob ein geplantes Backup fällig ist
  cron.schedule('* * * * *', async () => {
    try {
      const pool = require('./db');
      const r = await pool.query('SELECT * FROM backup_schedule WHERE aktiv=true LIMIT 1');
      if (!r.rows.length) return;
      const cfg = r.rows[0];
      const now = new Date();
      const pad = n => String(n).padStart(2,'0');
      const nowTime = `${pad(now.getHours())}:${pad(now.getMinutes())}`;
      const nowDay = String(now.getDay()); // 0=So,1=Mo,...,6=Sa
      const tage = Array.isArray(cfg.wochentage) ? cfg.wochentage.map(String) : [];
      if (nowTime !== cfg.uhrzeit) return;
      if (!tage.includes(nowDay)) return;
      // Bereits heute gelaufen?
      if (cfg.letzte_ausfuehrung) {
        const letzt = new Date(cfg.letzte_ausfuehrung);
        if (letzt.toDateString() === now.toDateString()) return;
      }
      // Backup erstellen
      if (!fsB.existsSync(BACKUP_DIR_C)) fsB.mkdirSync(BACKUP_DIR_C, { recursive: true });
      const ts = `${now.getFullYear()}${pad(now.getMonth()+1)}${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}00`;
      const dbFile = pathB.join(BACKUP_DIR_C, `solano_db_auto_${ts}.sql`);
      execB(
        `PGPASSWORD="${process.env.DB_PASSWORD||''}" pg_dump --clean --if-exists -h ${process.env.DB_HOST||'localhost'} -U ${process.env.DB_USER||'solano'} ${process.env.DB_NAME||'winterdienst'} > "${dbFile}"`,
        { shell: '/bin/bash' }
      );
      await pool.query('UPDATE backup_schedule SET letzte_ausfuehrung=NOW()');
      const { logEvent } = require('./utils/logger');
      const stat = fsB.statSync(dbFile);
      await logEvent({ level: 'info', aktion: 'auto-backup', ausgeloest_von: 'system', details: { datei: pathB.basename(dbFile), groesse: stat.size } });
      console.log(`Auto-Backup erstellt: ${pathB.basename(dbFile)}`);
    } catch(e) { console.error('Auto-Backup Fehler:', e.message); }
  });
  console.log('Auto-Backup Cron-Job gestartet ✓');
} catch(e) { console.warn('Cron-Job konnte nicht gestartet werden:', e.message); }

app.listen(PORT, async () => {
  console.log(`SolanoServices Backend läuft auf Port ${PORT}`);
  console.log(`Frontend: http://localhost:${PORT}`);
  console.log(`API:      http://localhost:${PORT}/api/health`);
  // Sequences beim Start korrigieren (nach DB-Import können sie falsch sein)
  try {
    const pool = require('./db');
    await pool.query(`SELECT setval('aufgaben_id_seq', COALESCE((SELECT MAX(id) FROM aufgaben), 1))`);
    await pool.query(`SELECT setval('mitarbeiter_id_seq', COALESCE((SELECT MAX(id) FROM mitarbeiter), 1))`);
    await pool.query(`SELECT setval('anlagen_id_seq', COALESCE((SELECT MAX(id) FROM anlagen), 1))`);
    await pool.query(`SELECT setval('einsaetze_id_seq', COALESCE((SELECT MAX(id) FROM einsaetze), 1))`);
    await pool.query(`SELECT setval('auftraggeber_id_seq', COALESCE((SELECT MAX(id) FROM auftraggeber), 1))`);
    await pool.query(`SELECT setval('projekt_auftraege_id_seq', COALESCE((SELECT MAX(id) FROM projekt_auftraege), 1))`);
    console.log('Sequences korrigiert ✓');
  } catch(e) { console.warn('Sequence-Fix Fehler:', e.message); }
  // Server-Start ins System-Log schreiben
  try {
    const { logEvent } = require('./utils/logger');
    const pkg = require('./package.json');
    await logEvent({ level: 'info', aktion: 'server-start', ausgeloest_von: 'system', details: { port: PORT, version: pkg.version || '–' } });
  } catch(e) { console.warn('Log-Fehler:', e.message); }
});
