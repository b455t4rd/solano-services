-- Migration 11: Projekte (Montagen, Eigenaufträge, Auftragsarbeiten)

-- Auftraggeber (Heim&Haus, Hornbach, Blank, eigene Kunden...)
CREATE TABLE IF NOT EXISTS auftraggeber (
  id                 SERIAL PRIMARY KEY,
  name               VARCHAR(200) NOT NULL,
  gutschrift_prozent NUMERIC(5,2) DEFAULT 0, -- % vom Montagewert als Gutschrift
  stundensatz        NUMERIC(8,2) DEFAULT 0, -- Stundensatz für Eigenkunden
  aktiv              BOOLEAN DEFAULT TRUE,
  notiz              TEXT,
  erstellt_am        TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO auftraggeber (name, gutschrift_prozent, stundensatz) VALUES
  ('Heim & Haus', 0, 0),
  ('Hornbach',    0, 0),
  ('Blank',       0, 0)
ON CONFLICT DO NOTHING;

-- Projekt-Aufträge (Haupttabelle)
CREATE TABLE IF NOT EXISTS projekt_auftraege (
  id                    SERIAL PRIMARY KEY,
  auftraggeber_id       INTEGER REFERENCES auftraggeber(id) ON DELETE SET NULL,
  auftraggeber_name     VARCHAR(200),
  auftragsnummer        VARCHAR(100),         -- optional
  mitarbeiter_id        INTEGER REFERENCES mitarbeiter(id) ON DELETE SET NULL,
  mitarbeiter_name      VARCHAR(200),
  anzahl_mitarbeiter    INTEGER DEFAULT 2,

  -- Phasen-Zeitstempel
  fahrt_start           TIMESTAMPTZ,          -- Abfahrt (= Projekt-Start)
  ankunft               TIMESTAMPTZ,          -- Am Ziel (Arbeit beginnt)
  abfahrt_zeit          TIMESTAMPTZ,          -- Arbeit fertig, Rückfahrt
  fahrt_ende            TIMESTAMPTZ,          -- Zuhause (Abgeschlossen)

  -- Berechnete Werte (in Minuten / km)
  fahrzeit_hin_min      INTEGER DEFAULT 0,
  arbeitszeit_min       INTEGER DEFAULT 0,
  fahrzeit_zurueck_min  INTEGER DEFAULT 0,
  km_hin                NUMERIC(8,2) DEFAULT 0,
  km_zurueck            NUMERIC(8,2) DEFAULT 0,

  -- GPS-Punkte (JSON Array: [{lat,lng,ts,kmh}])
  gps_punkte            JSONB DEFAULT '[]',

  -- Beschreibung
  notiz                 TEXT,                 -- allgemeine Notiz
  besonderheiten        TEXT,                 -- unvorhergesehenes (optional)

  -- Status
  status                VARCHAR(20) DEFAULT 'fahrt',
  -- fahrt | arbeit | rueckfahrt | abgeschlossen

  -- Abrechnung (wird später ergänzt)
  montagewert_netto     NUMERIC(10,2),        -- offizieller Montagewert laut AG
  gutschrift_betrag     NUMERIC(10,2),        -- tatsächlich erhaltene Gutschrift
  gutschrift_datum      DATE,
  gutschrift_nummer     VARCHAR(100),

  erstellt_am           TIMESTAMPTZ DEFAULT NOW(),
  abgeschlossen_am      TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_projekt_ma    ON projekt_auftraege(mitarbeiter_id);
CREATE INDEX IF NOT EXISTS idx_projekt_ag    ON projekt_auftraege(auftraggeber_id);
CREATE INDEX IF NOT EXISTS idx_projekt_datum ON projekt_auftraege(erstellt_am);
