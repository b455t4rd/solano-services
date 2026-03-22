const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, managerMiddleware } = require('../middleware/auth');

// Middleware: darf_bestellen ODER admin/chef
const bestellMiddleware = (req, res, next) => {
    if (!req.user) return res.status(401).json({ error: 'Nicht angemeldet' });
    if (req.user.ist_admin || req.user.ist_chef || req.user.darf_bestellen) return next();
    return res.status(403).json({ error: 'Keine Berechtigung für Bestellungen' });
};

// ── BESTELL-KATEGORIEN (Tabs) ──────────────────────────────────────────────
router.get('/kategorien', authMiddleware, async (req, res) => {
    try {
        const r = await pool.query('SELECT * FROM bestelllisten_kategorien ORDER BY sort_order, name');
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/kategorien', managerMiddleware, async (req, res) => {
    const { name, icon, farbe, sort_order } = req.body;
    if (!name) return res.status(400).json({ error: 'Name erforderlich' });
    try {
        const r = await pool.query(
            'INSERT INTO bestelllisten_kategorien (name, icon, farbe, sort_order) VALUES ($1,$2,$3,$4) RETURNING *',
            [name, icon || '📦', farbe || '#6366f1', sort_order || 0]
        );
        res.status(201).json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.put('/kategorien/:id', managerMiddleware, async (req, res) => {
    const { name, icon, farbe, sort_order, aktiv } = req.body;
    try {
        const r = await pool.query(
            'UPDATE bestelllisten_kategorien SET name=COALESCE($1,name), icon=COALESCE($2,icon), farbe=COALESCE($3,farbe), sort_order=COALESCE($4,sort_order), aktiv=COALESCE($5,aktiv) WHERE id=$6 RETURNING *',
            [name, icon, farbe, sort_order, aktiv, req.params.id]
        );
        res.json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.delete('/kategorien/:id', managerMiddleware, async (req, res) => {
    try {
        await pool.query('DELETE FROM bestelllisten_kategorien WHERE id=$1', [req.params.id]);
        res.json({ success: true });
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ── ARTIKEL-KATEGORIEN (Stammdaten-Typen, frei definierbar) ────────────────
router.get('/artikel-kategorien', authMiddleware, async (req, res) => {
    try {
        const r = await pool.query('SELECT * FROM bestelllisten_artikel_kategorien ORDER BY sort_order, name');
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/artikel-kategorien', managerMiddleware, async (req, res) => {
    const { name, sort_order } = req.body;
    if (!name) return res.status(400).json({ error: 'Name erforderlich' });
    try {
        const r = await pool.query(
            'INSERT INTO bestelllisten_artikel_kategorien (name, sort_order) VALUES ($1,$2) RETURNING *',
            [name, sort_order || 0]
        );
        res.status(201).json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.put('/artikel-kategorien/:id', managerMiddleware, async (req, res) => {
    const { name, sort_order, aktiv } = req.body;
    try {
        const r = await pool.query(
            'UPDATE bestelllisten_artikel_kategorien SET name=COALESCE($1,name), sort_order=COALESCE($2,sort_order), aktiv=COALESCE($3,aktiv) WHERE id=$4 RETURNING *',
            [name, sort_order, aktiv, req.params.id]
        );
        res.json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.delete('/artikel-kategorien/:id', managerMiddleware, async (req, res) => {
    try {
        await pool.query('DELETE FROM bestelllisten_artikel_kategorien WHERE id=$1', [req.params.id]);
        res.json({ success: true });
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ── STAMMDATEN ─────────────────────────────────────────────────────────────
router.get('/stammdaten', authMiddleware, async (req, res) => {
    try {
        const r = await pool.query(`
      SELECT s.*, ak.name AS artikel_kategorie_name, bk.name AS bestell_kategorie_name
      FROM bestelllisten_stammdaten s
      LEFT JOIN bestelllisten_artikel_kategorien ak ON s.artikel_kategorie_id = ak.id
      LEFT JOIN bestelllisten_kategorien bk ON s.kategorie_id = bk.id
      WHERE s.aktiv = true
      ORDER BY ak.sort_order, ak.name, s.name
    `);
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// Barcode lookup
router.get('/stammdaten/barcode/:code', authMiddleware, async (req, res) => {
    try {
        const r = await pool.query(
            `SELECT s.*, ak.name AS artikel_kategorie_name FROM bestelllisten_stammdaten s
       LEFT JOIN bestelllisten_artikel_kategorien ak ON s.artikel_kategorie_id = ak.id
       WHERE s.scancode = $1 AND s.aktiv = true LIMIT 1`,
            [req.params.code]
        );
        if (!r.rows.length) return res.status(404).json({ error: 'Artikel nicht gefunden' });
        res.json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/stammdaten', managerMiddleware, async (req, res) => {
    const { name, kategorie_id, artikel_kategorie_id, lieferant, einheit,
        preis_netto, preis_brutto, scancode,
        sparte_winterdienst, sparte_gebaeudereinigung, sparte_gruenpflege, sparte_projekte } = req.body;
    if (!name) return res.status(400).json({ error: 'Name erforderlich' });
    try {
        const r = await pool.query(
            `INSERT INTO bestelllisten_stammdaten
        (name, kategorie_id, artikel_kategorie_id, lieferant, einheit,
         preis_netto, preis_brutto, scancode,
         sparte_winterdienst, sparte_gebaeudereinigung, sparte_gruenpflege, sparte_projekte)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) RETURNING *`,
            [name, kategorie_id || null, artikel_kategorie_id || null, lieferant || null, einheit || null,
                preis_netto || null, preis_brutto || null, scancode || null,
                sparte_winterdienst || false, sparte_gebaeudereinigung || false,
                sparte_gruenpflege || false, sparte_projekte || false]
        );
        res.status(201).json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.put('/stammdaten/:id', managerMiddleware, async (req, res) => {
    const { name, kategorie_id, artikel_kategorie_id, lieferant, einheit,
        preis_netto, preis_brutto, scancode, aktiv,
        sparte_winterdienst, sparte_gebaeudereinigung, sparte_gruenpflege, sparte_projekte } = req.body;
    try {
        const r = await pool.query(
            `UPDATE bestelllisten_stammdaten SET
        name=COALESCE($1,name), kategorie_id=$2, artikel_kategorie_id=$3,
        lieferant=$4, einheit=$5, preis_netto=$6, preis_brutto=$7, scancode=$8, aktiv=COALESCE($9,aktiv),
        sparte_winterdienst=COALESCE($10,sparte_winterdienst),
        sparte_gebaeudereinigung=COALESCE($11,sparte_gebaeudereinigung),
        sparte_gruenpflege=COALESCE($12,sparte_gruenpflege),
        sparte_projekte=COALESCE($13,sparte_projekte)
       WHERE id=$14 RETURNING *`,
            [name, kategorie_id || null, artikel_kategorie_id || null, lieferant || null, einheit || null,
                preis_netto || null, preis_brutto || null, scancode || null, aktiv,
                sparte_winterdienst, sparte_gebaeudereinigung, sparte_gruenpflege, sparte_projekte,
                req.params.id]
        );
        res.json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.delete('/stammdaten/:id', managerMiddleware, async (req, res) => {
    try {
        await pool.query('UPDATE bestelllisten_stammdaten SET aktiv=false WHERE id=$1', [req.params.id]);
        res.json({ success: true });
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ── EINTRÄGE ───────────────────────────────────────────────────────────────
router.get('/eintraege', authMiddleware, bestellMiddleware, async (req, res) => {
    try {
        const { kategorie_id } = req.query;
        let q = `
      SELECT e.*,
        k.name AS kategorie_name, k.icon AS kategorie_icon, k.farbe AS kategorie_farbe,
        m.name AS erstellt_von_name, bm.name AS bestellt_von_name
      FROM bestelllisten_eintraege e
      LEFT JOIN bestelllisten_kategorien k ON e.kategorie_id = k.id
      LEFT JOIN mitarbeiter m ON e.erstellt_von = m.id
      LEFT JOIN mitarbeiter bm ON e.bestellt_von = bm.id
    `;
        const params = [];
        if (kategorie_id) { q += ' WHERE e.kategorie_id=$1'; params.push(kategorie_id); }
        q += ' ORDER BY e.bestellt ASC, e.erstellt_am DESC';
        const r = await pool.query(q, params);
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/eintraege', authMiddleware, bestellMiddleware, async (req, res) => {
    const { kategorie_id, bezeichnung, menge, einheit, lieferant, stammdaten_id } = req.body;
    if (!bezeichnung) return res.status(400).json({ error: 'Bezeichnung erforderlich' });
    try {
        const r = await pool.query(
            `INSERT INTO bestelllisten_eintraege (kategorie_id, bezeichnung, menge, einheit, lieferant, stammdaten_id, erstellt_von)
       VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *`,
            [kategorie_id || null, bezeichnung, menge || null, einheit || null,
            lieferant || null, stammdaten_id || null, req.user.id]
        );
        // Join data für response
        const full = await pool.query(`
      SELECT e.*, k.name AS kategorie_name, k.icon AS kategorie_icon, k.farbe AS kategorie_farbe,
        m.name AS erstellt_von_name
      FROM bestelllisten_eintraege e
      LEFT JOIN bestelllisten_kategorien k ON e.kategorie_id = k.id
      LEFT JOIN mitarbeiter m ON e.erstellt_von = m.id
      WHERE e.id=$1`, [r.rows[0].id]);
        res.status(201).json(full.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.patch('/eintraege/:id/bestellt', authMiddleware, managerMiddleware, async (req, res) => {
    const { bestellt } = req.body;
    try {
        const r = await pool.query(
            `UPDATE bestelllisten_eintraege SET bestellt=$1, bestellt_von=$2, bestellt_am=$3 WHERE id=$4 RETURNING *`,
            [bestellt, bestellt ? req.user.id : null, bestellt ? new Date() : null, req.params.id]
        );
        res.json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.delete('/eintraege/:id', authMiddleware, async (req, res) => {
    try {
        const r = await pool.query('SELECT erstellt_von FROM bestelllisten_eintraege WHERE id=$1', [req.params.id]);
        if (!r.rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
        if (!req.user.ist_admin && !req.user.ist_chef && r.rows[0].erstellt_von !== req.user.id) {
            return res.status(403).json({ error: 'Keine Berechtigung' });
        }
        await pool.query('DELETE FROM bestelllisten_eintraege WHERE id=$1', [req.params.id]);
        res.json({ success: true });
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ── EXPORT DATA ────────────────────────────────────────────────────────────
router.get('/export-data', authMiddleware, managerMiddleware, async (req, res) => {
    try {
        const r = await pool.query(`
      SELECT e.*,
        k.name AS kategorie, k.icon AS kategorie_icon,
        m.name AS erfasst_von, bm.name AS bestellt_von_name
      FROM bestelllisten_eintraege e
      LEFT JOIN bestelllisten_kategorien k ON e.kategorie_id = k.id
      LEFT JOIN mitarbeiter m ON e.erstellt_von = m.id
      LEFT JOIN mitarbeiter bm ON e.bestellt_von = bm.id
      ORDER BY e.bestellt ASC, k.sort_order, k.name, e.erstellt_am DESC
    `);
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;
