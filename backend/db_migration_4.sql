-- ============================================================
-- Migration 4: Grünpflege-Sparte, Per-Sparte-Lagerbilder, TODOs
-- Einmalig ausführen: psql -U michaelsohm -d winterdienst -f db_migration_4.sql
-- ============================================================

-- 1. Grünpflege-Flag für Anlagen
ALTER TABLE anlagen ADD COLUMN IF NOT EXISTS in_gruenpflege BOOLEAN DEFAULT false;

-- 2. Per-Sparte Lagerbilder
ALTER TABLE anlagen ADD COLUMN IF NOT EXISTS bild_url_winter VARCHAR(500);
ALTER TABLE anlagen ADD COLUMN IF NOT EXISTS bild_url_gebaeudereinigung VARCHAR(500);
ALTER TABLE anlagen ADD COLUMN IF NOT EXISTS bild_url_gruenpflege VARCHAR(500);

-- Bestehende bild_url → bild_url_winter migrieren
UPDATE anlagen SET bild_url_winter = bild_url WHERE bild_url IS NOT NULL AND bild_url_winter IS NULL;

-- 3. TODO-Tabelle
CREATE TABLE IF NOT EXISTS todos (
  id SERIAL PRIMARY KEY,
  anlage_id INTEGER REFERENCES anlagen(id),
  einsatz_id INTEGER REFERENCES einsaetze(id),
  mitarbeiter VARCHAR(200),
  mitarbeiter_id INTEGER,
  beschreibung TEXT NOT NULL,
  erledigt BOOLEAN DEFAULT false,
  erstellt_am TIMESTAMPTZ DEFAULT NOW(),
  erledigt_am TIMESTAMPTZ,
  erledigt_von VARCHAR(200)
);

SELECT 'Migration 4 abgeschlossen!' AS status;
SELECT 'Neue Spalten: in_gruenpflege, bild_url_winter, bild_url_gebaeudereinigung, bild_url_gruenpflege, Tabelle: todos' AS info;
