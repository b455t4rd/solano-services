CREATE TABLE IF NOT EXISTS zeiterfassung (
  id SERIAL PRIMARY KEY,
  mitarbeiter_id INTEGER REFERENCES mitarbeiter(id) ON DELETE CASCADE,
  mitarbeiter_name VARCHAR(200),
  typ VARCHAR(20) NOT NULL, -- 'kommen', 'gehen', 'pause_start', 'pause_ende', 'urlaub'
  zeitpunkt TIMESTAMPTZ DEFAULT NOW(),
  datum DATE DEFAULT CURRENT_DATE,
  notiz TEXT
);

CREATE TABLE IF NOT EXISTS kalender_settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  exchange_url VARCHAR(500),
  exchange_user VARCHAR(200),
  exchange_pass VARCHAR(200),
  sync_intervall_min INTEGER DEFAULT 15,
  letzter_sync TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS kalender_events (
  id VARCHAR(200) PRIMARY KEY,
  titel VARCHAR(500),
  start_zeit TIMESTAMPTZ,
  end_zeit TIMESTAMPTZ,
  ort VARCHAR(500),
  beschreibung TEXT,
  organisator VARCHAR(200),
  mitarbeiter_ids INTEGER[],
  synced_at TIMESTAMPTZ DEFAULT NOW()
);
