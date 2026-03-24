const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, managerMiddleware } = require('../middleware/auth');

// Middleware: darf_bestellen ODER admin — prüft DB direkt (wirkt sofort ohne Re-Login)
const bestellMiddleware = async (req, res, next) => {
    if (!req.user) return res.status(401).json({ error: 'Nicht angemeldet' });
    if (req.user.ist_admin) return next();
    try {
        const r = await pool.query('SELECT darf_bestellen FROM mitarbeiter WHERE id=$1', [req.user.id]);
        if (r.rows[0]?.darf_bestellen) return next();
    } catch (e) { return res.status(500).json({ error: e.message }); }
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
      SELECT s.*, ak.name AS artikel_kategorie_name, bk.name AS bestell_kategorie_name,
             m.name AS erstellt_von_name
      FROM bestelllisten_stammdaten s
      LEFT JOIN bestelllisten_artikel_kategorien ak ON s.artikel_kategorie_id = ak.id
      LEFT JOIN bestelllisten_kategorien bk ON s.kategorie_id = bk.id
      LEFT JOIN mitarbeiter m ON s.erstellt_von = m.id
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

router.post('/stammdaten', authMiddleware, bestellMiddleware, async (req, res) => {
    const { name, kategorie_id, artikel_kategorie_id, lieferant, einheit,
        preis_netto, preis_brutto, scancode, benoetigt_pruefung,
        sparte_winterdienst, sparte_gebaeudereinigung, sparte_gruenpflege, sparte_projekte } = req.body;
    if (!name) return res.status(400).json({ error: 'Name erforderlich' });
    // Nur Manager dürfen vollständige Stammdaten anlegen ohne Prüfung
    const pruefung = (req.user.ist_admin || req.user.ist_chef) ? (benoetigt_pruefung || false) : true;
    try {
        const r = await pool.query(
            `INSERT INTO bestelllisten_stammdaten
        (name, kategorie_id, artikel_kategorie_id, lieferant, einheit,
         preis_netto, preis_brutto, scancode, benoetigt_pruefung, erstellt_von,
         sparte_winterdienst, sparte_gebaeudereinigung, sparte_gruenpflege, sparte_projekte)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) RETURNING *`,
            [name, kategorie_id || null, artikel_kategorie_id || null, lieferant || null, einheit || null,
                preis_netto || null, preis_brutto || null, scancode || null, pruefung, req.user.id,
                sparte_winterdienst || false, sparte_gebaeudereinigung || false,
                sparte_gruenpflege || false, sparte_projekte || false]
        );
        res.status(201).json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.put('/stammdaten/:id', managerMiddleware, async (req, res) => {
    const { name, kategorie_id, artikel_kategorie_id, lieferant, einheit,
        preis_netto, preis_brutto, scancode, aktiv, benoetigt_pruefung,
        sparte_winterdienst, sparte_gebaeudereinigung, sparte_gruenpflege, sparte_projekte } = req.body;
    try {
        const r = await pool.query(
            `UPDATE bestelllisten_stammdaten SET
        name=COALESCE($1,name), kategorie_id=$2, artikel_kategorie_id=$3,
        lieferant=$4, einheit=$5, preis_netto=$6, preis_brutto=$7, scancode=$8, aktiv=COALESCE($9,aktiv),
        benoetigt_pruefung=COALESCE($10,benoetigt_pruefung),
        sparte_winterdienst=COALESCE($11,sparte_winterdienst),
        sparte_gebaeudereinigung=COALESCE($12,sparte_gebaeudereinigung),
        sparte_gruenpflege=COALESCE($13,sparte_gruenpflege),
        sparte_projekte=COALESCE($14,sparte_projekte)
       WHERE id=$15 RETURNING *`,
            [name, kategorie_id || null, artikel_kategorie_id || null, lieferant || null, einheit || null,
                preis_netto || null, preis_brutto || null, scancode || null, aktiv,
                benoetigt_pruefung === undefined ? null : benoetigt_pruefung,
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
    const { kategorie_id, bezeichnung, menge, einheit, lieferant, stammdaten_id, bestell_gruppe, ziel, fahrzeug_id } = req.body;
    if (!bezeichnung) return res.status(400).json({ error: 'Bezeichnung erforderlich' });
    try {
        const r = await pool.query(
            `INSERT INTO bestelllisten_eintraege (kategorie_id, bezeichnung, menge, einheit, lieferant, stammdaten_id, erstellt_von, bestell_gruppe, ziel, fahrzeug_id)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *`,
            [kategorie_id || null, bezeichnung, menge || null, einheit || null,
            lieferant || null, stammdaten_id || null, req.user.id, bestell_gruppe || null,
            ziel || 'lager', fahrzeug_id || null]
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
        m.name AS erfasst_von, bm.name AS bestellt_von_name,
        fz.kennzeichen AS fahrzeug_kennzeichen, fz.bezeichnung AS fahrzeug_bezeichnung
      FROM bestelllisten_eintraege e
      LEFT JOIN bestelllisten_kategorien k ON e.kategorie_id = k.id
      LEFT JOIN mitarbeiter m ON e.erstellt_von = m.id
      LEFT JOIN mitarbeiter bm ON e.bestellt_von = bm.id
      LEFT JOIN fahrzeuge fz ON e.fahrzeug_id = fz.id
      ORDER BY e.bestellt ASC, k.sort_order, k.name, e.erstellt_am DESC
    `);
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ── FAHRZEUGE ──────────────────────────────────────────────────────────────
router.get('/fahrzeuge', authMiddleware, async (req, res) => {
    try {
        const r = await pool.query('SELECT * FROM fahrzeuge WHERE aktiv = true ORDER BY kennzeichen');
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});
router.post('/fahrzeuge', authMiddleware, managerMiddleware, async (req, res) => {
    const { kennzeichen, bezeichnung } = req.body;
    if (!kennzeichen) return res.status(400).json({ error: 'Kennzeichen erforderlich' });
    try {
        const r = await pool.query('INSERT INTO fahrzeuge (kennzeichen, bezeichnung) VALUES ($1,$2) RETURNING *', [kennzeichen, bezeichnung || null]);
        res.status(201).json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});
router.delete('/fahrzeuge/:id', authMiddleware, managerMiddleware, async (req, res) => {
    try {
        await pool.query('UPDATE fahrzeuge SET aktiv=false WHERE id=$1', [req.params.id]);
        res.json({ ok: true });
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ── VERLAUF (gefiltert) ────────────────────────────────────────────────────
router.get('/verlauf', authMiddleware, managerMiddleware, async (req, res) => {
    try {
        const { von, bis, sparte_w, sparte_g, sparte_gr, sparte_p, kategorie_id } = req.query;
        let conditions = [];
        const params = [];
        let idx = 1;
        if (von) { conditions.push(`e.erstellt_am >= $${idx++}`); params.push(von + 'T00:00:00'); }
        if (bis) { conditions.push(`e.erstellt_am <= $${idx++}`); params.push(bis + 'T23:59:59'); }
        if (sparte_w || sparte_g || sparte_gr || sparte_p) {
            const sc = [];
            if (sparte_w) sc.push('s.sparte_winterdienst = true');
            if (sparte_g) sc.push('s.sparte_gebaeudereinigung = true');
            if (sparte_gr) sc.push('s.sparte_gruenpflege = true');
            if (sparte_p) sc.push('s.sparte_projekte = true');
            if (sc.length) conditions.push(`(${sc.join(' OR ')})`);
        }
        if (kategorie_id && !String(kategorie_id).startsWith('ak_')) {
            conditions.push(`e.kategorie_id = $${idx++}`);
            params.push(parseInt(kategorie_id));
        } else if (kategorie_id && String(kategorie_id).startsWith('ak_')) {
            conditions.push(`s.artikel_kategorie_id = $${idx++}`);
            params.push(parseInt(String(kategorie_id).replace('ak_', '')));
        }
        const where = conditions.length ? 'WHERE ' + conditions.join(' AND ') : '';
        const r = await pool.query(`
            SELECT e.*,
                k.name AS kategorie, k.icon AS kategorie_icon,
                ak.name AS artikel_kategorie,
                m.name AS erfasst_von, bm.name AS bestellt_von_name,
                s.sparte_winterdienst, s.sparte_gebaeudereinigung, s.sparte_gruenpflege, s.sparte_projekte
            FROM bestelllisten_eintraege e
            LEFT JOIN bestelllisten_kategorien k ON e.kategorie_id = k.id
            LEFT JOIN bestelllisten_stammdaten s ON e.stammdaten_id = s.id
            LEFT JOIN bestelllisten_artikel_kategorien ak ON s.artikel_kategorie_id = ak.id
            LEFT JOIN mitarbeiter m ON e.erstellt_von = m.id
            LEFT JOIN mitarbeiter bm ON e.bestellt_von = bm.id
            ${where}
            ORDER BY e.bestellt ASC, e.erstellt_am DESC
        `, params);
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;
