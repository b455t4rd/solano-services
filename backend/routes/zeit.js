const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, managerMiddleware } = require('../middleware/auth');

// Heutiger Status (eigene Einträge)
router.get('/heute', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM zeiterfassung
       WHERE mitarbeiter_id = $1 AND datum = CURRENT_DATE
       ORDER BY zeitpunkt ASC`,
      [req.user.id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Stempeln (mit optionalem zeitpunkt für nachträgliche Buchung)
router.post('/stempeln', authMiddleware, async (req, res) => {
  const { typ, notiz, zeitpunkt } = req.body;
  const erlaubteTypen = ['kommen', 'gehen', 'pause_start', 'pause_ende', 'urlaub'];
  if (!erlaubteTypen.includes(typ)) {
    return res.status(400).json({ error: 'Ungültiger Typ' });
  }
  try {
    const zp = zeitpunkt ? new Date(zeitpunkt) : new Date();
    const datum = zp.toISOString().split('T')[0];
    const result = await pool.query(
      `INSERT INTO zeiterfassung (mitarbeiter_id, mitarbeiter_name, typ, zeitpunkt, datum, notiz)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [req.user.id, req.user.name, typ, zp, datum, notiz || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Auswertung (Manager+) mit Stundenberechnung
router.get('/auswertung', managerMiddleware, async (req, res) => {
  const { von, bis, mitarbeiter_id } = req.query;
  try {
    let q = `SELECT z.*, m.name as ma_name
             FROM zeiterfassung z
             JOIN mitarbeiter m ON m.id = z.mitarbeiter_id
             WHERE 1=1`;
    const params = [];
    if (von)            { params.push(von);             q += ` AND z.datum >= $${params.length}`; }
    if (bis)            { params.push(bis);             q += ` AND z.datum <= $${params.length}`; }
    if (mitarbeiter_id) { params.push(mitarbeiter_id);  q += ` AND z.mitarbeiter_id = $${params.length}`; }
    q += ' ORDER BY z.mitarbeiter_id, z.datum, z.zeitpunkt';

    const rows = (await pool.query(q, params)).rows;

    // Stunden pro Tag pro Mitarbeiter berechnen
    const tage = {};
    for (const r of rows) {
      const key = `${r.mitarbeiter_id}_${r.datum}`;
      if (!tage[key]) tage[key] = { mitarbeiter_id: r.mitarbeiter_id, name: r.ma_name, datum: r.datum, eintraege: [] };
      tage[key].eintraege.push(r);
    }

    const auswertung = Object.values(tage).map(t => {
      const e = t.eintraege;
      let kommen = null, gehen = null, pauseMinuten = 0, urlaub = false;

      for (const x of e) {
        if (x.typ === 'urlaub') { urlaub = true; break; }
        if (x.typ === 'kommen' && !kommen) kommen = new Date(x.zeitpunkt);
        if (x.typ === 'gehen') gehen = new Date(x.zeitpunkt);
      }

      // Pausen berechnen
      let lastPauseStart = null;
      for (const x of e) {
        if (x.typ === 'pause_start') lastPauseStart = new Date(x.zeitpunkt);
        if (x.typ === 'pause_ende' && lastPauseStart) {
          pauseMinuten += (new Date(x.zeitpunkt) - lastPauseStart) / 60000;
          lastPauseStart = null;
        }
      }

      let nettoMinuten = 0;
      if (urlaub) {
        nettoMinuten = 480; // 8h
      } else if (kommen && gehen) {
        nettoMinuten = Math.max(0, (gehen - kommen) / 60000 - pauseMinuten);
      } else if (kommen) {
        // Noch nicht ausgestempelt
        nettoMinuten = Math.max(0, (new Date() - kommen) / 60000 - pauseMinuten);
      }

      return {
        mitarbeiter_id: t.mitarbeiter_id,
        name: t.name,
        datum: t.datum,
        kommen: kommen?.toISOString() || null,
        gehen: gehen?.toISOString() || null,
        pause_minuten: Math.round(pauseMinuten),
        netto_minuten: Math.round(nettoMinuten),
        urlaub,
        eintraege: e
      };
    });

    res.json(auswertung);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Alle Einträge eines Tages löschen (Manager+)
router.delete('/tag', managerMiddleware, async (req, res) => {
  const { mitarbeiter_id, datum } = req.query;
  if (!mitarbeiter_id || !datum) return res.status(400).json({ error: 'mitarbeiter_id und datum erforderlich' });
  try {
    await pool.query('DELETE FROM zeiterfassung WHERE mitarbeiter_id=$1 AND datum=$2', [mitarbeiter_id, datum]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Einzelnen Eintrag löschen (Manager+)
router.delete('/:id', managerMiddleware, async (req, res) => {
  try {
    await pool.query('DELETE FROM zeiterfassung WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
