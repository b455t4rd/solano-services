const express = require('express');
const router = express.Router();
const pool = require('../db');
const { authMiddleware, adminMiddleware, managerMiddleware } = require('../middleware/auth');

// ── Middleware: darf bestellen (authMiddleware + darf_bestellen ODER admin/chef) ──
async function bestellMiddleware(req, res, next) {
    authMiddleware(req, res, async () => {
        if (req.user.ist_admin || req.user.ist_chef) return next();
        try {
            const r = await pool.query('SELECT darf_bestellen FROM mitarbeiter WHERE id=$1', [req.user.id]);
            if (r.rows[0]?.darf_bestellen) return next();
            res.status(403).json({ error: 'Kein Zugriff auf Bestellungen' });
        } catch (e) { res.status(500).json({ error: e.message }); }
    });
}

// ══════════════════════════════════════════════════════════════════════════════
// KATEGORIEN
// ══════════════════════════════════════════════════════════════════════════════

router.get('/kategorien', authMiddleware, async (req, res) => {
    try {
        const r = await pool.query('SELECT * FROM bestelllisten_kategorien ORDER BY sort_order, id');
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
        res.json({ ok: true });
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ══════════════════════════════════════════════════════════════════════════════
// STAMMDATEN (Artikel-Vorschläge)
// ══════════════════════════════════════════════════════════════════════════════

router.get('/stammdaten', authMiddleware, async (req, res) => {
    try {
        const r = await pool.query(
            `SELECT s.*, k.name as kategorie_name, k.icon as kategorie_icon
       FROM bestelllisten_stammdaten s
       LEFT JOIN bestelllisten_kategorien k ON k.id=s.kategorie_id
       WHERE s.aktiv=true ORDER BY s.name`
        );
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/stammdaten', managerMiddleware, async (req, res) => {
    const { name, kategorie_id, lieferant, einheit } = req.body;
    if (!name) return res.status(400).json({ error: 'Name erforderlich' });
    try {
        const r = await pool.query(
            'INSERT INTO bestelllisten_stammdaten (name, kategorie_id, lieferant, einheit) VALUES ($1,$2,$3,$4) RETURNING *',
            [name, kategorie_id || null, lieferant || null, einheit || null]
        );
        res.status(201).json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.put('/stammdaten/:id', managerMiddleware, async (req, res) => {
    const { name, kategorie_id, lieferant, einheit, aktiv } = req.body;
    try {
        const r = await pool.query(
            'UPDATE bestelllisten_stammdaten SET name=COALESCE($1,name), kategorie_id=COALESCE($2,kategorie_id), lieferant=$3, einheit=$4, aktiv=COALESCE($5,aktiv) WHERE id=$6 RETURNING *',
            [name, kategorie_id, lieferant ?? null, einheit ?? null, aktiv, req.params.id]
        );
        res.json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.delete('/stammdaten/:id', managerMiddleware, async (req, res) => {
    try {
        await pool.query('DELETE FROM bestelllisten_stammdaten WHERE id=$1', [req.params.id]);
        res.json({ ok: true });
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ══════════════════════════════════════════════════════════════════════════════
// EINTRÄGE
// ══════════════════════════════════════════════════════════════════════════════

router.get('/eintraege', authMiddleware, async (req, res) => {
    const { kategorie_id } = req.query;
    try {
        let q = `SELECT e.*, k.name as kategorie_name, k.icon as kategorie_icon, k.farbe as kategorie_farbe,
               m.name as erstellt_von_name, mb.name as bestellt_von_name
             FROM bestelllisten_eintraege e
             LEFT JOIN bestelllisten_kategorien k ON k.id=e.kategorie_id
             LEFT JOIN mitarbeiter m ON m.id=e.erstellt_von
             LEFT JOIN mitarbeiter mb ON mb.id=e.bestellt_von`;
        const params = [];
        if (kategorie_id) { params.push(kategorie_id); q += ` WHERE e.kategorie_id=$1`; }
        q += ' ORDER BY e.bestellt ASC, e.erstellt_am DESC';
        const r = await pool.query(q, params);
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/eintraege', bestellMiddleware, async (req, res) => {
    const { kategorie_id, bezeichnung, menge, einheit, lieferant, stammdaten_id } = req.body;
    if (!bezeichnung) return res.status(400).json({ error: 'Bezeichnung erforderlich' });
    try {
        const r = await pool.query(
            `INSERT INTO bestelllisten_eintraege
         (kategorie_id, bezeichnung, menge, einheit, lieferant, stammdaten_id, erstellt_von)
       VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *`,
            [kategorie_id || null, bezeichnung, menge || null, einheit || null, lieferant || null, stammdaten_id || null, req.user.id]
        );
        res.status(201).json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.patch('/eintraege/:id/bestellt', managerMiddleware, async (req, res) => {
    const { bestellt } = req.body;
    try {
        const r = await pool.query(
            `UPDATE bestelllisten_eintraege SET bestellt=$1,
         bestellt_von=CASE WHEN $1=true THEN $2 ELSE NULL END,
         bestellt_am=CASE WHEN $1=true THEN NOW() ELSE NULL END
       WHERE id=$3 RETURNING *`,
            [!!bestellt, req.user.id, req.params.id]
        );
        res.json(r.rows[0]);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

router.delete('/eintraege/:id', bestellMiddleware, async (req, res) => {
    try {
        // Nur eigene Einträge löschen, außer Admin/Chef
        const { rows } = await pool.query('SELECT erstellt_von FROM bestelllisten_eintraege WHERE id=$1', [req.params.id]);
        if (!rows.length) return res.status(404).json({ error: 'Nicht gefunden' });
        if (!req.user.ist_admin && !req.user.ist_chef && rows[0].erstellt_von !== req.user.id) {
            return res.status(403).json({ error: 'Kein Zugriff' });
        }
        await pool.query('DELETE FROM bestelllisten_eintraege WHERE id=$1', [req.params.id]);
        res.json({ ok: true });
    } catch (e) { res.status(500).json({ error: e.message }); }
});

// ══════════════════════════════════════════════════════════════════════════════
// EXPORT: JSON für Frontend-PDF/Excel (Frontend übernimmt Rendering)
// ══════════════════════════════════════════════════════════════════════════════

router.get('/export-data', managerMiddleware, async (req, res) => {
    try {
        const r = await pool.query(
            `SELECT e.bezeichnung, e.menge, e.einheit, e.lieferant,
              e.bestellt, e.erstellt_am, e.bestellt_am,
              k.name as kategorie, k.icon as kategorie_icon,
              m.name as erfasst_von, mb.name as bestellt_von_name
       FROM bestelllisten_eintraege e
       LEFT JOIN bestelllisten_kategorien k ON k.id=e.kategorie_id
       LEFT JOIN mitarbeiter m ON m.id=e.erstellt_von
       LEFT JOIN mitarbeiter mb ON mb.id=e.bestellt_von
       ORDER BY k.sort_order, k.name, e.bestellt ASC, e.bezeichnung`
        );
        res.json(r.rows);
    } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;
