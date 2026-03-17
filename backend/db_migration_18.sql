-- Migration 18: adresse_ort + auftraggeber fahrzeit_bezahlt + fahrtkosten_pauschale

-- Ort-Feld für Projekte (falls noch nicht vorhanden)
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS adresse_ort VARCHAR(100);

-- Fahrtkostenpauschale (freier Betrag, wird zur Gutschrift addiert)
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS fahrtkosten_pauschale NUMERIC(8,2) DEFAULT 0;

-- Fahrzeit-bezahlt Flag pro Auftraggeber (Standard: true = wird verrechnet)
ALTER TABLE auftraggeber ADD COLUMN IF NOT EXISTS fahrzeit_bezahlt BOOLEAN DEFAULT TRUE;

GRANT ALL ON ALL TABLES IN SCHEMA public TO solano;
