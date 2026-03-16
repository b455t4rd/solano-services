-- Migration 6: Chef-Rolle, Multi-TODO-Zuweisung, Push-Notifications

-- 1. Chef-Rolle
ALTER TABLE mitarbeiter ADD COLUMN IF NOT EXISTS ist_chef BOOLEAN DEFAULT false;

-- 2. Multi-Zuweisung (viele Mitarbeiter pro TODO)
CREATE TABLE IF NOT EXISTS todo_zuweisungen (
  todo_id        INTEGER REFERENCES todos(id) ON DELETE CASCADE,
  mitarbeiter_id INTEGER REFERENCES mitarbeiter(id) ON DELETE CASCADE,
  mitarbeiter_name VARCHAR(100),
  PRIMARY KEY (todo_id, mitarbeiter_id)
);

-- Bestehende Einzelzuweisungen migrieren
INSERT INTO todo_zuweisungen (todo_id, mitarbeiter_id, mitarbeiter_name)
SELECT id, zugewiesen_an_id, zugewiesen_an
FROM todos
WHERE zugewiesen_an_id IS NOT NULL
ON CONFLICT DO NOTHING;

-- 3. Push-Subscriptions (je Gerät eines Mitarbeiters)
CREATE TABLE IF NOT EXISTS push_subscriptions (
  id              SERIAL PRIMARY KEY,
  mitarbeiter_id  INTEGER REFERENCES mitarbeiter(id) ON DELETE CASCADE,
  mitarbeiter_name VARCHAR(100),
  subscription_json TEXT NOT NULL,
  erstellt_am     TIMESTAMP DEFAULT NOW()
);
-- Eindeutiger Index pro subscription-endpoint
CREATE UNIQUE INDEX IF NOT EXISTS idx_push_endpoint ON push_subscriptions
  ((subscription_json::json->>'endpoint'));

-- 4. Push-Log
CREATE TABLE IF NOT EXISTS push_log (
  id          SERIAL PRIMARY KEY,
  gesendet_am TIMESTAMP DEFAULT NOW(),
  gesendet_von VARCHAR(100),
  empfaenger  TEXT,
  nachricht   TEXT NOT NULL,
  erfolg      INTEGER DEFAULT 0,
  fehler      INTEGER DEFAULT 0
);
