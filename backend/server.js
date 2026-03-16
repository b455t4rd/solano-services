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

app.listen(PORT, () => {
  console.log(`SolanoServices Backend läuft auf Port ${PORT}`);
  console.log(`Frontend: http://localhost:${PORT}`);
  console.log(`API:      http://localhost:${PORT}/api/health`);
});
