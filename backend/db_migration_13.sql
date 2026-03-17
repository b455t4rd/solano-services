-- Migration 13: zeige_projekte für Mitarbeiter
ALTER TABLE mitarbeiter ADD COLUMN IF NOT EXISTS zeige_projekte BOOLEAN DEFAULT TRUE;
