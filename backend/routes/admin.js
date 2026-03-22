const express = require('express');
const router = express.Router();
const pool = require('../db');
const { adminMiddleware, authMiddleware } = require('../middleware/auth');
const { logEvent } = require('../utils/logger');

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

// ── System-Status ─────────────────────────────────────────────────────────────
router.get('/system-status', adminMiddleware, async (req, res) => {
  try {
    const [offene, eingestempelt] = await Promise.all([
      pool.query(`
        SELECT e.id, e.datum, e.start_zeit AS beginn, e.sparte,
               e.mitarbeiter AS mitarbeiter_name,
               a.name AS anlage_name, a.adresse AS anlage_adresse
        FROM einsaetze e
        JOIN anlagen a ON a.id = e.anlage_id
        WHERE e.end_zeit IS NULL AND e.start_zeit IS NOT NULL
        ORDER BY e.start_zeit DESC
        LIMIT 100
      `),
      pool.query(`
        SELECT * FROM (
          SELECT DISTINCT ON (mitarbeiter_id)
            mitarbeiter_id, mitarbeiter_name, zeitpunkt AS kommen_seit, typ
          FROM zeiterfassung
          WHERE datum = CURRENT_DATE
          ORDER BY mitarbeiter_id, zeitpunkt DESC
        ) latest
        WHERE typ = 'kommen'
        ORDER BY kommen_seit ASC
      `)
    ]);
    res.json({ offene_einsaetze: offene.rows, eingestempelt: eingestempelt.rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Force-Close Einsatz ───────────────────────────────────────────────────────
router.post('/einsatz/:id/force-close', adminMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      `UPDATE einsaetze SET end_zeit=COALESCE(end_zeit,NOW()) WHERE id=$1 RETURNING *`,
      [req.params.id]
    );
    if (!r.rows.length) return res.status(404).json({ error: 'Einsatz nicht gefunden' });
    await logEvent({
      level: 'warn', aktion: 'force-close-einsatz',
      ausgeloest_von: req.user.name,
      details: { einsatz_id: req.params.id, mitarbeiter: r.rows[0].mitarbeiter_name, anlage_id: r.rows[0].anlage_id },
      ip: req.ip
    });
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Force-Ausstempeln ─────────────────────────────────────────────────────────
router.post('/zeit/force-ausstempeln/:mid', adminMiddleware, async (req, res) => {
  try {
    const jetzt = new Date();
    const datum = jetzt.toISOString().split('T')[0];
    const ma = await pool.query('SELECT name FROM mitarbeiter WHERE id=$1', [req.params.mid]);
    if (!ma.rows.length) return res.status(404).json({ error: 'Mitarbeiter nicht gefunden' });
    await pool.query(
      `INSERT INTO zeiterfassung (mitarbeiter_id, mitarbeiter_name, typ, zeitpunkt, datum, notiz)
       VALUES ($1, $2, 'gehen', $3, $4, 'Admin-Ausstempelung (Force)')`,
      [req.params.mid, ma.rows[0].name, jetzt.toISOString(), datum]
    );
    await logEvent({
      level: 'warn', aktion: 'force-ausstempeln',
      ausgeloest_von: req.user.name,
      details: { mitarbeiter_id: req.params.mid, mitarbeiter: ma.rows[0].name },
      ip: req.ip
    });
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── System-Log lesen ──────────────────────────────────────────────────────────
router.get('/logs', adminMiddleware, async (req, res) => {
  try {
    const r = await pool.query(
      'SELECT * FROM system_logs ORDER BY created_at DESC LIMIT 200'
    );
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Datensicherung: Liste ─────────────────────────────────────────────────────
const fs = require('fs');
const path = require('path');
const { execSync, exec } = require('child_process');
const BACKUP_DIR = path.join(__dirname, '../../backups');
const DB_NAME = process.env.DB_NAME || 'winterdienst';
const DB_USER = process.env.DB_USER || 'solano';
const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_PASS = process.env.DB_PASSWORD || '';

router.get('/backups', adminMiddleware, (req, res) => {
  try {
    if (!fs.existsSync(BACKUP_DIR)) fs.mkdirSync(BACKUP_DIR, { recursive: true });
    const files = fs.readdirSync(BACKUP_DIR)
      .filter(f => f.endsWith('.sql') || f.endsWith('.tar.gz'))
      .map(f => {
        const stat = fs.statSync(path.join(BACKUP_DIR, f));
        return { name: f, size: stat.size, created: stat.mtime };
      })
      .sort((a, b) => new Date(b.created) - new Date(a.created));
    res.json(files);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Datensicherung: Erstellen ─────────────────────────────────────────────────
router.post('/backup/create', adminMiddleware, async (req, res) => {
  try {
    if (!fs.existsSync(BACKUP_DIR)) fs.mkdirSync(BACKUP_DIR, { recursive: true });
    const now = new Date();
    const pad = n => String(n).padStart(2, '0');
    const ts = `${now.getFullYear()}${pad(now.getMonth() + 1)}${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;
    const dbFile = path.join(BACKUP_DIR, `solano_db_${ts}.sql`);
    execSync(
      `PGPASSWORD="${DB_PASS}" pg_dump --clean --if-exists -h ${DB_HOST} -U ${DB_USER} ${DB_NAME} > "${dbFile}"`,
      { shell: '/bin/bash' }
    );
    const stat = fs.statSync(dbFile);
    await logEvent({ level: 'info', aktion: 'backup-erstellt', ausgeloest_von: req.user.name, details: { datei: path.basename(dbFile), groesse: stat.size } });
    res.json({ ok: true, name: path.basename(dbFile), size: stat.size, created: stat.mtime });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Datensicherung: Erstellen (Voll-Backup) ───────────────────────────────────
router.post('/backup/create-full', adminMiddleware, async (req, res) => {
  try {
    if (!fs.existsSync(BACKUP_DIR)) fs.mkdirSync(BACKUP_DIR, { recursive: true });
    const now = new Date();
    const pad = n => String(n).padStart(2, '0');
    const ts = `${now.getFullYear()}${pad(now.getMonth() + 1)}${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;

    const projectRoot = path.join(__dirname, '../../');
    const dbFile = path.join(projectRoot, `solano_db_temp_${ts}.sql`);

    // 1. Temporärer DB Dump in root
    execSync(
      `PGPASSWORD="${DB_PASS}" pg_dump --clean --if-exists -h ${DB_HOST} -U ${DB_USER} ${DB_NAME} > "${dbFile}"`,
      { shell: '/bin/bash' }
    );

    // 2. Tar-Archiv generieren (excl. node_modules, backups, .git)
    const tarFile = path.join(BACKUP_DIR, `solano_full_${ts}.tar.gz`);
    execSync(
      `tar --exclude="node_modules" --exclude=".git" --exclude="backups" --exclude=".DS_Store" -czf "${tarFile}" .`,
      { shell: '/bin/bash', cwd: projectRoot }
    );

    // Temp DB Backup aufräumen
    if (fs.existsSync(dbFile)) fs.unlinkSync(dbFile);

    const stat = fs.statSync(tarFile);
    await logEvent({ level: 'info', aktion: 'voll-backup-erstellt', ausgeloest_von: req.user.name, details: { datei: path.basename(tarFile), groesse: stat.size } });
    res.json({ ok: true, name: path.basename(tarFile), size: stat.size, created: stat.mtime });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Datensicherung: Download ──────────────────────────────────────────────────
router.get('/backup/download/:filename', adminMiddleware, (req, res) => {
  const filename = path.basename(req.params.filename); // security: no path traversal
  const filepath = path.join(BACKUP_DIR, filename);
  if (!fs.existsSync(filepath)) return res.status(404).json({ error: 'Datei nicht gefunden' });
  res.download(filepath, filename);
});

// ── Datensicherung: Löschen ───────────────────────────────────────────────────
router.delete('/backup/:filename', adminMiddleware, async (req, res) => {
  try {
    const filename = path.basename(req.params.filename);
    const filepath = path.join(BACKUP_DIR, filename);
    if (!fs.existsSync(filepath)) return res.status(404).json({ error: 'Datei nicht gefunden' });
    fs.unlinkSync(filepath);
    await logEvent({ level: 'warn', aktion: 'backup-geloescht', ausgeloest_von: req.user.name, details: { datei: filename } });
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Datensicherung: Wiederherstellen (serverseitig) ───────────────────────────
router.post('/backup/restore/:filename', adminMiddleware, async (req, res) => {
  try {
    const filename = path.basename(req.params.filename);
    if (!filename.endsWith('.sql')) return res.status(400).json({ error: 'Nur .sql Dateien können wiederhergestellt werden' });
    const filepath = path.join(BACKUP_DIR, filename);
    if (!fs.existsSync(filepath)) return res.status(404).json({ error: 'Backup-Datei nicht gefunden' });
    // Erst aktuellen Stand sichern
    const now = new Date();
    const pad = n => String(n).padStart(2, '0');
    const ts = `${now.getFullYear()}${pad(now.getMonth() + 1)}${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;
    const vorBackup = path.join(BACKUP_DIR, `solano_db_vor_restore_${ts}.sql`);
    execSync(`PGPASSWORD="${DB_PASS}" pg_dump --clean --if-exists -h ${DB_HOST} -U ${DB_USER} ${DB_NAME} > "${vorBackup}"`, { shell: '/bin/bash' });
    // Wiederherstellen
    execSync(`PGPASSWORD="${DB_PASS}" psql -h ${DB_HOST} -U ${DB_USER} ${DB_NAME} < "${filepath}"`, { shell: '/bin/bash' });
    await logEvent({ level: 'warn', aktion: 'backup-wiederhergestellt', ausgeloest_von: req.user.name, details: { datei: filename, vor_backup: path.basename(vorBackup) } });
    res.json({ ok: true, message: `Wiederhergestellt aus ${filename}. Vor-Backup: ${path.basename(vorBackup)}` });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Datensicherung: Upload & Wiederherstellen ─────────────────────────────────
const multer = require('multer');
const uploadBackup = multer({
  dest: BACKUP_DIR,
  fileFilter: (req, file, cb) => {
    if (file.originalname.endsWith('.sql')) cb(null, true);
    else cb(new Error('Nur .sql Dateien erlaubt'));
  },
  limits: { fileSize: 500 * 1024 * 1024 }
});
router.post('/backup/restore-upload', adminMiddleware, uploadBackup.single('backup'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: 'Keine Datei hochgeladen' });
    // Datei umbenennen mit originalem Namen
    const now = new Date();
    const pad = n => String(n).padStart(2, '0');
    const ts = `${now.getFullYear()}${pad(now.getMonth() + 1)}${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;
    const newName = `solano_db_upload_${ts}.sql`;
    const newPath = path.join(BACKUP_DIR, newName);
    fs.renameSync(req.file.path, newPath);
    // Erst aktuellen Stand sichern
    const vorBackup = path.join(BACKUP_DIR, `solano_db_vor_restore_${ts}.sql`);
    execSync(`PGPASSWORD="${DB_PASS}" pg_dump --clean --if-exists -h ${DB_HOST} -U ${DB_USER} ${DB_NAME} > "${vorBackup}"`, { shell: '/bin/bash' });
    // Wiederherstellen
    execSync(`PGPASSWORD="${DB_PASS}" psql -h ${DB_HOST} -U ${DB_USER} ${DB_NAME} < "${newPath}"`, { shell: '/bin/bash' });
    await logEvent({ level: 'warn', aktion: 'backup-upload-wiederhergestellt', ausgeloest_von: req.user.name, details: { datei: newName, original: req.file.originalname } });
    res.json({ ok: true, message: `Wiederhergestellt aus Upload. Vor-Backup: ${path.basename(vorBackup)}` });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Backup-Zeitplan: Lesen ───────────────────────────────────────────────────
router.get('/backup/schedule', adminMiddleware, async (req, res) => {
  try {
    const r = await pool.query('SELECT * FROM backup_schedule ORDER BY id LIMIT 1');
    res.json(r.rows[0] || { aktiv: false, wochentage: [], voll_wochentage: [], uhrzeit: '02:00' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Backup-Zeitplan: Speichern ────────────────────────────────────────────────
router.put('/backup/schedule', adminMiddleware, async (req, res) => {
  try {
    const { aktiv, wochentage, voll_wochentage, uhrzeit } = req.body;
    await pool.query(
      `UPDATE backup_schedule SET aktiv=$1, wochentage=$2, voll_wochentage=$3, uhrzeit=$4, updated_at=NOW()`,
      [!!aktiv, JSON.stringify(wochentage || []), JSON.stringify(voll_wochentage || []), uhrzeit || '02:00']
    );
    await logEvent({ level: 'info', aktion: 'backup-zeitplan-geaendert', ausgeloest_von: req.user.name, details: { aktiv, wochentage, voll_wochentage, uhrzeit } });
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;
