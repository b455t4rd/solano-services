-- Winterdienst Datenbank Schema
-- Solano Beschattungsmontagen OG

CREATE DATABASE winterdienst;
\c winterdienst;

-- Wohnanlagen
CREATE TABLE anlagen (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    adresse VARCHAR(300) NOT NULL,
    plz VARCHAR(10),
    ort VARCHAR(100),
    lat DECIMAL(10, 8),
    lng DECIMAL(11, 8),
    info_text TEXT,
    bild_url VARCHAR(500),
    aktiv BOOLEAN DEFAULT true,
    erstellt_am TIMESTAMP DEFAULT NOW()
);

-- Checklisten-Aufgaben pro Anlage (was muss gemacht werden)
CREATE TABLE aufgaben (
    id SERIAL PRIMARY KEY,
    anlage_id INTEGER REFERENCES anlagen(id) ON DELETE CASCADE,
    bezeichnung VARCHAR(200) NOT NULL,
    reihenfolge INTEGER DEFAULT 0
);

-- Einsätze (ein Einsatz = ein Besuch bei einer Anlage)
CREATE TABLE einsaetze (
    id SERIAL PRIMARY KEY,
    anlage_id INTEGER REFERENCES anlagen(id),
    mitarbeiter VARCHAR(100),
    datum DATE NOT NULL,
    start_zeit TIMESTAMP,
    end_zeit TIMESTAMP,
    notiz TEXT,
    erstellt_am TIMESTAMP DEFAULT NOW()
);

-- GPS Tracking Punkte pro Einsatz
CREATE TABLE gps_tracks (
    id SERIAL PRIMARY KEY,
    einsatz_id INTEGER REFERENCES einsaetze(id) ON DELETE CASCADE,
    lat DECIMAL(10, 8) NOT NULL,
    lng DECIMAL(11, 8) NOT NULL,
    zeitpunkt TIMESTAMP NOT NULL,
    genauigkeit DECIMAL(8, 2)
);

-- Erledigte Aufgaben pro Einsatz
CREATE TABLE erledigte_aufgaben (
    id SERIAL PRIMARY KEY,
    einsatz_id INTEGER REFERENCES einsaetze(id) ON DELETE CASCADE,
    aufgabe_id INTEGER REFERENCES aufgaben(id),
    erledigt_um TIMESTAMP DEFAULT NOW()
);

-- Mitarbeiter (einfach, kein komplexes Auth)
CREATE TABLE mitarbeiter (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    pin VARCHAR(10),
    aktiv BOOLEAN DEFAULT true
);

-- Beispieldaten einfügen
INSERT INTO mitarbeiter (name, pin) VALUES 
    ('Michael', '1234'),
    ('Mitarbeiter 2', '5678');

INSERT INTO anlagen (name, adresse, plz, ort, lat, lng, info_text) VALUES
    ('Testanlage Muster', 'Musterstraße 1', '6800', 'Feldkirch', 47.2372, 9.5966, 'Einfahrt von Norden. Salzkiste neben Eingang.'),
    ('Beispiel Wohnpark', 'Hauptstraße 42', '6850', 'Dornbirn', 47.4128, 9.7417, 'Parkplatz muss komplett geräumt werden. Kontakt: Hr. Muster 0664/123456');

INSERT INTO aufgaben (anlage_id, bezeichnung, reihenfolge) VALUES
    (1, 'Einfahrt räumen', 1),
    (1, 'Gehwege streuen', 2),
    (1, 'Parkplatz räumen', 3),
    (2, 'Haupteingang freimachen', 1),
    (2, 'Parkplatz räumen', 2),
    (2, 'Nebeneingang kontrollieren', 3);

\echo 'Datenbank erfolgreich eingerichtet!'
