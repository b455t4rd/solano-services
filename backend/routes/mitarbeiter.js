const express = require('express');
const router = express.Router();
const pool = require('../db');
const jwt = require('jsonwebtoken');
const { authMiddleware, adminMiddleware, managerMiddleware, JWT_SECRET } = require('../middleware/auth');

// Login per PIN → gibt JWT zurück
router.post('/login', async (req, res) => {
  const { pin } = req.body;
  if (!pin) return res.status(400).json({ error: 'PIN erforderlich' });
  try {
    const result = await pool.query(
      'SELECT id, name, pin, ist_admin, ist_chef, zeige_winterdienst, zeige_gebaeudereinigung, zeige_gruenpflege, zeige_projekte, darf_nachrichten, nachricht_verfuegbar, sieht_aktive_einsaetze, sieht_einsatz_details, kann_einsteigen, darf_bestellen FROM mitarbeiter WHERE pin=$1 AND aktiv=true',
      [pin]
    );
    if (!result.rows.length) return res.status(401).json({ error: 'Falscher PIN' });
    const m = result.rows[0];
    const token = jwt.sign(
      { id: m.id, name: m.name, ist_admin: m.ist_admin || false, ist_chef: m.ist_chef || false, darf_nachrichten: m.darf_nachrichten || false },
      JWT_SECRET,
      { expiresIn: '30d' }
    );
    res.json({
      id: m.id, name: m.name,
      ist_admin: m.ist_admin || false,
      ist_chef: m.ist_chef || false,
      token,
      zeige_winterdienst: m.zeige_winterdienst !== false,
      zeige_gebaeudereinigung: m.zeige_gebaeudereinigung !== false,
      zeige_gruenpflege: m.zeige_gruenpflege !== false,
      zeige_projekte: m.zeige_projekte !== false,
      darf_nachrichten: m.darf_nachrichten || false,
      nachricht_verfuegbar: m.nachricht_verfuegbar !== false,
      sieht_aktive_einsaetze: m.sieht_aktive_einsaetze || false,
      sieht_einsatz_details: m.sieht_einsatz_details || false,
      kann_einsteigen: m.kann_einsteigen || false,
      darf_bestellen: m.darf_bestellen || false,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Alle Mitarbeiter (Manager+ oder darf_nachrichten für Empfängerliste)
router.get('/', authMiddleware, async (req, res) => {
  try {
    // darf_nachrichten Nutzer dürfen die Liste sehen (für Empfängerauswahl), aber nur Name+Id+nachricht_verfuegbar
    if (!req.user.ist_admin && !req.user.ist_chef) {
      if (!req.user.darf_nachrichten) return res.status(403).json({ error: 'Kein Zugriff' });
      const result = await pool.query(
        'SELECT id, name, nachricht_verfuegbar FROM mitarbeiter WHERE aktiv=true ORDER BY name'
      );
      return res.json(result.rows);
    }
    const result = await pool.query(
      'SELECT id, name, pin, ist_admin, ist_chef, aktiv, zeige_winterdienst, zeige_gebaeudereinigung, zeige_gruenpflege, zeige_projekte, winterdienst_alarm, soll_stunden, beschaeftigung, darf_nachrichten, nachricht_verfuegbar, sieht_aktive_einsaetze, sieht_einsatz_details, kann_einsteigen, darf_bestellen FROM mitarbeiter WHERE aktiv=true ORDER BY name'
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Mitarbeiter erstellen (Manager+)
router.post('/', managerMiddleware, async (req, res) => {
  const { name, pin, ist_admin, ist_chef, zeige_winterdienst, zeige_gebaeudereinigung, zeige_gruenpflege, zeige_projekte, winterdienst_alarm, soll_stunden, beschaeftigung, darf_nachrichten, nachricht_verfuegbar, sieht_aktive_einsaetze, sieht_einsatz_details, kann_einsteigen, darf_bestellen } = req.body;
  if (!name || !pin) return res.status(400).json({ error: 'Name und PIN erforderlich' });
  if (ist_admin && !req.user.ist_admin) {
    return res.status(403).json({ error: 'Nur Admins können andere Admins anlegen' });
  }
  try {
    const result = await pool.query(
      `INSERT INTO mitarbeiter (name, pin, ist_admin, ist_chef, zeige_winterdienst, zeige_gebaeudereinigung, zeige_gruenpflege, zeige_projekte, winterdienst_alarm, soll_stunden, beschaeftigung, darf_nachrichten, nachricht_verfuegbar, sieht_aktive_einsaetze, sieht_einsatz_details, kann_einsteigen, darf_bestellen)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17) RETURNING id, name, ist_admin, ist_chef`,
      [name, pin, ist_admin || false, ist_chef || false,
        zeige_winterdienst !== false, zeige_gebaeudereinigung !== false, zeige_gruenpflege !== false,
        zeige_projekte !== false,
        winterdienst_alarm || false, soll_stunden || 38.5, beschaeftigung || 'vollzeit',
        darf_nachrichten || false, nachricht_verfuegbar !== false,
        sieht_aktive_einsaetze || false, sieht_einsatz_details || false, kann_einsteigen || false, darf_bestellen || false]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Mitarbeiter aktualisieren (Manager+)
router.put('/:id', managerMiddleware, async (req, res) => {
  const { name, pin, ist_admin, ist_chef, aktiv, zeige_winterdienst, zeige_gebaeudereinigung, zeige_gruenpflege, zeige_projekte, winterdienst_alarm, soll_stunden, beschaeftigung, darf_nachrichten, nachricht_verfuegbar, sieht_aktive_einsaetze, sieht_einsatz_details, kann_einsteigen, darf_bestellen } = req.body;
  if (ist_admin && !req.user.ist_admin) {
    return res.status(403).json({ error: 'Nur Admins können Admin-Rechte vergeben' });
  }
  try {
    const result = await pool.query(
      `UPDATE mitarbeiter SET name=$1, pin=$2, ist_admin=$3, ist_chef=$4, aktiv=$5,
        zeige_winterdienst=$6, zeige_gebaeudereinigung=$7, zeige_gruenpflege=$8,
        zeige_projekte=$9, winterdienst_alarm=$10, soll_stunden=$11, beschaeftigung=$12,
        darf_nachrichten=$13, nachricht_verfuegbar=$14,
        sieht_aktive_einsaetze=$15, sieht_einsatz_details=$16, kann_einsteigen=$17, darf_bestellen=$18
       WHERE id=$19 RETURNING id, name, pin, ist_admin, ist_chef, aktiv, zeige_winterdienst, zeige_gebaeudereinigung, zeige_gruenpflege, zeige_projekte, winterdienst_alarm, soll_stunden, beschaeftigung, darf_nachrichten, nachricht_verfuegbar, sieht_aktive_einsaetze, sieht_einsatz_details, kann_einsteigen, darf_bestellen`,
      [name, pin, ist_admin || false, ist_chef || false, aktiv !== false,
        zeige_winterdienst !== false, zeige_gebaeudereinigung !== false, zeige_gruenpflege !== false,
        zeige_projekte !== false,
        winterdienst_alarm || false, soll_stunden || 38.5, beschaeftigung || 'vollzeit',
        darf_nachrichten || false, nachricht_verfuegbar !== false,
        sieht_aktive_einsaetze || false, sieht_einsatz_details || false, kann_einsteigen || false, darf_bestellen || false,
        req.params.id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Mitarbeiter deaktivieren (Manager+)
router.delete('/:id', managerMiddleware, async (req, res) => {
  try {
    await pool.query('UPDATE mitarbeiter SET aktiv=false WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
