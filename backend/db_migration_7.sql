CREATE TABLE IF NOT EXISTS nachrichten (
  id SERIAL PRIMARY KEY,
  von_id INTEGER REFERENCES mitarbeiter(id) ON DELETE SET NULL,
  von_name VARCHAR(200),
  an_id INTEGER REFERENCES mitarbeiter(id) ON DELETE CASCADE,
  an_name VARCHAR(200),
  text TEXT NOT NULL,
  gesendet_am TIMESTAMPTZ DEFAULT NOW(),
  antwort VARCHAR(10), -- 'ja' oder 'nein'
  antwort_am TIMESTAMPTZ,
  gelesen BOOLEAN DEFAULT false
);
