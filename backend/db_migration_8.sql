ALTER TABLE mitarbeiter ADD COLUMN IF NOT EXISTS winterdienst_alarm BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS alarm_log (
  id SERIAL PRIMARY KEY,
  gesendet_von VARCHAR(200),
  gesendet_am TIMESTAMPTZ DEFAULT NOW(),
  empfaenger_count INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS alarm_bestaetigung (
  id SERIAL PRIMARY KEY,
  alarm_id INTEGER REFERENCES alarm_log(id) ON DELETE CASCADE,
  mitarbeiter_id INTEGER REFERENCES mitarbeiter(id) ON DELETE CASCADE,
  mitarbeiter_name VARCHAR(200),
  bestaetigt_am TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(alarm_id, mitarbeiter_id)
);
