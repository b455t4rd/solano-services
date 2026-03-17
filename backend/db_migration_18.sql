-- Migration 18: adresse_ort + auftraggeber fahrzeit_bezahlt

-- Ort-Feld für Projekte (falls noch nicht vorhanden)
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS adresse_ort VARCHAR(100);

-- Fahrzeit-bezahlt Flag pro Auftraggeber (Standard: true = wird verrechnet)
ALTER TABLE auftraggeber ADD COLUMN IF NOT EXISTS fahrzeit_bezahlt BOOLEAN DEFAULT TRUE;

GRANT ALL ON auftraggeber TO solano;
