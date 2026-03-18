-- Migration 20: Private Todos + Firmendaten

CREATE TABLE IF NOT EXISTS todos_privat (
  id SERIAL PRIMARY KEY,
  mitarbeiter_id INTEGER REFERENCES mitarbeiter(id) ON DELETE CASCADE,
  beschreibung TEXT NOT NULL,
  erledigt BOOLEAN DEFAULT FALSE,
  erstellt_am TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS firma_einstellungen (
  id INTEGER PRIMARY KEY DEFAULT 1,
  name VARCHAR(200),
  anschrift TEXT,
  uid_atu VARCHAR(50),
  logo_base64 TEXT,
  CONSTRAINT singleton CHECK (id = 1)
);
INSERT INTO firma_einstellungen (id) VALUES (1) ON CONFLICT DO NOTHING;
