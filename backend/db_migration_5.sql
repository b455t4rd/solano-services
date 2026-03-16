-- Migration 5: Neue Features
-- 1. Drag & Drop Reihenfolge pro Benutzer pro Sparte
CREATE TABLE IF NOT EXISTS benutzer_anlage_reihenfolge (
  mitarbeiter_id INTEGER REFERENCES mitarbeiter(id) ON DELETE CASCADE,
  anlage_id      INTEGER REFERENCES anlagen(id)     ON DELETE CASCADE,
  sparte         VARCHAR(50) NOT NULL,
  position       INTEGER     NOT NULL,
  PRIMARY KEY (mitarbeiter_id, anlage_id, sparte)
);

-- 2. GPS-Check Ergebnis beim Einsatz-Start
ALTER TABLE einsaetze ADD COLUMN IF NOT EXISTS gps_check_ok BOOLEAN;

-- 3. Sparten-Filter pro Mitarbeiter
ALTER TABLE mitarbeiter ADD COLUMN IF NOT EXISTS zeige_winterdienst      BOOLEAN DEFAULT true;
ALTER TABLE mitarbeiter ADD COLUMN IF NOT EXISTS zeige_gebaeudereinigung  BOOLEAN DEFAULT true;
ALTER TABLE mitarbeiter ADD COLUMN IF NOT EXISTS zeige_gruenpflege        BOOLEAN DEFAULT true;

-- 4. TODO-Zuweisung an Mitarbeiter
ALTER TABLE todos ADD COLUMN IF NOT EXISTS zugewiesen_an_id INTEGER REFERENCES mitarbeiter(id) ON DELETE SET NULL;
ALTER TABLE todos ADD COLUMN IF NOT EXISTS zugewiesen_an    VARCHAR(100);
