-- ============================================================
-- Migration 3: Sparte-Spalte für Aufgaben und Einsätze
-- ============================================================

-- Sparte-Spalte zu aufgaben hinzufügen
ALTER TABLE aufgaben ADD COLUMN IF NOT EXISTS sparte VARCHAR(50) DEFAULT 'winterdienst';

-- Sparte-Spalte zu einsaetze hinzufügen
ALTER TABLE einsaetze ADD COLUMN IF NOT EXISTS sparte VARCHAR(50);

-- Bestehende Aufgaben: Sparte aus der Anlage ableiten.
-- Wenn die Anlage NUR in Gebäudereinigung ist → sparte = 'gebaeudereinigung'
-- Sonst bleibt der DEFAULT 'winterdienst'
UPDATE aufgaben a
SET sparte = 'gebaeudereinigung'
FROM anlagen an
WHERE an.id = a.anlage_id
  AND an.in_gebaeudereinigung = true
  AND an.in_winterdienst = false;

-- Bestehende Einsätze: Sparte aus dem alten sparte-Feld der Anlage ableiten
UPDATE einsaetze e
SET sparte = CASE
  WHEN an.in_gebaeudereinigung AND NOT an.in_winterdienst THEN 'gebaeudereinigung'
  ELSE 'winterdienst'
END
FROM anlagen an
WHERE an.id = e.anlage_id
  AND e.sparte IS NULL;

SELECT 'Migration 3 abgeschlossen!' AS status;
SELECT 'Aufgaben nach Sparte:' AS info;
SELECT sparte, COUNT(*) FROM aufgaben GROUP BY sparte;
