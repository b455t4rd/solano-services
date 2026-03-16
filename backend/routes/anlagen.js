const express = require('express');
const router = express.Router();
const pool = require('../db');
const multer = require('multer');
const path = require('path');
const { authMiddleware, adminMiddleware, managerMiddleware } = require('../middleware/auth');

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, process.env.UPLOAD_DIR || './uploads'),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `anlage_${Date.now()}${ext}`);
  }
});
const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) cb(null, true);
    else cb(new Error('Nur Bilder erlaubt'));
  }
});

// Anlage-Reihenfolge für aktuellen Benutzer laden
router.get('/reihenfolge', authMiddleware, async (req, res) => {
  const { sparte } = req.query;
  if (!sparte) return res.json([]);
  try {
    const result = await pool.query(
      'SELECT anlage_id, position FROM benutzer_anlage_reihenfolge WHERE mitarbeiter_id=$1 AND sparte=$2 ORDER BY position',
      [req.user.id, sparte]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Anlage-Reihenfolge für aktuellen Benutzer speichern
router.post('/reihenfolge', authMiddleware, async (req, res) => {
  const { sparte, reihenfolge } = req.body;
  if (!sparte || !Array.isArray(reihenfolge)) return res.status(400).json({ error: 'Ungültige Parameter' });
  try {
    await pool.query(
      'DELETE FROM benutzer_anlage_reihenfolge WHERE mitarbeiter_id=$1 AND sparte=$2',
      [req.user.id, sparte]
    );
    for (const { anlage_id, position } of reihenfolge) {
      await pool.query(
        'INSERT INTO benutzer_anlage_reihenfolge (mitarbeiter_id, anlage_id, sparte, position) VALUES ($1,$2,$3,$4)',
        [req.user.id, anlage_id, sparte, position]
      );
    }
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Alle aktiven Anlagen (optional nach Sparte filtern)
router.get('/', authMiddleware, async (req, res) => {
  const { sparte } = req.query;
  try {
    const params = [];
    let sparteFilter = '';
    if (sparte === 'winterdienst') {
      sparteFilter = ' AND a.in_winterdienst = true';
    } else if (sparte === 'gebaeudereinigung') {
      sparteFilter = ' AND a.in_gebaeudereinigung = true';
    } else if (sparte === 'gruenpflege') {
      sparteFilter = ' AND a.in_gruenpflege = true';
    }

    let query;
    if (sparte) {
      params.push(sparte);
      query = `
        SELECT a.*, COUNT(DISTINCT auf.id) as aufgaben_count,
          lv.lv_start_zeit   as zuletzt_besucht,
          lv.lv_einsatz_id   as zuletzt_einsatz_id,
          COALESCE(lv.lv_erledigt, 0) as zuletzt_erledigt,
          (SELECT COUNT(*) FROM aufgaben auf2
           WHERE auf2.anlage_id = a.id
             AND (auf2.sparte = $1 OR auf2.sparte IS NULL OR auf2.sparte = '')) as zuletzt_gesamt
        FROM anlagen a
        LEFT JOIN aufgaben auf ON auf.anlage_id = a.id
        LEFT JOIN LATERAL (
          SELECT e.id as lv_einsatz_id, e.start_zeit as lv_start_zeit,
            COUNT(ea.id) as lv_erledigt
          FROM einsaetze e
          LEFT JOIN erledigte_aufgaben ea ON ea.einsatz_id = e.id
          WHERE e.anlage_id = a.id AND e.sparte = $1
          GROUP BY e.id
          ORDER BY e.start_zeit DESC
          LIMIT 1
        ) lv ON true
        WHERE a.aktiv = true${sparteFilter}
        GROUP BY a.id, lv.lv_einsatz_id, lv.lv_start_zeit, lv.lv_erledigt
        ORDER BY a.name
      `;
    } else {
      query = `
        SELECT a.*, COUNT(DISTINCT auf.id) as aufgaben_count
        FROM anlagen a
        LEFT JOIN aufgaben auf ON auf.anlage_id = a.id
        WHERE a.aktiv = true
        GROUP BY a.id ORDER BY a.name
      `;
    }
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Einzelne Anlage mit Aufgaben
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const anlage = await pool.query('SELECT * FROM anlagen WHERE id=$1', [req.params.id]);
    if (!anlage.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
    const aufgaben = await pool.query(
      'SELECT * FROM aufgaben WHERE anlage_id=$1 ORDER BY reihenfolge',
      [req.params.id]
    );
    res.json({ ...anlage.rows[0], aufgaben: aufgaben.rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Anlage erstellen (Admin only)
router.post('/', managerMiddleware, async (req, res) => {
  const { name, adresse, plz, ort, lat, lng, info_text, in_winterdienst, in_gebaeudereinigung, in_gruenpflege } = req.body;
  if (!name || !adresse) return res.status(400).json({ error: 'Name und Adresse erforderlich' });
  try {
    const result = await pool.query(
      `INSERT INTO anlagen (name, adresse, plz, ort, lat, lng, info_text, in_winterdienst, in_gebaeudereinigung, in_gruenpflege)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *`,
      [name, adresse, plz || null, ort || null, lat || null, lng || null,
       info_text || null, in_winterdienst || false, in_gebaeudereinigung || false, in_gruenpflege || false]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Anlage aktualisieren (Admin only)
router.put('/:id', managerMiddleware, async (req, res) => {
  const { name, adresse, plz, ort, lat, lng, info_text, aktiv, in_winterdienst, in_gebaeudereinigung, in_gruenpflege } = req.body;
  try {
    const result = await pool.query(
      `UPDATE anlagen SET name=$1, adresse=$2, plz=$3, ort=$4, lat=$5, lng=$6,
       info_text=$7, aktiv=$8, in_winterdienst=$9, in_gebaeudereinigung=$10, in_gruenpflege=$11
       WHERE id=$12 RETURNING *`,
      [name, adresse, plz || null, ort || null, lat || null, lng || null,
       info_text || null, aktiv !== false, in_winterdienst || false, in_gebaeudereinigung || false,
       in_gruenpflege || false, req.params.id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Lagerbild hochladen (Admin only) – optional ?sparte= für Sparte-spezifisches Bild
router.post('/:id/bild', managerMiddleware, upload.single('bild'), async (req, res) => {
  try {
    const url = `/uploads/${req.file.filename}`;
    const { sparte } = req.query;
    const col = sparte === 'gebaeudereinigung' ? 'bild_url_gebaeudereinigung'
               : sparte === 'gruenpflege' ? 'bild_url_gruenpflege'
               : sparte === 'winterdienst' ? 'bild_url_winter'
               : 'bild_url';
    await pool.query(`UPDATE anlagen SET ${col}=$1 WHERE id=$2`, [url, req.params.id]);
    res.json({ [col]: url });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Anlage deaktivieren (Admin only, soft delete)
router.delete('/:id', managerMiddleware, async (req, res) => {
  try {
    await pool.query('UPDATE anlagen SET aktiv=false WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
