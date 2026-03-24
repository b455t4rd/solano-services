-- Migration 21: Fehlende Kostenspalten in projekt_auftraege
-- Diese Spalten werden beim Abschließen von Projekten mit den aktuellen
-- Fahrzeug/MA-Kosten "eingefroren" für korrekte Nachkalkulation

ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS fz_diesel_preis NUMERIC;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS fz_verbrauch_100km NUMERIC;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS fz_maut_pro_km NUMERIC;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS fz_abnuetzung_pro_km NUMERIC;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS ma_stundensatz_fa NUMERIC;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS ma_stundensatz_ha NUMERIC;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS ma_stundensatz_gf NUMERIC;
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS ma_warnschwelle NUMERIC;
