-- Migration 22: Telefon, Email, Aufmaß für Projekte
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS telefon VARCHAR(50);
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS email VARCHAR(200);
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS ist_aufmass BOOLEAN DEFAULT false;
