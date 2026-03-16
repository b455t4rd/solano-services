const express = require('express');
const router = express.Router();
const pool = require('../db');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { authMiddleware } = require('../middleware/auth');

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, process.env.UPLOAD_DIR || './uploads'),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `foto_${Date.now()}_${Math.random().toString(36).substr(2, 6)}${ext}`);
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

// Foto für einen Einsatz hochladen
router.post('/:einsatz_id', authMiddleware, upload.single('foto'), async (req, res) => {
  try {
    const url = `/uploads/${req.file.filename}`;
    const result = await pool.query(
      'INSERT INTO einsatz_fotos (einsatz_id, foto_url, beschreibung) VALUES ($1, $2, $3) RETURNING *',
      [req.params.einsatz_id, url, req.body.beschreibung || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Fotos eines Einsatzes abrufen
router.get('/:einsatz_id', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM einsatz_fotos WHERE einsatz_id=$1 ORDER BY hochgeladen_am DESC',
      [req.params.einsatz_id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Foto löschen
router.delete('/:foto_id', authMiddleware, async (req, res) => {
  try {
    const foto = await pool.query('SELECT * FROM einsatz_fotos WHERE id=$1', [req.params.foto_id]);
    if (foto.rows.length) {
      const filepath = path.join(
        path.resolve(process.env.UPLOAD_DIR || './uploads'),
        path.basename(foto.rows[0].foto_url)
      );
      if (fs.existsSync(filepath)) fs.unlinkSync(filepath);
      await pool.query('DELETE FROM einsatz_fotos WHERE id=$1', [req.params.foto_id]);
    }
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
