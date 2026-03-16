-- ============================================================
-- Migration 2: Sparten als boolesche Flags
-- Einmalig ausführen: psql -U michaelsohm -d winterdienst -f db_migration_2.sql
-- ============================================================

-- Neue Spalten für Sparten-Zugehörigkeit
ALTER TABLE anlagen ADD COLUMN IF NOT EXISTS in_winterdienst BOOLEAN DEFAULT false;
ALTER TABLE anlagen ADD COLUMN IF NOT EXISTS in_gebaeudereinigung BOOLEAN DEFAULT false;

-- Bestehende Daten migrieren
UPDATE anlagen SET in_winterdienst = true
  WHERE sparte = 'winterdienst' OR sparte IS NULL OR (in_winterdienst = false AND in_gebaeudereinigung = false);

UPDATE anlagen SET in_gebaeudereinigung = true
  WHERE sparte = 'gebaeudereinigung';

SELECT 'Migration 2 abgeschlossen!' AS status;
SELECT name, in_winterdienst, in_gebaeudereinigung FROM anlagen;
