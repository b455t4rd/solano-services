-- Migration 15: Touren & geplante Aufträge
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS kundenname VARCHAR(200);
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS adresse TEXT;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS tour_id VARCHAR(50);
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS tour_position INTEGER DEFAULT 1;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS naechster_auftrag_id INTEGER REFERENCES projekt_auftraege(id) ON DELETE SET NULL;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS km_verbindung NUMERIC(8,2) DEFAULT 0;
