-- Migration 14: Sessions für Mehrtermin-Projekte
ALTER TABLE projekt_auftraege ADD COLUMN IF NOT EXISTS sessions JSONB DEFAULT '[]';
