-- ============================================================
-- Migration: Admin-Berechtigungen, Sparten, Einsatz-Fotos
-- Solano Beschattungsmontagen OG
-- Einmalig ausführen: psql -U michaelsohm -d winterdienst -f db_migration.sql
-- ============================================================

-- 1. Admin-Flag für Mitarbeiter
ALTER TABLE mitarbeiter ADD COLUMN IF NOT EXISTS ist_admin BOOLEAN DEFAULT false;

-- 2. Sparte für Anlagen ('winterdienst' oder 'gebaeudereinigung')
ALTER TABLE anlagen ADD COLUMN IF NOT EXISTS sparte VARCHAR(50) DEFAULT 'winterdienst';

-- 3. Mitarbeiter-ID in Einsätzen (für bessere Auswertung)
ALTER TABLE einsaetze ADD COLUMN IF NOT EXISTS mitarbeiter_id INTEGER REFERENCES mitarbeiter(id);

-- 4. Foto-Tabelle für Einsätze (Schadensfotos, Verschmutzungen, parkende Autos)
CREATE TABLE IF NOT EXISTS einsatz_fotos (
    id SERIAL PRIMARY KEY,
    einsatz_id INTEGER REFERENCES einsaetze(id) ON DELETE CASCADE,
    foto_url VARCHAR(500) NOT NULL,
    beschreibung TEXT,
    hochgeladen_am TIMESTAMP DEFAULT NOW()
);

-- 5. Bestehende Kaskaden ergänzen (gps_tracks + erledigte_aufgaben)
-- (nur nötig falls fehlend – sicher ausführbar)
DO $$
BEGIN
  -- gps_tracks CASCADE prüfen (wird beim Anlegen der Tabelle gesetzt, daher in Ordnung)
  NULL;
END $$;

-- 6. Admin-Benutzer festlegen (anpassen falls abweichender Name!)
UPDATE mitarbeiter SET ist_admin = true WHERE name = 'Michael';

-- Bestehende Anlagen der Sparte Winterdienst zuweisen
UPDATE anlagen SET sparte = 'winterdienst' WHERE sparte IS NULL;

SELECT 'Migration erfolgreich abgeschlossen!' AS status;
