-- Migration 16: Rapport-Felder für Projektaufträge
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS rapport_erforderlich BOOLEAN DEFAULT false;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS rapport_beschreibung TEXT;
