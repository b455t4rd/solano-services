-- Migration 10: Vollständige Zeiterfassung (Österreich-konform)

-- Mitarbeiter: Soll-Stunden und Beschäftigungsart
ALTER TABLE mitarbeiter
  ADD COLUMN IF NOT EXISTS soll_stunden  NUMERIC(4,2) DEFAULT 38.5,
  ADD COLUMN IF NOT EXISTS beschaeftigung VARCHAR(20)  DEFAULT 'vollzeit';

-- Zeiterfassung: Audit-Spalten für Änderungsprotokoll
ALTER TABLE zeiterfassung
  ADD COLUMN IF NOT EXISTS geaendert_von_id   INTEGER,
  ADD COLUMN IF NOT EXISTS geaendert_von_name VARCHAR(200),
  ADD COLUMN IF NOT EXISTS geaendert_am       TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS original_zeitpunkt TIMESTAMPTZ;

-- Monatsfreigabe
CREATE TABLE IF NOT EXISTS zeiterfassung_freigabe (
  id                   SERIAL PRIMARY KEY,
  mitarbeiter_id       INTEGER REFERENCES mitarbeiter(id) ON DELETE CASCADE,
  mitarbeiter_name     VARCHAR(200),
  monat                DATE NOT NULL,   -- immer erster des Monats
  freigegeben_von_id   INTEGER,
  freigegeben_von_name VARCHAR(200),
  freigegeben_am       TIMESTAMPTZ DEFAULT NOW(),
  notiz                TEXT,
  UNIQUE(mitarbeiter_id, monat)
);

-- Österreichische Feiertage
CREATE TABLE IF NOT EXISTS feiertage (
  datum DATE PRIMARY KEY,
  name  VARCHAR(100) NOT NULL
);

INSERT INTO feiertage (datum, name) VALUES
  ('2025-01-01','Neujahr'),
  ('2025-01-06','Heilige Drei Könige'),
  ('2025-04-21','Ostermontag'),
  ('2025-05-01','Staatsfeiertag'),
  ('2025-05-29','Christi Himmelfahrt'),
  ('2025-06-09','Pfingstmontag'),
  ('2025-06-19','Fronleichnam'),
  ('2025-08-15','Mariä Himmelfahrt'),
  ('2025-10-26','Nationalfeiertag'),
  ('2025-11-01','Allerheiligen'),
  ('2025-12-08','Mariä Empfängnis'),
  ('2025-12-25','Christtag'),
  ('2025-12-26','Stefanitag'),
  ('2026-01-01','Neujahr'),
  ('2026-01-06','Heilige Drei Könige'),
  ('2026-04-06','Ostermontag'),
  ('2026-05-01','Staatsfeiertag'),
  ('2026-05-14','Christi Himmelfahrt'),
  ('2026-05-25','Pfingstmontag'),
  ('2026-06-04','Fronleichnam'),
  ('2026-08-15','Mariä Himmelfahrt'),
  ('2026-10-26','Nationalfeiertag'),
  ('2026-11-01','Allerheiligen'),
  ('2026-12-08','Mariä Empfängnis'),
  ('2026-12-25','Christtag'),
  ('2026-12-26','Stefanitag'),
  ('2027-01-01','Neujahr'),
  ('2027-01-06','Heilige Drei Könige'),
  ('2027-03-29','Ostermontag'),
  ('2027-05-01','Staatsfeiertag'),
  ('2027-05-06','Christi Himmelfahrt'),
  ('2027-05-17','Pfingstmontag'),
  ('2027-05-27','Fronleichnam'),
  ('2027-08-15','Mariä Himmelfahrt'),
  ('2027-10-26','Nationalfeiertag'),
  ('2027-11-01','Allerheiligen'),
  ('2027-12-08','Mariä Empfängnis'),
  ('2027-12-25','Christtag'),
  ('2027-12-26','Stefanitag')
ON CONFLICT DO NOTHING;
