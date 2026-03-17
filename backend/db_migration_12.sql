-- Migration 12: Fahrzeugkosten-Einstellungen
CREATE TABLE IF NOT EXISTS fahrzeug_einstellungen (
  id INTEGER PRIMARY KEY DEFAULT 1,
  diesel_preis NUMERIC(6,3) DEFAULT 1.80,
  verbrauch_100km NUMERIC(5,2) DEFAULT 8.0,
  maut_pro_km NUMERIC(6,4) DEFAULT 0.0,
  abnuetzung_pro_km NUMERIC(6,4) DEFAULT 0.15,
  aktualisiert_am TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT single_row CHECK (id = 1)
);
INSERT INTO fahrzeug_einstellungen (id) VALUES (1) ON CONFLICT DO NOTHING;
GRANT ALL ON fahrzeug_einstellungen TO solano;
