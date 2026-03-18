ALTER TABLE projekt_auftraege
  ADD COLUMN IF NOT EXISTS geplant_uhrzeit TIME,
  ADD COLUMN IF NOT EXISTS geplant_dauer_min INTEGER DEFAULT 120;
