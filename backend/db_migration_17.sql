-- Migration 17: Geplant-Datum, Adresse-Felder, Sortierung, MA-Typen, Mitarbeiterkosten-Einstellungen

-- Datum für geplante Aufträge (optional)
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS geplant_datum DATE;

-- Adresse aufgeteilt für bessere Navigation
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS adresse_strasse VARCHAR(200);
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS adresse_plz VARCHAR(20);
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS adresse_land VARCHAR(100) DEFAULT 'Österreich';

-- Drag & Drop Sortierreihenfolge
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS sort_order INTEGER DEFAULT 0;

-- Mitarbeiter-Typen: [{typ:'FA',anzahl:2},{typ:'HA',anzahl:1}]
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS ma_typen JSONB DEFAULT '[]';

-- Mitarbeiterkosten-Einstellungen Tabelle
CREATE TABLE IF NOT EXISTS ma_kosten_einstellungen (
  id INTEGER PRIMARY KEY DEFAULT 1,
  stundensatz_fa NUMERIC(6,2) DEFAULT 55.00,
  stundensatz_ha NUMERIC(6,2) DEFAULT 45.00,
  stundensatz_gf NUMERIC(6,2) DEFAULT 35.00,
  warnschwelle NUMERIC(6,2) DEFAULT 55.00,
  aktualisiert_am TIMESTAMP DEFAULT NOW(),
  CONSTRAINT ma_kosten_single_row CHECK (id = 1)
);
INSERT INTO ma_kosten_einstellungen (id) VALUES (1) ON CONFLICT DO NOTHING;
GRANT ALL ON ma_kosten_einstellungen TO solano;
