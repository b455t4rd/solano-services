--
-- PostgreSQL database dump
--

\restrict tVgF0g8ZGs7go9IoEDj9k9khuQ7xA7iD5Sm4JCaTCmyP3dA0UwpgauvMIQENlNi

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.zeiterfassung DROP CONSTRAINT IF EXISTS zeiterfassung_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.zeiterfassung_freigabe DROP CONSTRAINT IF EXISTS zeiterfassung_freigabe_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.todos DROP CONSTRAINT IF EXISTS todos_zugewiesen_an_id_fkey;
ALTER TABLE IF EXISTS ONLY public.todos_privat DROP CONSTRAINT IF EXISTS todos_privat_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.todos DROP CONSTRAINT IF EXISTS todos_einsatz_id_fkey;
ALTER TABLE IF EXISTS ONLY public.todos DROP CONSTRAINT IF EXISTS todos_anlage_id_fkey;
ALTER TABLE IF EXISTS ONLY public.todo_zuweisungen DROP CONSTRAINT IF EXISTS todo_zuweisungen_todo_id_fkey;
ALTER TABLE IF EXISTS ONLY public.todo_zuweisungen DROP CONSTRAINT IF EXISTS todo_zuweisungen_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.push_subscriptions DROP CONSTRAINT IF EXISTS push_subscriptions_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.projekt_auftraege DROP CONSTRAINT IF EXISTS projekt_auftraege_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.projekt_auftraege DROP CONSTRAINT IF EXISTS projekt_auftraege_auftraggeber_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nachrichten DROP CONSTRAINT IF EXISTS nachrichten_von_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nachrichten DROP CONSTRAINT IF EXISTS nachrichten_an_id_fkey;
ALTER TABLE IF EXISTS ONLY public.gps_tracks DROP CONSTRAINT IF EXISTS gps_tracks_einsatz_id_fkey;
ALTER TABLE IF EXISTS ONLY public.erledigte_aufgaben DROP CONSTRAINT IF EXISTS erledigte_aufgaben_einsatz_id_fkey;
ALTER TABLE IF EXISTS ONLY public.erledigte_aufgaben DROP CONSTRAINT IF EXISTS erledigte_aufgaben_aufgabe_id_fkey;
ALTER TABLE IF EXISTS ONLY public.einsatz_fotos DROP CONSTRAINT IF EXISTS einsatz_fotos_einsatz_id_fkey;
ALTER TABLE IF EXISTS ONLY public.einsaetze DROP CONSTRAINT IF EXISTS einsaetze_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.einsaetze DROP CONSTRAINT IF EXISTS einsaetze_anlage_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_stammdaten DROP CONSTRAINT IF EXISTS bestelllisten_stammdaten_kategorie_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_stammdaten DROP CONSTRAINT IF EXISTS bestelllisten_stammdaten_erstellt_von_fkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_stammdaten DROP CONSTRAINT IF EXISTS bestelllisten_stammdaten_artikel_kategorie_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_eintraege DROP CONSTRAINT IF EXISTS bestelllisten_eintraege_stammdaten_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_eintraege DROP CONSTRAINT IF EXISTS bestelllisten_eintraege_kategorie_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_eintraege DROP CONSTRAINT IF EXISTS bestelllisten_eintraege_erstellt_von_fkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_eintraege DROP CONSTRAINT IF EXISTS bestelllisten_eintraege_bestellt_von_fkey;
ALTER TABLE IF EXISTS ONLY public.benutzer_anlage_reihenfolge DROP CONSTRAINT IF EXISTS benutzer_anlage_reihenfolge_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.benutzer_anlage_reihenfolge DROP CONSTRAINT IF EXISTS benutzer_anlage_reihenfolge_anlage_id_fkey;
ALTER TABLE IF EXISTS ONLY public.aufgaben DROP CONSTRAINT IF EXISTS aufgaben_anlage_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alarm_bestaetigung DROP CONSTRAINT IF EXISTS alarm_bestaetigung_mitarbeiter_id_fkey;
ALTER TABLE IF EXISTS ONLY public.alarm_bestaetigung DROP CONSTRAINT IF EXISTS alarm_bestaetigung_alarm_id_fkey;
DROP INDEX IF EXISTS public.idx_system_logs_created;
DROP INDEX IF EXISTS public.idx_push_endpoint;
DROP INDEX IF EXISTS public.idx_projekt_ma;
DROP INDEX IF EXISTS public.idx_projekt_datum;
DROP INDEX IF EXISTS public.idx_projekt_ag;
DROP INDEX IF EXISTS public.idx_einsaetze_no_dup;
ALTER TABLE IF EXISTS ONLY public.zeiterfassung DROP CONSTRAINT IF EXISTS zeiterfassung_pkey;
ALTER TABLE IF EXISTS ONLY public.zeiterfassung_freigabe DROP CONSTRAINT IF EXISTS zeiterfassung_freigabe_pkey;
ALTER TABLE IF EXISTS ONLY public.zeiterfassung_freigabe DROP CONSTRAINT IF EXISTS zeiterfassung_freigabe_mitarbeiter_id_monat_key;
ALTER TABLE IF EXISTS ONLY public.todos_privat DROP CONSTRAINT IF EXISTS todos_privat_pkey;
ALTER TABLE IF EXISTS ONLY public.todos DROP CONSTRAINT IF EXISTS todos_pkey;
ALTER TABLE IF EXISTS ONLY public.todo_zuweisungen DROP CONSTRAINT IF EXISTS todo_zuweisungen_pkey;
ALTER TABLE IF EXISTS ONLY public.system_logs DROP CONSTRAINT IF EXISTS system_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.push_subscriptions DROP CONSTRAINT IF EXISTS push_subscriptions_pkey;
ALTER TABLE IF EXISTS ONLY public.push_log DROP CONSTRAINT IF EXISTS push_log_pkey;
ALTER TABLE IF EXISTS ONLY public.projekt_auftraege DROP CONSTRAINT IF EXISTS projekt_auftraege_pkey;
ALTER TABLE IF EXISTS ONLY public.nachrichten DROP CONSTRAINT IF EXISTS nachrichten_pkey;
ALTER TABLE IF EXISTS ONLY public.mitarbeiter DROP CONSTRAINT IF EXISTS mitarbeiter_pkey;
ALTER TABLE IF EXISTS ONLY public.ma_kosten_einstellungen DROP CONSTRAINT IF EXISTS ma_kosten_einstellungen_pkey;
ALTER TABLE IF EXISTS ONLY public.kalender_settings DROP CONSTRAINT IF EXISTS kalender_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.kalender_events DROP CONSTRAINT IF EXISTS kalender_events_pkey;
ALTER TABLE IF EXISTS ONLY public.gps_tracks DROP CONSTRAINT IF EXISTS gps_tracks_pkey;
ALTER TABLE IF EXISTS ONLY public.firma_einstellungen DROP CONSTRAINT IF EXISTS firma_einstellungen_pkey;
ALTER TABLE IF EXISTS ONLY public.feiertage DROP CONSTRAINT IF EXISTS feiertage_pkey;
ALTER TABLE IF EXISTS ONLY public.fahrzeuge DROP CONSTRAINT IF EXISTS fahrzeuge_pkey;
ALTER TABLE IF EXISTS ONLY public.fahrzeug_einstellungen DROP CONSTRAINT IF EXISTS fahrzeug_einstellungen_pkey;
ALTER TABLE IF EXISTS ONLY public.erledigte_aufgaben DROP CONSTRAINT IF EXISTS erledigte_aufgaben_pkey;
ALTER TABLE IF EXISTS ONLY public.einsatz_fotos DROP CONSTRAINT IF EXISTS einsatz_fotos_pkey;
ALTER TABLE IF EXISTS ONLY public.einsaetze DROP CONSTRAINT IF EXISTS einsaetze_pkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_stammdaten DROP CONSTRAINT IF EXISTS bestelllisten_stammdaten_pkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_kategorien DROP CONSTRAINT IF EXISTS bestelllisten_kategorien_pkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_eintraege DROP CONSTRAINT IF EXISTS bestelllisten_eintraege_pkey;
ALTER TABLE IF EXISTS ONLY public.bestelllisten_artikel_kategorien DROP CONSTRAINT IF EXISTS bestelllisten_artikel_kategorien_pkey;
ALTER TABLE IF EXISTS ONLY public.benutzer_anlage_reihenfolge DROP CONSTRAINT IF EXISTS benutzer_anlage_reihenfolge_pkey;
ALTER TABLE IF EXISTS ONLY public.backup_schedule DROP CONSTRAINT IF EXISTS backup_schedule_pkey;
ALTER TABLE IF EXISTS ONLY public.auftraggeber DROP CONSTRAINT IF EXISTS auftraggeber_pkey;
ALTER TABLE IF EXISTS ONLY public.aufgaben DROP CONSTRAINT IF EXISTS aufgaben_pkey;
ALTER TABLE IF EXISTS ONLY public.anlagen DROP CONSTRAINT IF EXISTS anlagen_pkey;
ALTER TABLE IF EXISTS ONLY public.alarm_log DROP CONSTRAINT IF EXISTS alarm_log_pkey;
ALTER TABLE IF EXISTS ONLY public.alarm_bestaetigung DROP CONSTRAINT IF EXISTS alarm_bestaetigung_pkey;
ALTER TABLE IF EXISTS ONLY public.alarm_bestaetigung DROP CONSTRAINT IF EXISTS alarm_bestaetigung_alarm_id_mitarbeiter_id_key;
ALTER TABLE IF EXISTS public.zeiterfassung_freigabe ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.zeiterfassung ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.todos_privat ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.todos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.system_logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.push_subscriptions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.push_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.projekt_auftraege ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.nachrichten ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.mitarbeiter ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.gps_tracks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.fahrzeuge ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.erledigte_aufgaben ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.einsatz_fotos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.einsaetze ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bestelllisten_stammdaten ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bestelllisten_kategorien ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bestelllisten_eintraege ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bestelllisten_artikel_kategorien ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.backup_schedule ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.auftraggeber ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.aufgaben ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.anlagen ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.alarm_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.alarm_bestaetigung ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.zeiterfassung_id_seq;
DROP SEQUENCE IF EXISTS public.zeiterfassung_freigabe_id_seq;
DROP TABLE IF EXISTS public.zeiterfassung_freigabe;
DROP TABLE IF EXISTS public.zeiterfassung;
DROP SEQUENCE IF EXISTS public.todos_privat_id_seq;
DROP TABLE IF EXISTS public.todos_privat;
DROP SEQUENCE IF EXISTS public.todos_id_seq;
DROP TABLE IF EXISTS public.todos;
DROP TABLE IF EXISTS public.todo_zuweisungen;
DROP SEQUENCE IF EXISTS public.system_logs_id_seq;
DROP TABLE IF EXISTS public.system_logs;
DROP SEQUENCE IF EXISTS public.push_subscriptions_id_seq;
DROP TABLE IF EXISTS public.push_subscriptions;
DROP SEQUENCE IF EXISTS public.push_log_id_seq;
DROP TABLE IF EXISTS public.push_log;
DROP SEQUENCE IF EXISTS public.projekt_auftraege_id_seq;
DROP TABLE IF EXISTS public.projekt_auftraege;
DROP SEQUENCE IF EXISTS public.nachrichten_id_seq;
DROP TABLE IF EXISTS public.nachrichten;
DROP SEQUENCE IF EXISTS public.mitarbeiter_id_seq;
DROP TABLE IF EXISTS public.mitarbeiter;
DROP TABLE IF EXISTS public.ma_kosten_einstellungen;
DROP TABLE IF EXISTS public.kalender_settings;
DROP TABLE IF EXISTS public.kalender_events;
DROP SEQUENCE IF EXISTS public.gps_tracks_id_seq;
DROP TABLE IF EXISTS public.gps_tracks;
DROP TABLE IF EXISTS public.firma_einstellungen;
DROP TABLE IF EXISTS public.feiertage;
DROP SEQUENCE IF EXISTS public.fahrzeuge_id_seq;
DROP TABLE IF EXISTS public.fahrzeuge;
DROP TABLE IF EXISTS public.fahrzeug_einstellungen;
DROP SEQUENCE IF EXISTS public.erledigte_aufgaben_id_seq;
DROP TABLE IF EXISTS public.erledigte_aufgaben;
DROP SEQUENCE IF EXISTS public.einsatz_fotos_id_seq;
DROP TABLE IF EXISTS public.einsatz_fotos;
DROP SEQUENCE IF EXISTS public.einsaetze_id_seq;
DROP TABLE IF EXISTS public.einsaetze;
DROP SEQUENCE IF EXISTS public.bestelllisten_stammdaten_id_seq;
DROP TABLE IF EXISTS public.bestelllisten_stammdaten;
DROP SEQUENCE IF EXISTS public.bestelllisten_kategorien_id_seq;
DROP TABLE IF EXISTS public.bestelllisten_kategorien;
DROP SEQUENCE IF EXISTS public.bestelllisten_eintraege_id_seq;
DROP TABLE IF EXISTS public.bestelllisten_eintraege;
DROP SEQUENCE IF EXISTS public.bestelllisten_artikel_kategorien_id_seq;
DROP TABLE IF EXISTS public.bestelllisten_artikel_kategorien;
DROP TABLE IF EXISTS public.benutzer_anlage_reihenfolge;
DROP SEQUENCE IF EXISTS public.backup_schedule_id_seq;
DROP TABLE IF EXISTS public.backup_schedule;
DROP SEQUENCE IF EXISTS public.auftraggeber_id_seq;
DROP TABLE IF EXISTS public.auftraggeber;
DROP SEQUENCE IF EXISTS public.aufgaben_id_seq;
DROP TABLE IF EXISTS public.aufgaben;
DROP SEQUENCE IF EXISTS public.anlagen_id_seq;
DROP TABLE IF EXISTS public.anlagen;
DROP SEQUENCE IF EXISTS public.alarm_log_id_seq;
DROP TABLE IF EXISTS public.alarm_log;
DROP SEQUENCE IF EXISTS public.alarm_bestaetigung_id_seq;
DROP TABLE IF EXISTS public.alarm_bestaetigung;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alarm_bestaetigung; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.alarm_bestaetigung (
    id integer NOT NULL,
    alarm_id integer,
    mitarbeiter_id integer,
    mitarbeiter_name character varying(200),
    bestaetigt_am timestamp with time zone DEFAULT now()
);


ALTER TABLE public.alarm_bestaetigung OWNER TO solano;

--
-- Name: alarm_bestaetigung_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.alarm_bestaetigung_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alarm_bestaetigung_id_seq OWNER TO solano;

--
-- Name: alarm_bestaetigung_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.alarm_bestaetigung_id_seq OWNED BY public.alarm_bestaetigung.id;


--
-- Name: alarm_log; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.alarm_log (
    id integer NOT NULL,
    gesendet_von character varying(200),
    gesendet_am timestamp with time zone DEFAULT now(),
    empfaenger_count integer DEFAULT 0
);


ALTER TABLE public.alarm_log OWNER TO solano;

--
-- Name: alarm_log_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.alarm_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alarm_log_id_seq OWNER TO solano;

--
-- Name: alarm_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.alarm_log_id_seq OWNED BY public.alarm_log.id;


--
-- Name: anlagen; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.anlagen (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    adresse character varying(300) NOT NULL,
    plz character varying(10),
    ort character varying(100),
    lat numeric(10,8),
    lng numeric(11,8),
    info_text text,
    bild_url character varying(500),
    aktiv boolean DEFAULT true,
    erstellt_am timestamp without time zone DEFAULT now(),
    sparte character varying(50) DEFAULT 'winterdienst'::character varying,
    in_winterdienst boolean DEFAULT false,
    in_gebaeudereinigung boolean DEFAULT false,
    in_gruenpflege boolean DEFAULT false,
    bild_url_winter character varying(500),
    bild_url_gebaeudereinigung character varying(500),
    bild_url_gruenpflege character varying(500)
);


ALTER TABLE public.anlagen OWNER TO solano;

--
-- Name: anlagen_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.anlagen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.anlagen_id_seq OWNER TO solano;

--
-- Name: anlagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.anlagen_id_seq OWNED BY public.anlagen.id;


--
-- Name: aufgaben; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.aufgaben (
    id integer NOT NULL,
    anlage_id integer,
    bezeichnung character varying(200) NOT NULL,
    reihenfolge integer DEFAULT 0,
    sparte character varying(50) DEFAULT 'winterdienst'::character varying
);


ALTER TABLE public.aufgaben OWNER TO solano;

--
-- Name: aufgaben_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.aufgaben_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aufgaben_id_seq OWNER TO solano;

--
-- Name: aufgaben_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.aufgaben_id_seq OWNED BY public.aufgaben.id;


--
-- Name: auftraggeber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auftraggeber (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    gutschrift_prozent numeric(5,2) DEFAULT 0,
    stundensatz numeric(8,2) DEFAULT 0,
    aktiv boolean DEFAULT true,
    notiz text,
    erstellt_am timestamp with time zone DEFAULT now(),
    fahrzeit_bezahlt boolean DEFAULT true
);


ALTER TABLE public.auftraggeber OWNER TO postgres;

--
-- Name: auftraggeber_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auftraggeber_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auftraggeber_id_seq OWNER TO postgres;

--
-- Name: auftraggeber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auftraggeber_id_seq OWNED BY public.auftraggeber.id;


--
-- Name: backup_schedule; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.backup_schedule (
    id integer NOT NULL,
    aktiv boolean DEFAULT false,
    wochentage jsonb DEFAULT '[]'::jsonb,
    uhrzeit character varying(5) DEFAULT '02:00'::character varying,
    letzte_ausfuehrung timestamp without time zone,
    updated_at timestamp without time zone DEFAULT now(),
    voll_wochentage jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.backup_schedule OWNER TO solano;

--
-- Name: backup_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.backup_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.backup_schedule_id_seq OWNER TO solano;

--
-- Name: backup_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.backup_schedule_id_seq OWNED BY public.backup_schedule.id;


--
-- Name: benutzer_anlage_reihenfolge; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.benutzer_anlage_reihenfolge (
    mitarbeiter_id integer NOT NULL,
    anlage_id integer NOT NULL,
    sparte character varying(50) NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.benutzer_anlage_reihenfolge OWNER TO solano;

--
-- Name: bestelllisten_artikel_kategorien; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.bestelllisten_artikel_kategorien (
    id integer NOT NULL,
    name text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    aktiv boolean DEFAULT true NOT NULL
);


ALTER TABLE public.bestelllisten_artikel_kategorien OWNER TO solano;

--
-- Name: bestelllisten_artikel_kategorien_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.bestelllisten_artikel_kategorien_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bestelllisten_artikel_kategorien_id_seq OWNER TO solano;

--
-- Name: bestelllisten_artikel_kategorien_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.bestelllisten_artikel_kategorien_id_seq OWNED BY public.bestelllisten_artikel_kategorien.id;


--
-- Name: bestelllisten_eintraege; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.bestelllisten_eintraege (
    id integer NOT NULL,
    kategorie_id integer,
    bezeichnung text NOT NULL,
    menge text,
    einheit text,
    lieferant text,
    stammdaten_id integer,
    erstellt_von integer,
    erstellt_am timestamp with time zone DEFAULT now() NOT NULL,
    bestellt boolean DEFAULT false NOT NULL,
    bestellt_von integer,
    bestellt_am timestamp with time zone,
    bestell_gruppe text,
    ziel text DEFAULT 'lager'::text,
    fahrzeug_id integer
);


ALTER TABLE public.bestelllisten_eintraege OWNER TO solano;

--
-- Name: bestelllisten_eintraege_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.bestelllisten_eintraege_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bestelllisten_eintraege_id_seq OWNER TO solano;

--
-- Name: bestelllisten_eintraege_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.bestelllisten_eintraege_id_seq OWNED BY public.bestelllisten_eintraege.id;


--
-- Name: bestelllisten_kategorien; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.bestelllisten_kategorien (
    id integer NOT NULL,
    name text NOT NULL,
    icon text DEFAULT '📦'::text NOT NULL,
    farbe text DEFAULT '#6366f1'::text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    aktiv boolean DEFAULT true NOT NULL
);


ALTER TABLE public.bestelllisten_kategorien OWNER TO solano;

--
-- Name: bestelllisten_kategorien_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.bestelllisten_kategorien_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bestelllisten_kategorien_id_seq OWNER TO solano;

--
-- Name: bestelllisten_kategorien_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.bestelllisten_kategorien_id_seq OWNED BY public.bestelllisten_kategorien.id;


--
-- Name: bestelllisten_stammdaten; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.bestelllisten_stammdaten (
    id integer NOT NULL,
    name text NOT NULL,
    kategorie_id integer,
    lieferant text,
    einheit text,
    aktiv boolean DEFAULT true NOT NULL,
    artikel_kategorie_id integer,
    preis_netto numeric(10,2),
    preis_brutto numeric(10,2),
    scancode text,
    sparte_winterdienst boolean DEFAULT false,
    sparte_gebaeudereinigung boolean DEFAULT false,
    sparte_gruenpflege boolean DEFAULT false,
    sparte_projekte boolean DEFAULT false,
    benoetigt_pruefung boolean DEFAULT false,
    erstellt_von integer
);


ALTER TABLE public.bestelllisten_stammdaten OWNER TO solano;

--
-- Name: bestelllisten_stammdaten_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.bestelllisten_stammdaten_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bestelllisten_stammdaten_id_seq OWNER TO solano;

--
-- Name: bestelllisten_stammdaten_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.bestelllisten_stammdaten_id_seq OWNED BY public.bestelllisten_stammdaten.id;


--
-- Name: einsaetze; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.einsaetze (
    id integer NOT NULL,
    anlage_id integer,
    mitarbeiter character varying(100),
    datum date NOT NULL,
    start_zeit timestamp without time zone,
    end_zeit timestamp without time zone,
    notiz text,
    erstellt_am timestamp without time zone DEFAULT now(),
    mitarbeiter_id integer,
    sparte character varying(50),
    gps_check_ok boolean
);


ALTER TABLE public.einsaetze OWNER TO solano;

--
-- Name: einsaetze_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.einsaetze_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.einsaetze_id_seq OWNER TO solano;

--
-- Name: einsaetze_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.einsaetze_id_seq OWNED BY public.einsaetze.id;


--
-- Name: einsatz_fotos; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.einsatz_fotos (
    id integer NOT NULL,
    einsatz_id integer,
    foto_url character varying(500) NOT NULL,
    beschreibung text,
    hochgeladen_am timestamp without time zone DEFAULT now()
);


ALTER TABLE public.einsatz_fotos OWNER TO solano;

--
-- Name: einsatz_fotos_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.einsatz_fotos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.einsatz_fotos_id_seq OWNER TO solano;

--
-- Name: einsatz_fotos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.einsatz_fotos_id_seq OWNED BY public.einsatz_fotos.id;


--
-- Name: erledigte_aufgaben; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.erledigte_aufgaben (
    id integer NOT NULL,
    einsatz_id integer,
    aufgabe_id integer,
    erledigt_um timestamp without time zone DEFAULT now()
);


ALTER TABLE public.erledigte_aufgaben OWNER TO solano;

--
-- Name: erledigte_aufgaben_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.erledigte_aufgaben_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.erledigte_aufgaben_id_seq OWNER TO solano;

--
-- Name: erledigte_aufgaben_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.erledigte_aufgaben_id_seq OWNED BY public.erledigte_aufgaben.id;


--
-- Name: fahrzeug_einstellungen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fahrzeug_einstellungen (
    id integer DEFAULT 1 NOT NULL,
    diesel_preis numeric(6,3) DEFAULT 1.80,
    verbrauch_100km numeric(5,2) DEFAULT 8.0,
    maut_pro_km numeric(6,4) DEFAULT 0.0,
    abnuetzung_pro_km numeric(6,4) DEFAULT 0.15,
    aktualisiert_am timestamp with time zone DEFAULT now(),
    CONSTRAINT single_row CHECK ((id = 1))
);


ALTER TABLE public.fahrzeug_einstellungen OWNER TO postgres;

--
-- Name: fahrzeuge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fahrzeuge (
    id integer NOT NULL,
    kennzeichen text NOT NULL,
    bezeichnung text,
    aktiv boolean DEFAULT true,
    erstellt_am timestamp without time zone DEFAULT now()
);


ALTER TABLE public.fahrzeuge OWNER TO postgres;

--
-- Name: fahrzeuge_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fahrzeuge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fahrzeuge_id_seq OWNER TO postgres;

--
-- Name: fahrzeuge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fahrzeuge_id_seq OWNED BY public.fahrzeuge.id;


--
-- Name: feiertage; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.feiertage (
    datum date NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.feiertage OWNER TO solano;

--
-- Name: firma_einstellungen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.firma_einstellungen (
    id integer DEFAULT 1 NOT NULL,
    name character varying(200),
    anschrift text,
    uid_atu character varying(50),
    logo_base64 text,
    CONSTRAINT singleton CHECK ((id = 1))
);


ALTER TABLE public.firma_einstellungen OWNER TO postgres;

--
-- Name: gps_tracks; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.gps_tracks (
    id integer NOT NULL,
    einsatz_id integer,
    lat numeric(10,8) NOT NULL,
    lng numeric(11,8) NOT NULL,
    zeitpunkt timestamp without time zone NOT NULL,
    genauigkeit numeric(8,2)
);


ALTER TABLE public.gps_tracks OWNER TO solano;

--
-- Name: gps_tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.gps_tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gps_tracks_id_seq OWNER TO solano;

--
-- Name: gps_tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.gps_tracks_id_seq OWNED BY public.gps_tracks.id;


--
-- Name: kalender_events; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.kalender_events (
    id character varying(200) NOT NULL,
    titel character varying(500),
    start_zeit timestamp with time zone,
    end_zeit timestamp with time zone,
    ort character varying(500),
    beschreibung text,
    organisator character varying(200),
    mitarbeiter_ids integer[],
    synced_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.kalender_events OWNER TO solano;

--
-- Name: kalender_settings; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.kalender_settings (
    id integer DEFAULT 1 NOT NULL,
    exchange_url character varying(500),
    exchange_user character varying(200),
    exchange_pass character varying(200),
    sync_intervall_min integer DEFAULT 15,
    letzter_sync timestamp with time zone
);


ALTER TABLE public.kalender_settings OWNER TO solano;

--
-- Name: ma_kosten_einstellungen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ma_kosten_einstellungen (
    id integer DEFAULT 1 NOT NULL,
    stundensatz_fa numeric(6,2) DEFAULT 55.00,
    stundensatz_ha numeric(6,2) DEFAULT 45.00,
    stundensatz_gf numeric(6,2) DEFAULT 35.00,
    warnschwelle numeric(6,2) DEFAULT 55.00,
    aktualisiert_am timestamp without time zone DEFAULT now(),
    CONSTRAINT ma_kosten_single_row CHECK ((id = 1))
);


ALTER TABLE public.ma_kosten_einstellungen OWNER TO postgres;

--
-- Name: mitarbeiter; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.mitarbeiter (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    pin character varying(10),
    aktiv boolean DEFAULT true,
    ist_admin boolean DEFAULT false,
    zeige_winterdienst boolean DEFAULT true,
    zeige_gebaeudereinigung boolean DEFAULT true,
    zeige_gruenpflege boolean DEFAULT true,
    ist_chef boolean DEFAULT false,
    winterdienst_alarm boolean DEFAULT false,
    soll_stunden numeric(4,2) DEFAULT 38.5,
    beschaeftigung character varying(20) DEFAULT 'vollzeit'::character varying,
    zeige_projekte boolean DEFAULT true,
    darf_nachrichten boolean DEFAULT false,
    nachricht_verfuegbar boolean DEFAULT true,
    sieht_aktive_einsaetze boolean DEFAULT false,
    sieht_einsatz_details boolean DEFAULT false,
    kann_einsteigen boolean DEFAULT false,
    darf_bestellen boolean DEFAULT false,
    darf_export boolean DEFAULT false,
    darf_artikelanlage boolean DEFAULT false
);


ALTER TABLE public.mitarbeiter OWNER TO solano;

--
-- Name: mitarbeiter_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.mitarbeiter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mitarbeiter_id_seq OWNER TO solano;

--
-- Name: mitarbeiter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.mitarbeiter_id_seq OWNED BY public.mitarbeiter.id;


--
-- Name: nachrichten; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.nachrichten (
    id integer NOT NULL,
    von_id integer,
    von_name character varying(200),
    an_id integer,
    an_name character varying(200),
    text text NOT NULL,
    gesendet_am timestamp with time zone DEFAULT now(),
    antwort character varying(10),
    antwort_am timestamp with time zone,
    gelesen boolean DEFAULT false,
    ist_arbeitsanweisung boolean DEFAULT false
);


ALTER TABLE public.nachrichten OWNER TO solano;

--
-- Name: nachrichten_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.nachrichten_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nachrichten_id_seq OWNER TO solano;

--
-- Name: nachrichten_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.nachrichten_id_seq OWNED BY public.nachrichten.id;


--
-- Name: projekt_auftraege; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projekt_auftraege (
    id integer NOT NULL,
    auftraggeber_id integer,
    auftraggeber_name character varying(200),
    auftragsnummer character varying(100),
    mitarbeiter_id integer,
    mitarbeiter_name character varying(200),
    anzahl_mitarbeiter integer DEFAULT 2,
    fahrt_start timestamp with time zone,
    ankunft timestamp with time zone,
    abfahrt_zeit timestamp with time zone,
    fahrt_ende timestamp with time zone,
    fahrzeit_hin_min integer DEFAULT 0,
    arbeitszeit_min integer DEFAULT 0,
    fahrzeit_zurueck_min integer DEFAULT 0,
    km_hin numeric(8,2) DEFAULT 0,
    km_zurueck numeric(8,2) DEFAULT 0,
    gps_punkte jsonb DEFAULT '[]'::jsonb,
    notiz text,
    besonderheiten text,
    status character varying(20) DEFAULT 'fahrt'::character varying,
    montagewert_netto numeric(10,2),
    gutschrift_betrag numeric(10,2),
    gutschrift_datum date,
    gutschrift_nummer character varying(100),
    erstellt_am timestamp with time zone DEFAULT now(),
    abgeschlossen_am timestamp with time zone,
    arbeitszeit_manuell_min integer DEFAULT 0,
    sessions jsonb DEFAULT '[]'::jsonb,
    kundenname character varying(200),
    adresse text,
    tour_id character varying(50),
    tour_position integer DEFAULT 1,
    naechster_auftrag_id integer,
    km_verbindung numeric(8,2) DEFAULT 0,
    rapport_erforderlich boolean DEFAULT false,
    rapport_beschreibung text,
    geplant_datum date,
    adresse_strasse character varying(200),
    adresse_plz character varying(20),
    adresse_land character varying(100) DEFAULT 'Österreich'::character varying,
    sort_order integer DEFAULT 0,
    ma_typen jsonb DEFAULT '[]'::jsonb,
    adresse_ort character varying(100),
    fahrtkosten_pauschale numeric(8,2) DEFAULT 0,
    geplant_uhrzeit time without time zone,
    geplant_dauer_min integer DEFAULT 120,
    sonderverguetung numeric(10,2) DEFAULT 0,
    rapport_betrag numeric(10,2) DEFAULT 0,
    erneuter_einsatz_noetig boolean DEFAULT false,
    erneuter_einsatz_datum date,
    einsatz_history jsonb DEFAULT '[]'::jsonb,
    fz_diesel_preis numeric,
    fz_verbrauch_100km numeric,
    fz_maut_pro_km numeric,
    fz_abnuetzung_pro_km numeric,
    ma_stundensatz_fa numeric,
    ma_stundensatz_ha numeric,
    ma_stundensatz_gf numeric,
    ma_warnschwelle numeric,
    telefon character varying(50),
    email character varying(200),
    ist_aufmass boolean DEFAULT false,
    auftragstyp character varying(20) DEFAULT 'montage'::character varying
);


ALTER TABLE public.projekt_auftraege OWNER TO postgres;

--
-- Name: projekt_auftraege_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projekt_auftraege_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projekt_auftraege_id_seq OWNER TO postgres;

--
-- Name: projekt_auftraege_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projekt_auftraege_id_seq OWNED BY public.projekt_auftraege.id;


--
-- Name: push_log; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.push_log (
    id integer NOT NULL,
    gesendet_am timestamp without time zone DEFAULT now(),
    gesendet_von character varying(100),
    empfaenger text,
    nachricht text NOT NULL,
    erfolg integer DEFAULT 0,
    fehler integer DEFAULT 0
);


ALTER TABLE public.push_log OWNER TO solano;

--
-- Name: push_log_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.push_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.push_log_id_seq OWNER TO solano;

--
-- Name: push_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.push_log_id_seq OWNED BY public.push_log.id;


--
-- Name: push_subscriptions; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.push_subscriptions (
    id integer NOT NULL,
    mitarbeiter_id integer,
    mitarbeiter_name character varying(100),
    subscription_json text NOT NULL,
    erstellt_am timestamp without time zone DEFAULT now()
);


ALTER TABLE public.push_subscriptions OWNER TO solano;

--
-- Name: push_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.push_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.push_subscriptions_id_seq OWNER TO solano;

--
-- Name: push_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.push_subscriptions_id_seq OWNED BY public.push_subscriptions.id;


--
-- Name: system_logs; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.system_logs (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    level character varying(10) DEFAULT 'info'::character varying,
    aktion character varying(200),
    ausgeloest_von character varying(200),
    details jsonb,
    ip character varying(60)
);


ALTER TABLE public.system_logs OWNER TO solano;

--
-- Name: system_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.system_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_logs_id_seq OWNER TO solano;

--
-- Name: system_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.system_logs_id_seq OWNED BY public.system_logs.id;


--
-- Name: todo_zuweisungen; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.todo_zuweisungen (
    todo_id integer NOT NULL,
    mitarbeiter_id integer NOT NULL,
    mitarbeiter_name character varying(100)
);


ALTER TABLE public.todo_zuweisungen OWNER TO solano;

--
-- Name: todos; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.todos (
    id integer NOT NULL,
    anlage_id integer,
    einsatz_id integer,
    mitarbeiter character varying(200),
    mitarbeiter_id integer,
    beschreibung text NOT NULL,
    erledigt boolean DEFAULT false,
    erstellt_am timestamp with time zone DEFAULT now(),
    erledigt_am timestamp with time zone,
    erledigt_von character varying(200),
    zugewiesen_an_id integer,
    zugewiesen_an character varying(100)
);


ALTER TABLE public.todos OWNER TO solano;

--
-- Name: todos_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.todos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.todos_id_seq OWNER TO solano;

--
-- Name: todos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.todos_id_seq OWNED BY public.todos.id;


--
-- Name: todos_privat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.todos_privat (
    id integer NOT NULL,
    mitarbeiter_id integer,
    beschreibung text NOT NULL,
    erledigt boolean DEFAULT false,
    erstellt_am timestamp with time zone DEFAULT now(),
    erledigt_am timestamp with time zone
);


ALTER TABLE public.todos_privat OWNER TO postgres;

--
-- Name: todos_privat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.todos_privat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.todos_privat_id_seq OWNER TO postgres;

--
-- Name: todos_privat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.todos_privat_id_seq OWNED BY public.todos_privat.id;


--
-- Name: zeiterfassung; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.zeiterfassung (
    id integer NOT NULL,
    mitarbeiter_id integer,
    mitarbeiter_name character varying(200),
    typ character varying(20) NOT NULL,
    zeitpunkt timestamp with time zone DEFAULT now(),
    datum date DEFAULT CURRENT_DATE,
    notiz text,
    geaendert_von_id integer,
    geaendert_von_name character varying(200),
    geaendert_am timestamp with time zone,
    original_zeitpunkt timestamp with time zone
);


ALTER TABLE public.zeiterfassung OWNER TO solano;

--
-- Name: zeiterfassung_freigabe; Type: TABLE; Schema: public; Owner: solano
--

CREATE TABLE public.zeiterfassung_freigabe (
    id integer NOT NULL,
    mitarbeiter_id integer,
    mitarbeiter_name character varying(200),
    monat date NOT NULL,
    freigegeben_von_id integer,
    freigegeben_von_name character varying(200),
    freigegeben_am timestamp with time zone DEFAULT now(),
    notiz text
);


ALTER TABLE public.zeiterfassung_freigabe OWNER TO solano;

--
-- Name: zeiterfassung_freigabe_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.zeiterfassung_freigabe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zeiterfassung_freigabe_id_seq OWNER TO solano;

--
-- Name: zeiterfassung_freigabe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.zeiterfassung_freigabe_id_seq OWNED BY public.zeiterfassung_freigabe.id;


--
-- Name: zeiterfassung_id_seq; Type: SEQUENCE; Schema: public; Owner: solano
--

CREATE SEQUENCE public.zeiterfassung_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zeiterfassung_id_seq OWNER TO solano;

--
-- Name: zeiterfassung_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: solano
--

ALTER SEQUENCE public.zeiterfassung_id_seq OWNED BY public.zeiterfassung.id;


--
-- Name: alarm_bestaetigung id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.alarm_bestaetigung ALTER COLUMN id SET DEFAULT nextval('public.alarm_bestaetigung_id_seq'::regclass);


--
-- Name: alarm_log id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.alarm_log ALTER COLUMN id SET DEFAULT nextval('public.alarm_log_id_seq'::regclass);


--
-- Name: anlagen id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.anlagen ALTER COLUMN id SET DEFAULT nextval('public.anlagen_id_seq'::regclass);


--
-- Name: aufgaben id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.aufgaben ALTER COLUMN id SET DEFAULT nextval('public.aufgaben_id_seq'::regclass);


--
-- Name: auftraggeber id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auftraggeber ALTER COLUMN id SET DEFAULT nextval('public.auftraggeber_id_seq'::regclass);


--
-- Name: backup_schedule id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.backup_schedule ALTER COLUMN id SET DEFAULT nextval('public.backup_schedule_id_seq'::regclass);


--
-- Name: bestelllisten_artikel_kategorien id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_artikel_kategorien ALTER COLUMN id SET DEFAULT nextval('public.bestelllisten_artikel_kategorien_id_seq'::regclass);


--
-- Name: bestelllisten_eintraege id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_eintraege ALTER COLUMN id SET DEFAULT nextval('public.bestelllisten_eintraege_id_seq'::regclass);


--
-- Name: bestelllisten_kategorien id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_kategorien ALTER COLUMN id SET DEFAULT nextval('public.bestelllisten_kategorien_id_seq'::regclass);


--
-- Name: bestelllisten_stammdaten id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_stammdaten ALTER COLUMN id SET DEFAULT nextval('public.bestelllisten_stammdaten_id_seq'::regclass);


--
-- Name: einsaetze id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.einsaetze ALTER COLUMN id SET DEFAULT nextval('public.einsaetze_id_seq'::regclass);


--
-- Name: einsatz_fotos id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.einsatz_fotos ALTER COLUMN id SET DEFAULT nextval('public.einsatz_fotos_id_seq'::regclass);


--
-- Name: erledigte_aufgaben id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.erledigte_aufgaben ALTER COLUMN id SET DEFAULT nextval('public.erledigte_aufgaben_id_seq'::regclass);


--
-- Name: fahrzeuge id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fahrzeuge ALTER COLUMN id SET DEFAULT nextval('public.fahrzeuge_id_seq'::regclass);


--
-- Name: gps_tracks id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.gps_tracks ALTER COLUMN id SET DEFAULT nextval('public.gps_tracks_id_seq'::regclass);


--
-- Name: mitarbeiter id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.mitarbeiter ALTER COLUMN id SET DEFAULT nextval('public.mitarbeiter_id_seq'::regclass);


--
-- Name: nachrichten id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.nachrichten ALTER COLUMN id SET DEFAULT nextval('public.nachrichten_id_seq'::regclass);


--
-- Name: projekt_auftraege id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projekt_auftraege ALTER COLUMN id SET DEFAULT nextval('public.projekt_auftraege_id_seq'::regclass);


--
-- Name: push_log id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.push_log ALTER COLUMN id SET DEFAULT nextval('public.push_log_id_seq'::regclass);


--
-- Name: push_subscriptions id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.push_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.push_subscriptions_id_seq'::regclass);


--
-- Name: system_logs id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.system_logs ALTER COLUMN id SET DEFAULT nextval('public.system_logs_id_seq'::regclass);


--
-- Name: todos id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.todos ALTER COLUMN id SET DEFAULT nextval('public.todos_id_seq'::regclass);


--
-- Name: todos_privat id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todos_privat ALTER COLUMN id SET DEFAULT nextval('public.todos_privat_id_seq'::regclass);


--
-- Name: zeiterfassung id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.zeiterfassung ALTER COLUMN id SET DEFAULT nextval('public.zeiterfassung_id_seq'::regclass);


--
-- Name: zeiterfassung_freigabe id; Type: DEFAULT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.zeiterfassung_freigabe ALTER COLUMN id SET DEFAULT nextval('public.zeiterfassung_freigabe_id_seq'::regclass);


--
-- Data for Name: alarm_bestaetigung; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.alarm_bestaetigung (id, alarm_id, mitarbeiter_id, mitarbeiter_name, bestaetigt_am) FROM stdin;
\.


--
-- Data for Name: alarm_log; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.alarm_log (id, gesendet_von, gesendet_am, empfaenger_count) FROM stdin;
\.


--
-- Data for Name: anlagen; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.anlagen (id, name, adresse, plz, ort, lat, lng, info_text, bild_url, aktiv, erstellt_am, sparte, in_winterdienst, in_gebaeudereinigung, in_gruenpflege, bild_url_winter, bild_url_gebaeudereinigung, bild_url_gruenpflege) FROM stdin;
5	test	mühlwasen 89	6972	fußach	\N	\N	sdsfsghfjkrtgrtf	\N	f	2026-03-13 17:32:54.438187	winterdienst	t	t	f	\N	\N	\N
12	Testanlage 721589	teststraße 1	6973	Höchst	47.46861621	9.62534830	\N	\N	f	2026-03-16 10:26:29.249537	winterdienst	t	f	f	\N	\N	\N
4	wtdgadfsyh	sdfgdfsgdfg	987654	zutuzr	\N	\N	dhsfghdy	\N	f	2026-03-12 08:03:41.452694	winterdienst	t	f	f	\N	\N	\N
11	Test	Teststraße 1	6973	Höchst	\N	\N	\N	\N	f	2026-03-16 10:25:26.126691	winterdienst	t	f	f	\N	\N	\N
1	Testanlage Muster	Musterstraße 1	6800	Feldkirch	47.23720000	9.59660000	Einfahrt von Norden. Salzkiste neben Eingang.	\N	f	2026-03-12 06:18:44.452079	winterdienst	t	f	f	\N	\N	\N
15	WEG Kirchplatz 1	Kirchplatz 1	6973	Höchst	47.45916578	9.63930753	\N	\N	t	2026-03-16 10:34:59.131804	winterdienst	f	t	f	\N	\N	\N
18	WEG Bruggerstrasse 30a	Bruggerstrasse 30a	6973	Höchst	47.45633224	9.65084105	\N	\N	t	2026-03-16 10:38:24.077717	winterdienst	f	t	f	\N	\N	\N
6	test blabla	fangstraße 31	6973	Höchst	\N	\N	Schwieriger Bewohner in Top 7!	\N	f	2026-03-13 17:49:55.444615	winterdienst	t	t	f	\N	\N	\N
9	Test Calvin	Rauhholzstraße 8	6971	Hard	\N	\N	\N	\N	f	2026-03-14 11:52:40.051216	winterdienst	t	t	t	\N	\N	\N
8	test neu neu neu	fangstraße 31	6973	Höchst	\N	\N	\N	\N	f	2026-03-14 08:56:12.293436	winterdienst	t	t	f	\N	\N	\N
3	Bahnhof Lustenau	augartenstraße 46	6890	Lustenau	47.44284700	9.65486700	\N	\N	f	2026-03-12 07:49:23.536223	winterdienst	t	t	t	\N	\N	\N
2	Beispiel Wohnpark Solano	Fangstraße 31	6973	Höchst	47.46863664	9.62539874	\N	\N	f	2026-03-12 06:18:44.452079	winterdienst	t	t	t	\N	\N	\N
10	Bruggerstraße 30	Bruggerstraße 30	6890	Lustenau	\N	\N	\N	\N	f	2026-03-14 12:05:48.955145	winterdienst	t	f	t	/uploads/anlage_1773488316418.png	\N	/uploads/anlage_1773486348973.png
7	Test steffi	Mühlwasen 88	6972	Fussach	\N	\N	Nervige alte in top 7!	\N	f	2026-03-13 19:30:52.854866	winterdienst	t	t	f	\N	\N	\N
17	WEG Fischergasse 19	Fischergasse 19	6973	Höchst	47.46168657	9.62763136	\N	\N	t	2026-03-16 10:37:12.928628	winterdienst	f	t	f	\N	/uploads/anlage_1773912960490.jpeg	\N
19	Test Zuhause	Mühlwasen 90	6972	Fußach	47.46815793	9.65920085	\N	\N	f	2026-03-16 18:24:49.763376	winterdienst	t	t	f	\N	\N	\N
16	WEG Frühlingstrasse 7	Frühlingstrasse 7	6973	Höchst	47.46304424	9.62616011	\N	\N	t	2026-03-16 10:35:57.242914	winterdienst	f	t	f	\N	/uploads/anlage_1773913917494.jpg	\N
14	WEG Lettenstrasse 10b	Lettenstrasse 10b	6973	Höchst	47.47149564	9.62298169	Schlüsselkasten Tiefgarage: 0890	\N	t	2026-03-16 10:32:20.240905	winterdienst	f	t	f	\N	/uploads/anlage_1773915709922.jpg	\N
21	Anlage 2	teststraße 1	6973	Höchst	\N	\N	\N	\N	t	2026-03-17 04:45:00.746587	winterdienst	t	t	t	\N	\N	\N
13	WEG Zollweg 7	Zollweg 7	6973	Höchst	47.46085145	9.64298200	\N	\N	t	2026-03-16 10:30:04.493343	winterdienst	f	t	t	\N	/uploads/anlage_1773907732848.jpeg	/uploads/anlage_1773658922884.png
20	Anlage 1	test	6973	höchst	\N	\N	\N	\N	t	2026-03-17 04:44:27.452954	winterdienst	t	t	t	\N	\N	\N
\.


--
-- Data for Name: aufgaben; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.aufgaben (id, anlage_id, bezeichnung, reihenfolge, sparte) FROM stdin;
1	1	Einfahrt räumen	1	winterdienst
2	1	Gehwege streuen	2	winterdienst
3	1	Parkplatz räumen	3	winterdienst
4	2	Haupteingang freimachen	1	winterdienst
5	2	Parkplatz räumen	2	winterdienst
6	2	Nebeneingang kontrollieren	3	winterdienst
7	3	Gehwege geräumt?	0	winterdienst
8	3	Gehwege gesalzen?	0	winterdienst
9	3	Parkplätze geräumt?	0	winterdienst
10	3	Parkplätze gesalzen?	0	winterdienst
11	4	rhfhtsztzh	0	winterdienst
12	4	trszsrtz	0	winterdienst
13	5	dfdf	0	winterdienst
14	5	dfdf	0	winterdienst
17	5	ghjklö	0	gebaeudereinigung
18	5	ghjklö	0	gebaeudereinigung
19	6	Gehsteige	0	winterdienst
20	6	Handläufe	0	gebaeudereinigung
21	7	Gehsteig Salzen	0	winterdienst
22	8	Salzen 1	0	winterdienst
23	8	Salzen 2	0	winterdienst
24	8	Salzen 3	0	winterdienst
25	8	Salzen 4	0	winterdienst
26	8	Salzen 5	0	winterdienst
27	8	Reini 1	0	gebaeudereinigung
28	8	Reini 2	0	gebaeudereinigung
29	8	Reini 3	0	gebaeudereinigung
30	8	Reini 4	0	gebaeudereinigung
31	8	Reini 5	0	gebaeudereinigung
32	9	Gehsteige	0	winterdienst
33	9	Parkplätze	0	winterdienst
34	9	Handläufe	0	gebaeudereinigung
35	9	Böden	0	gebaeudereinigung
36	9	Lift	0	gebaeudereinigung
37	9	Rasen	0	gruenpflege
38	9	Sträucher	0	gruenpflege
39	10	Rasenschnitt	0	gruenpflege
40	10	Trimmern	0	gruenpflege
41	10	Grünschnitt mitnehmen	0	gruenpflege
42	10	Parkplätze Laubblasen	0	gruenpflege
43	3	dsfdfssgsgh	0	winterdienst
44	3	dfgsdghdhs	0	winterdienst
45	3	dgsdeehhgshdghfhfgsh	0	winterdienst
46	3	Rasen mähen	0	gruenpflege
47	3	trimmer	0	gruenpflege
48	3	laubsaugen	0	gruenpflege
71	19	fsfdffDF	0	winterdienst
72	19	cdfghjgrfesa	0	gebaeudereinigung
77	21	Gehsteig	0	winterdienst
78	21	Gehsteig	0	gebaeudereinigung
79	20	Gehsteig	0	winterdienst
80	17	Stiegenhaus saugen und wischen	0	gebaeudereinigung
83	21	dsfsdf	0	winterdienst
84	21	sdfsdf	0	gebaeudereinigung
85	21	sfsdf	0	gruenpflege
49	2	Blablabla	0	gruenpflege
50	2	Blabliblupp	0	gruenpflege
51	2	blablabla	0	gebaeudereinigung
52	2	blabliblipp	0	gebaeudereinigung
53	13	Stiegenhaus saugen	0	gebaeudereinigung
54	13	Eingangsbereich Scheiben und Briefkästen reinigen	0	gebaeudereinigung
55	13	Heizung, Salzanlage sichten	0	gebaeudereinigung
56	13	Rasen mähen	0	gruenpflege
57	14	Steigenhaus saugen und wischen	0	gebaeudereinigung
58	14	Eingangsbereich Fenster und Briefkästen reinigen	0	gebaeudereinigung
59	14	Heizung, Salzanlage sichten	0	gebaeudereinigung
60	15	Steigenhaus saugen und wischen	0	gebaeudereinigung
61	15	Eingangsbereich Fenster und Briefkästen reinigen	0	gebaeudereinigung
62	16	Stiegenhaus saugen	0	gebaeudereinigung
63	16	Keller saugen und wischen	0	gebaeudereinigung
64	16	Eingangsbereich Fenster und Briefkästen reinigen	0	gebaeudereinigung
66	17	Eingangsbereich Fenster und Briefkästen reinigen	0	gebaeudereinigung
67	18	Steigenhaus saugen und wischen	0	gebaeudereinigung
68	18	Eingangsbereich Fenster und Briefkästen reinigen	0	gebaeudereinigung
69	18	Heizung, Salzanlage sichten	0	gebaeudereinigung
70	13	Trimmern	0	gruenpflege
73	20	Gehsteig salzen	0	winterdienst
74	20	Gehsteig	0	gebaeudereinigung
75	20	Gehsteig	0	gruenpflege
76	20	Trimmern	0	gruenpflege
81	21	aufgabe 1	0	gruenpflege
82	21	aufgabe 2	0	gruenpflege
86	20	sadas	0	gebaeudereinigung
87	20	dfsddff	0	gebaeudereinigung
\.


--
-- Data for Name: auftraggeber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auftraggeber (id, name, gutschrift_prozent, stundensatz, aktiv, notiz, erstellt_am, fahrzeit_bezahlt) FROM stdin;
4	test	0.00	0.00	f	wichser	2026-03-17 08:53:26.755896+00	t
1	Heim & Haus	0.00	0.00	t	\N	2026-03-17 06:24:14.289051+00	f
2	Hornbach	0.00	0.00	t	\N	2026-03-17 06:24:14.289051+00	f
5	Privis	0.00	0.00	t	\N	2026-03-17 09:53:01.795195+00	f
3	Blank	0.00	120.00	t	\N	2026-03-17 06:24:14.289051+00	t
\.


--
-- Data for Name: backup_schedule; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.backup_schedule (id, aktiv, wochentage, uhrzeit, letzte_ausfuehrung, updated_at, voll_wochentage) FROM stdin;
1	t	["0", "1", "2", "3", "4", "5", "6"]	02:00	2026-03-24 01:00:00.302736	2026-03-23 09:46:16.604816	["0"]
\.


--
-- Data for Name: benutzer_anlage_reihenfolge; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.benutzer_anlage_reihenfolge (mitarbeiter_id, anlage_id, sparte, "position") FROM stdin;
2	10	winterdienst	0
2	5	winterdienst	1
2	2	winterdienst	2
2	3	winterdienst	3
2	6	winterdienst	4
2	9	winterdienst	5
2	8	winterdienst	6
2	7	winterdienst	7
2	1	winterdienst	8
2	4	winterdienst	9
2	10	gruenpflege	0
2	3	gruenpflege	1
2	9	gruenpflege	2
2	2	gruenpflege	3
3	13	gruenpflege	0
3	3	gruenpflege	1
3	2	gruenpflege	2
3	10	gruenpflege	3
3	9	gruenpflege	4
9	18	gebaeudereinigung	0
9	14	gebaeudereinigung	1
9	17	gebaeudereinigung	2
9	15	gebaeudereinigung	3
9	13	gebaeudereinigung	4
9	16	gebaeudereinigung	5
8	19	gebaeudereinigung	0
8	17	gebaeudereinigung	1
8	18	gebaeudereinigung	2
8	16	gebaeudereinigung	3
8	15	gebaeudereinigung	4
8	14	gebaeudereinigung	5
8	13	gebaeudereinigung	6
1	21	winterdienst	0
1	20	winterdienst	1
10	18	gebaeudereinigung	0
10	15	gebaeudereinigung	1
10	17	gebaeudereinigung	2
10	14	gebaeudereinigung	3
1	20	gebaeudereinigung	0
1	21	gebaeudereinigung	1
1	18	gebaeudereinigung	2
1	17	gebaeudereinigung	3
1	16	gebaeudereinigung	4
1	15	gebaeudereinigung	5
1	14	gebaeudereinigung	6
1	13	gebaeudereinigung	7
10	13	gebaeudereinigung	4
10	16	gebaeudereinigung	5
10	20	gebaeudereinigung	6
10	21	gebaeudereinigung	7
\.


--
-- Data for Name: bestelllisten_artikel_kategorien; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.bestelllisten_artikel_kategorien (id, name, sort_order, aktiv) FROM stdin;
1	Reinigungsmittel	1	t
2	Montagematerial	2	t
3	Schrauben & Befestigung	3	t
4	Kleber & Dichtstoffe	4	t
5	Salz & Streumittel	5	t
6	Ersatzteile	6	t
7	Sonstiges	99	t
\.


--
-- Data for Name: bestelllisten_eintraege; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.bestelllisten_eintraege (id, kategorie_id, bezeichnung, menge, einheit, lieferant, stammdaten_id, erstellt_von, erstellt_am, bestellt, bestellt_von, bestellt_am, bestell_gruppe, ziel, fahrzeug_id) FROM stdin;
\.


--
-- Data for Name: bestelllisten_kategorien; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.bestelllisten_kategorien (id, name, icon, farbe, sort_order, aktiv) FROM stdin;
3	Grünpflege	🌿	#16a34a	3	t
1	Gebäudereinigung	🧹	#0891b2	1	t
2	Winterdienst	❄️	#7c3aed	2	t
4	Projekte	🔨	#ea580c	4	t
\.


--
-- Data for Name: bestelllisten_stammdaten; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.bestelllisten_stammdaten (id, name, kategorie_id, lieferant, einheit, aktiv, artikel_kategorie_id, preis_netto, preis_brutto, scancode, sparte_winterdienst, sparte_gebaeudereinigung, sparte_gruenpflege, sparte_projekte, benoetigt_pruefung, erstellt_von) FROM stdin;
1	Red Bull	1	\N	\N	f	1	\N	\N	9100000043364	f	f	f	f	f	\N
2	Red Bull	\N	\N	\N	f	\N	\N	\N	9100000043364	f	f	f	f	f	\N
3	S-Budget	\N	\N	\N	f	1	\N	-0.35	9100000043364	f	t	t	f	f	\N
4	Isopropanol 1Liter	\N	Amazon	1 Liter	t	1	\N	\N	4250463117999	f	t	f	t	f	\N
5	Prosecco	\N	Spar	\N	t	7	1.89	\N	8006805152687	f	t	f	f	f	8
6	S-Budget Energy	\N	Spar	\N	t	7	0.21	\N	9100000043364	t	t	t	t	f	9
\.


--
-- Data for Name: einsaetze; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.einsaetze (id, anlage_id, mitarbeiter, datum, start_zeit, end_zeit, notiz, erstellt_am, mitarbeiter_id, sparte, gps_check_ok) FROM stdin;
6	18	Chiara	2026-03-19	2026-03-19 07:53:33.23863	2026-03-19 08:03:55.184189	\N	2026-03-19 07:53:33.23863	9	gebaeudereinigung	t
7	13	Stefano	2026-03-19	2026-03-19 08:08:48.112395	2026-03-19 08:43:50.146496	Auto-Abmeldung: Fahrt erkannt (>8 km/h)	2026-03-19 08:08:48.112395	3	gebaeudereinigung	t
8	15	Ferdi	2026-03-19	2026-03-19 08:46:57.93308	2026-03-19 09:26:16.26453	Auto-Abmeldung: Fahrt erkannt (>8 km/h)	2026-03-19 08:46:57.93308	10	gebaeudereinigung	t
11	17	Michi	2026-03-19	2026-03-19 09:45:08.753575	2026-03-19 09:45:15.914522	\N	2026-03-19 09:45:08.753575	8	gebaeudereinigung	t
12	16	Michi	2026-03-19	2026-03-19 09:52:08.303291	2026-03-19 10:17:09.146436	\N	2026-03-19 09:52:08.303291	8	gebaeudereinigung	t
21	14	Michi	2026-03-19	2026-03-19 11:32:32.590564	2026-03-19 11:32:41.441942	\N	2026-03-19 11:32:32.590564	8	gebaeudereinigung	\N
\.


--
-- Data for Name: einsatz_fotos; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.einsatz_fotos (id, einsatz_id, foto_url, beschreibung, hochgeladen_am) FROM stdin;
16	6	/uploads/foto_1773906835428_b9arle.jpeg	\N	2026-03-19 07:54:01.906039
\.


--
-- Data for Name: erledigte_aufgaben; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.erledigte_aufgaben (id, einsatz_id, aufgabe_id, erledigt_um) FROM stdin;
83	6	67	2026-03-19 07:53:35.470661
84	6	68	2026-03-19 07:53:36.13048
85	6	69	2026-03-19 07:53:36.711325
86	7	53	2026-03-19 08:28:58.281574
87	7	54	2026-03-19 08:28:58.771136
88	7	55	2026-03-19 08:28:59.304107
89	8	60	2026-03-19 08:47:06.143866
90	8	61	2026-03-19 08:47:06.598466
153	21	57	2026-03-19 11:32:34.552973
154	21	58	2026-03-19 11:32:34.923995
155	21	59	2026-03-19 11:32:35.568929
131	11	80	2026-03-19 09:45:10.226716
132	11	66	2026-03-19 09:45:11.024923
133	12	62	2026-03-19 09:52:11.096444
134	12	63	2026-03-19 09:52:11.834511
135	12	64	2026-03-19 09:52:12.246516
\.


--
-- Data for Name: fahrzeug_einstellungen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fahrzeug_einstellungen (id, diesel_preis, verbrauch_100km, maut_pro_km, abnuetzung_pro_km, aktualisiert_am) FROM stdin;
1	2.000	11.00	0.0000	0.2500	2026-03-23 07:29:22.133654+00
\.


--
-- Data for Name: fahrzeuge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fahrzeuge (id, kennzeichen, bezeichnung, aktiv, erstellt_am) FROM stdin;
1	bdfsr	Ford Transit	f	2026-03-22 14:31:15.582428
2	B-654GG	Ford Transit	t	2026-03-23 09:41:35.296718
\.


--
-- Data for Name: feiertage; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.feiertage (datum, name) FROM stdin;
2025-01-01	Neujahr
2025-01-06	Heilige Drei Könige
2025-04-21	Ostermontag
2025-05-01	Staatsfeiertag
2025-05-29	Christi Himmelfahrt
2025-06-09	Pfingstmontag
2025-06-19	Fronleichnam
2025-08-15	Mariä Himmelfahrt
2025-10-26	Nationalfeiertag
2025-11-01	Allerheiligen
2025-12-08	Mariä Empfängnis
2025-12-25	Christtag
2025-12-26	Stefanitag
2026-01-01	Neujahr
2026-01-06	Heilige Drei Könige
2026-04-06	Ostermontag
2026-05-01	Staatsfeiertag
2026-05-14	Christi Himmelfahrt
2026-05-25	Pfingstmontag
2026-06-04	Fronleichnam
2026-08-15	Mariä Himmelfahrt
2026-10-26	Nationalfeiertag
2026-11-01	Allerheiligen
2026-12-08	Mariä Empfängnis
2026-12-25	Christtag
2026-12-26	Stefanitag
2027-01-01	Neujahr
2027-01-06	Heilige Drei Könige
2027-03-29	Ostermontag
2027-05-01	Staatsfeiertag
2027-05-06	Christi Himmelfahrt
2027-05-17	Pfingstmontag
2027-05-27	Fronleichnam
2027-08-15	Mariä Himmelfahrt
2027-10-26	Nationalfeiertag
2027-11-01	Allerheiligen
2027-12-08	Mariä Empfängnis
2027-12-25	Christtag
2027-12-26	Stefanitag
\.


--
-- Data for Name: firma_einstellungen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.firma_einstellungen (id, name, anschrift, uid_atu, logo_base64) FROM stdin;
1	Solano Beschattungsmontagen OG	Fangstraße 31\nA-6973 Höchst	ATU80360789	data:image/jpeg;base64,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
\.


--
-- Data for Name: gps_tracks; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.gps_tracks (id, einsatz_id, lat, lng, zeitpunkt, genauigkeit) FROM stdin;
343	6	47.45660266	9.65070412	2026-03-19 08:03:46.798	4.54
344	6	47.45660316	9.65070400	2026-03-19 08:03:46.801	4.50
345	6	47.45659330	9.65071116	2026-03-19 08:03:47.569	4.01
355	7	47.46097810	9.64305170	2026-03-19 08:08:56.638	3.81
356	7	47.46094470	9.64304970	2026-03-19 08:28:30.884	13.57
357	7	47.46096220	9.64304260	2026-03-19 08:28:32.622	4.49
358	7	47.46097500	9.64303860	2026-03-19 08:28:33.635	4.26
359	7	47.46098680	9.64305280	2026-03-19 08:28:34.621	4.16
360	7	47.46099490	9.64305490	2026-03-19 08:28:35.619	4.09
367	7	47.46100520	9.64305730	2026-03-19 08:28:42.633	3.79
368	7	47.46100230	9.64305870	2026-03-19 08:28:43.626	3.79
369	7	47.46099820	9.64305880	2026-03-19 08:28:44.632	3.79
370	7	47.46099450	9.64305930	2026-03-19 08:28:45.636	3.79
371	7	47.46099260	9.64306010	2026-03-19 08:28:46.628	3.79
372	7	47.46099070	9.64306100	2026-03-19 08:28:47.633	3.79
373	7	47.46098950	9.64306150	2026-03-19 08:28:48.637	3.79
374	7	47.46098880	9.64306140	2026-03-19 08:28:49.631	3.79
375	7	47.46098940	9.64306110	2026-03-19 08:28:50.625	3.79
376	7	47.46098940	9.64306110	2026-03-19 08:28:51.017	3.79
377	7	47.46098940	9.64306040	2026-03-19 08:28:51.635	3.79
378	7	47.46098940	9.64306040	2026-03-19 08:28:51.635	3.79
379	7	47.46098960	9.64306050	2026-03-19 08:28:52.632	3.79
380	7	47.46098960	9.64306050	2026-03-19 08:28:52.633	3.79
381	7	47.46098990	9.64306060	2026-03-19 08:28:53.633	3.79
382	7	47.46098990	9.64306060	2026-03-19 08:28:53.635	3.79
383	7	47.46098990	9.64306050	2026-03-19 08:28:54.63	3.79
384	7	47.46098990	9.64306050	2026-03-19 08:28:54.63	3.79
385	7	47.46099000	9.64306030	2026-03-19 08:28:55.632	3.79
386	7	47.46099000	9.64306030	2026-03-19 08:28:55.632	3.79
387	7	47.46099010	9.64306010	2026-03-19 08:28:56.628	3.79
388	7	47.46099010	9.64306010	2026-03-19 08:28:56.629	3.79
389	7	47.46099020	9.64306000	2026-03-19 08:28:57.622	3.79
390	7	47.46099020	9.64306000	2026-03-19 08:28:57.622	3.79
391	7	47.46099020	9.64305990	2026-03-19 08:28:58.627	3.79
392	7	47.46099020	9.64305990	2026-03-19 08:28:58.627	3.79
393	7	47.46099020	9.64305980	2026-03-19 08:28:59.636	3.79
394	7	47.46099020	9.64305980	2026-03-19 08:28:59.637	3.79
395	7	47.46099080	9.64305960	2026-03-19 08:29:00.625	3.79
396	7	47.46099080	9.64305960	2026-03-19 08:29:00.626	3.79
397	7	47.46099100	9.64305940	2026-03-19 08:29:01.632	3.79
398	7	47.46099100	9.64305940	2026-03-19 08:29:01.632	3.79
399	7	47.46099100	9.64305940	2026-03-19 08:29:02.632	3.79
400	7	47.46099100	9.64305940	2026-03-19 08:29:02.634	3.79
401	7	47.46099100	9.64305940	2026-03-19 08:29:03.633	3.79
402	7	47.46099100	9.64305940	2026-03-19 08:29:03.633	3.79
403	7	47.46099090	9.64305930	2026-03-19 08:29:04.63	3.79
404	7	47.46099090	9.64305930	2026-03-19 08:29:04.632	3.79
405	7	47.46099070	9.64305930	2026-03-19 08:29:05.632	3.79
406	7	47.46099070	9.64305930	2026-03-19 08:29:05.633	3.79
407	7	47.46099120	9.64305930	2026-03-19 08:29:06.635	3.79
408	7	47.46099120	9.64305930	2026-03-19 08:29:06.635	3.79
409	7	47.46099130	9.64305910	2026-03-19 08:29:07.633	3.79
410	7	47.46099130	9.64305910	2026-03-19 08:29:07.633	3.79
411	7	47.46099120	9.64305950	2026-03-19 08:29:08.631	3.79
412	7	47.46099120	9.64305950	2026-03-19 08:29:08.634	3.79
413	7	47.46099110	9.64305990	2026-03-19 08:29:09.633	3.79
414	7	47.46099110	9.64305990	2026-03-19 08:29:09.633	3.79
415	7	47.46099100	9.64306000	2026-03-19 08:29:10.628	3.79
416	7	47.46099100	9.64306000	2026-03-19 08:29:10.628	3.79
417	7	47.46099120	9.64306020	2026-03-19 08:29:11.629	3.79
418	7	47.46099120	9.64306020	2026-03-19 08:29:11.63	3.79
419	7	47.46099140	9.64306020	2026-03-19 08:29:12.625	3.79
420	7	47.46099140	9.64306020	2026-03-19 08:29:12.625	3.79
421	7	47.46099140	9.64306010	2026-03-19 08:29:13.634	3.79
422	7	47.46099140	9.64306010	2026-03-19 08:29:13.635	3.79
423	7	47.46099130	9.64306000	2026-03-19 08:29:14.635	3.79
424	7	47.46099130	9.64306000	2026-03-19 08:29:14.637	3.79
425	7	47.46099130	9.64305990	2026-03-19 08:29:15.634	3.79
426	7	47.46099130	9.64305990	2026-03-19 08:29:15.634	3.79
427	7	47.46099130	9.64305970	2026-03-19 08:29:16.948	3.79
428	7	47.46099150	9.64305930	2026-03-19 08:29:17.633	3.79
429	7	47.46099170	9.64305880	2026-03-19 08:29:18.639	3.79
430	7	47.46099170	9.64305840	2026-03-19 08:29:19.631	3.79
431	7	47.46099180	9.64305780	2026-03-19 08:29:20.629	3.79
432	7	47.46099190	9.64305720	2026-03-19 08:29:21.626	3.79
439	7	47.46084440	9.64281440	2026-03-19 08:33:58.622	7.13
440	7	47.46084620	9.64281780	2026-03-19 08:33:59.625	6.78
441	7	47.46084640	9.64281820	2026-03-19 08:33:59.957	5.96
442	7	47.46084550	9.64281830	2026-03-19 08:34:00.626	5.52
443	7	47.46084530	9.64281830	2026-03-19 08:34:01.018	5.43
444	7	47.46084440	9.64281830	2026-03-19 08:34:01.624	5.17
445	7	47.46084420	9.64281840	2026-03-19 08:34:01.687	5.12
446	7	47.46084360	9.64281910	2026-03-19 08:34:02.629	4.98
447	7	47.46084330	9.64281770	2026-03-19 08:34:03.022	4.96
451	7	47.46084090	9.64281890	2026-03-19 08:34:06.628	4.65
452	7	47.46084090	9.64281890	2026-03-19 08:34:07.279	4.65
453	7	47.46084040	9.64281910	2026-03-19 08:34:07.632	4.55
454	7	47.46084040	9.64281910	2026-03-19 08:34:07.634	4.55
455	7	47.46083740	9.64281970	2026-03-19 08:34:08.624	4.34
456	7	47.46083740	9.64281970	2026-03-19 08:34:08.625	4.34
457	7	47.46083470	9.64281990	2026-03-19 08:34:09.627	4.19
458	7	47.46083470	9.64281990	2026-03-19 08:34:09.627	4.19
459	7	47.46083420	9.64281980	2026-03-19 08:34:10.201	4.09
460	7	47.46083420	9.64281980	2026-03-19 08:34:10.202	4.09
461	7	47.46083450	9.64282080	2026-03-19 08:34:10.622	3.81
462	7	47.46083450	9.64282080	2026-03-19 08:34:10.622	3.81
463	7	47.46083440	9.64282090	2026-03-19 08:34:11.623	3.64
464	7	47.46083440	9.64282090	2026-03-19 08:34:11.623	3.64
465	7	47.46083440	9.64282110	2026-03-19 08:34:12.622	3.46
466	7	47.46083440	9.64282110	2026-03-19 08:34:12.623	3.46
467	7	47.46083440	9.64282170	2026-03-19 08:34:12.976	3.45
468	7	47.46083440	9.64282170	2026-03-19 08:34:12.976	3.45
469	7	47.46083400	9.64282260	2026-03-19 08:34:13.621	3.47
470	7	47.46083400	9.64282260	2026-03-19 08:34:13.621	3.47
471	7	47.46083380	9.64282290	2026-03-19 08:34:13.876	3.46
472	7	47.46083380	9.64282290	2026-03-19 08:34:13.878	3.46
473	7	47.46083310	9.64282560	2026-03-19 08:34:14.623	3.56
346	7	47.46100160	9.64304820	2026-03-19 08:08:47.949	3.80
347	7	47.46100160	9.64304820	2026-03-19 08:08:47.968	3.80
348	7	47.46097560	9.64301850	2026-03-19 08:08:49.638	3.80
349	7	47.46097110	9.64301710	2026-03-19 08:08:50.637	3.79
350	7	47.46097340	9.64305290	2026-03-19 08:08:51.634	3.82
351	7	47.46097560	9.64305940	2026-03-19 08:08:52.639	3.81
322	6	47.45638890	9.65070629	2026-03-19 07:53:33.487	32.00
323	6	47.45638890	9.65070629	2026-03-19 07:53:33.493	32.00
324	6	47.45635267	9.65075371	2026-03-19 07:53:33.498	38.90
325	6	47.45635826	9.65074443	2026-03-19 07:53:33.506	80.88
326	6	47.45629754	9.65083631	2026-03-19 07:53:33.868	42.26
327	6	47.45629255	9.65084505	2026-03-19 07:53:36.09	44.00
328	6	47.45629452	9.65084287	2026-03-19 07:53:39.64	39.31
329	6	47.45629694	9.65084357	2026-03-19 07:53:43.641	33.32
330	6	47.45630663	9.65085159	2026-03-19 07:53:44.645	33.08
331	6	47.45630991	9.65085338	2026-03-19 07:53:45.646	32.94
332	6	47.45629279	9.65086396	2026-03-19 07:53:46.646	27.27
333	6	47.45630883	9.65086240	2026-03-19 07:53:47.646	32.53
334	6	47.45630937	9.65085056	2026-03-19 07:53:48.647	33.18
335	6	47.45630685	9.65083980	2026-03-19 07:53:49.663	34.36
336	6	47.45629200	9.65082413	2026-03-19 07:53:50.646	34.06
337	6	47.45629552	9.65081614	2026-03-19 07:53:51.646	35.04
338	6	47.45629513	9.65081582	2026-03-19 07:53:52.644	35.07
339	6	47.45629591	9.65079447	2026-03-19 07:53:53.654	35.80
340	6	47.45632508	9.65075503	2026-03-19 07:54:10.315	38.73
341	6	47.45664756	9.65124292	2026-03-19 07:55:03.726	27.04
342	6	47.45659083	9.65120824	2026-03-19 07:55:09.332	28.52
352	7	47.46097430	9.64305650	2026-03-19 08:08:53.635	3.81
353	7	47.46097870	9.64305560	2026-03-19 08:08:54.641	3.81
354	7	47.46097770	9.64305470	2026-03-19 08:08:55.636	3.81
361	7	47.46099910	9.64305490	2026-03-19 08:28:36.635	3.81
362	7	47.46100160	9.64305500	2026-03-19 08:28:37.635	3.81
363	7	47.46100410	9.64305670	2026-03-19 08:28:38.635	3.81
364	7	47.46100600	9.64305740	2026-03-19 08:28:39.633	3.81
365	7	47.46100670	9.64305810	2026-03-19 08:28:40.636	3.79
366	7	47.46100780	9.64305610	2026-03-19 08:28:41.633	3.79
433	7	47.46099180	9.64305690	2026-03-19 08:29:22.626	3.79
434	7	47.46089020	9.64282130	2026-03-19 08:33:53.621	21.77
435	7	47.46086550	9.64281460	2026-03-19 08:33:54.625	16.81
436	7	47.46085940	9.64281410	2026-03-19 08:33:55.625	13.72
437	7	47.46085240	9.64281450	2026-03-19 08:33:56.621	11.94
438	7	47.46084710	9.64281440	2026-03-19 08:33:57.625	10.74
448	7	47.46084270	9.64281840	2026-03-19 08:34:03.631	4.93
449	7	47.46084210	9.64281850	2026-03-19 08:34:04.627	4.80
450	7	47.46084150	9.64281860	2026-03-19 08:34:05.63	4.74
474	7	47.46083310	9.64282560	2026-03-19 08:34:14.623	3.56
475	7	47.46083270	9.64282730	2026-03-19 08:34:15.501	3.82
476	7	47.46083270	9.64282730	2026-03-19 08:34:15.502	3.82
477	7	47.46083390	9.64282850	2026-03-19 08:34:15.631	3.95
478	7	47.46083390	9.64282850	2026-03-19 08:34:15.632	3.95
479	7	47.46083500	9.64283110	2026-03-19 08:34:16.035	4.18
480	7	47.46083500	9.64283110	2026-03-19 08:34:16.035	4.18
481	7	47.46083760	9.64283920	2026-03-19 08:34:16.629	4.34
482	7	47.46083760	9.64283920	2026-03-19 08:34:16.629	4.34
483	7	47.46083840	9.64284160	2026-03-19 08:34:16.816	4.60
484	7	47.46083840	9.64284160	2026-03-19 08:34:16.817	4.60
485	7	47.46084320	9.64284800	2026-03-19 08:34:17.297	4.75
486	7	47.46084320	9.64284800	2026-03-19 08:34:17.297	4.75
487	7	47.46084660	9.64285650	2026-03-19 08:34:17.631	4.95
488	7	47.46084660	9.64285650	2026-03-19 08:34:17.631	4.95
489	7	47.46084910	9.64286470	2026-03-19 08:34:18.157	5.19
490	7	47.46084910	9.64286470	2026-03-19 08:34:18.158	5.19
491	7	47.46085090	9.64287540	2026-03-19 08:34:18.625	5.36
492	7	47.46085090	9.64287540	2026-03-19 08:34:18.625	5.36
493	7	47.46085130	9.64287850	2026-03-19 08:34:18.732	5.39
494	7	47.46085130	9.64287850	2026-03-19 08:34:18.732	5.39
495	7	47.46085120	9.64289070	2026-03-19 08:34:19.618	5.71
496	7	47.46085120	9.64289070	2026-03-19 08:34:19.619	5.71
497	7	47.46084910	9.64289930	2026-03-19 08:34:20.235	5.84
498	7	47.46084910	9.64289930	2026-03-19 08:34:20.236	5.84
499	7	47.46084720	9.64290360	2026-03-19 08:34:20.622	5.93
500	7	47.46084720	9.64290360	2026-03-19 08:34:20.622	5.93
501	7	47.46084450	9.64290740	2026-03-19 08:34:21.072	5.91
502	7	47.46084450	9.64290740	2026-03-19 08:34:21.073	5.91
503	7	47.46084030	9.64291100	2026-03-19 08:34:21.621	5.84
504	7	47.46084030	9.64291100	2026-03-19 08:34:21.622	5.84
505	7	47.46083540	9.64291440	2026-03-19 08:34:22.393	5.63
506	7	47.46083540	9.64291440	2026-03-19 08:34:22.393	5.63
507	7	47.46083320	9.64291520	2026-03-19 08:34:22.621	5.57
508	7	47.46083320	9.64291520	2026-03-19 08:34:22.621	5.57
509	7	47.46082880	9.64291850	2026-03-19 08:34:23.192	5.44
510	7	47.46082880	9.64291850	2026-03-19 08:34:23.192	5.44
511	7	47.46082450	9.64292030	2026-03-19 08:34:23.625	5.39
512	7	47.46082450	9.64292030	2026-03-19 08:34:23.625	5.39
513	7	47.46082090	9.64292240	2026-03-19 08:34:24.034	5.30
514	7	47.46082090	9.64292240	2026-03-19 08:34:24.035	5.30
515	7	47.46081630	9.64292570	2026-03-19 08:34:24.601	5.29
516	7	47.46081630	9.64292570	2026-03-19 08:34:24.601	5.29
517	7	47.46080930	9.64292930	2026-03-19 08:34:25.437	5.12
518	7	47.46080930	9.64292930	2026-03-19 08:34:25.437	5.12
519	7	47.46080650	9.64292950	2026-03-19 08:34:25.632	5.10
520	7	47.46080650	9.64292950	2026-03-19 08:34:25.633	5.10
521	7	47.46080650	9.64292950	2026-03-19 08:34:25.75	5.10
522	7	47.46080340	9.64293080	2026-03-19 08:34:25.916	5.07
523	7	47.46080340	9.64293080	2026-03-19 08:34:25.917	5.07
524	7	47.46080340	9.64293080	2026-03-19 08:34:25.917	5.07
525	7	47.46079640	9.64293270	2026-03-19 08:34:26.628	5.03
526	7	47.46079640	9.64293270	2026-03-19 08:34:26.629	5.03
527	7	47.46079640	9.64293270	2026-03-19 08:34:26.629	5.03
528	7	47.46079440	9.64293320	2026-03-19 08:34:26.815	5.03
529	7	47.46079440	9.64293320	2026-03-19 08:34:26.817	5.03
530	7	47.46079440	9.64293320	2026-03-19 08:34:26.817	5.03
531	7	47.46078950	9.64293710	2026-03-19 08:34:27.497	5.04
532	7	47.46078950	9.64293710	2026-03-19 08:34:27.498	5.04
533	7	47.46078950	9.64293710	2026-03-19 08:34:27.498	5.04
534	7	47.46078900	9.64293680	2026-03-19 08:34:27.636	5.05
535	7	47.46078900	9.64293680	2026-03-19 08:34:27.637	5.05
536	7	47.46078900	9.64293680	2026-03-19 08:34:27.637	5.05
537	7	47.46078760	9.64294050	2026-03-19 08:34:28.113	5.07
538	7	47.46078760	9.64294050	2026-03-19 08:34:28.118	5.07
539	7	47.46078760	9.64294050	2026-03-19 08:34:28.118	5.07
540	7	47.46078800	9.64294130	2026-03-19 08:34:28.43	5.09
541	7	47.46078800	9.64294130	2026-03-19 08:34:28.431	5.09
542	7	47.46078800	9.64294130	2026-03-19 08:34:28.431	5.09
543	7	47.46079360	9.64294430	2026-03-19 08:34:28.627	5.10
544	7	47.46079360	9.64294430	2026-03-19 08:34:28.631	5.10
545	7	47.46079360	9.64294430	2026-03-19 08:34:28.631	5.10
546	7	47.46079580	9.64294350	2026-03-19 08:34:28.957	5.09
547	7	47.46079580	9.64294350	2026-03-19 08:34:28.96	5.09
548	7	47.46079580	9.64294350	2026-03-19 08:34:28.96	5.09
549	7	47.46080170	9.64294040	2026-03-19 08:34:29.632	5.07
550	7	47.46080170	9.64294040	2026-03-19 08:34:29.633	5.07
551	7	47.46080170	9.64294040	2026-03-19 08:34:29.633	5.07
552	7	47.46080700	9.64293630	2026-03-19 08:34:30.199	5.05
553	7	47.46080700	9.64293630	2026-03-19 08:34:30.2	5.05
554	7	47.46080700	9.64293630	2026-03-19 08:34:30.2	5.05
555	7	47.46081200	9.64293160	2026-03-19 08:34:30.625	5.01
556	7	47.46081200	9.64293160	2026-03-19 08:34:30.626	5.01
557	7	47.46081200	9.64293160	2026-03-19 08:34:30.626	5.01
558	7	47.46081910	9.64292730	2026-03-19 08:34:31.351	5.00
559	7	47.46081910	9.64292730	2026-03-19 08:34:31.351	5.00
560	7	47.46081910	9.64292730	2026-03-19 08:34:31.351	5.00
561	7	47.46082390	9.64292230	2026-03-19 08:34:31.628	4.95
562	7	47.46082390	9.64292230	2026-03-19 08:34:31.63	4.95
563	7	47.46082390	9.64292230	2026-03-19 08:34:31.63	4.95
564	7	47.46082850	9.64291780	2026-03-19 08:34:31.988	4.91
565	7	47.46082850	9.64291780	2026-03-19 08:34:31.989	4.91
566	7	47.46082850	9.64291780	2026-03-19 08:34:31.989	4.91
567	7	47.46083520	9.64291150	2026-03-19 08:34:32.62	4.87
568	7	47.46083520	9.64291150	2026-03-19 08:34:32.624	4.87
569	7	47.46083520	9.64291150	2026-03-19 08:34:32.624	4.87
570	7	47.46084360	9.64290010	2026-03-19 08:34:33.356	4.83
571	7	47.46084360	9.64290010	2026-03-19 08:34:33.358	4.83
572	7	47.46084360	9.64290010	2026-03-19 08:34:33.358	4.83
573	7	47.46084770	9.64289300	2026-03-19 08:34:33.627	4.82
574	7	47.46084770	9.64289300	2026-03-19 08:34:33.63	4.82
575	7	47.46084770	9.64289300	2026-03-19 08:34:33.63	4.82
576	7	47.46085160	9.64288630	2026-03-19 08:34:34.011	4.79
577	7	47.46085160	9.64288630	2026-03-19 08:34:34.015	4.79
578	7	47.46085160	9.64288630	2026-03-19 08:34:34.015	4.79
579	7	47.46085530	9.64287500	2026-03-19 08:34:34.626	4.78
580	7	47.46085530	9.64287500	2026-03-19 08:34:34.63	4.78
581	7	47.46085530	9.64287500	2026-03-19 08:34:34.63	4.78
582	7	47.46085540	9.64287150	2026-03-19 08:34:34.99	4.78
583	7	47.46085540	9.64287150	2026-03-19 08:34:34.991	4.78
584	7	47.46085540	9.64287150	2026-03-19 08:34:34.991	4.78
585	7	47.46085620	9.64285850	2026-03-19 08:34:35.155	4.78
586	7	47.46085620	9.64285850	2026-03-19 08:34:35.156	4.78
587	7	47.46085620	9.64285850	2026-03-19 08:34:35.156	4.78
588	7	47.46085390	9.64285260	2026-03-19 08:34:35.628	4.76
589	7	47.46085390	9.64285260	2026-03-19 08:34:35.629	4.76
590	7	47.46085390	9.64285260	2026-03-19 08:34:35.629	4.76
591	7	47.46085120	9.64284890	2026-03-19 08:34:35.954	4.76
592	7	47.46085120	9.64284890	2026-03-19 08:34:35.955	4.76
593	7	47.46085120	9.64284890	2026-03-19 08:34:35.955	4.76
594	7	47.46084490	9.64284180	2026-03-19 08:34:36.623	4.75
595	7	47.46084490	9.64284180	2026-03-19 08:34:36.624	4.75
596	7	47.46084490	9.64284180	2026-03-19 08:34:36.624	4.75
597	7	47.46084380	9.64284100	2026-03-19 08:34:36.695	4.74
598	7	47.46084380	9.64284100	2026-03-19 08:34:36.696	4.74
599	7	47.46084380	9.64284100	2026-03-19 08:34:36.696	4.74
600	7	47.46083840	9.64283600	2026-03-19 08:34:37.336	4.74
601	7	47.46083840	9.64283600	2026-03-19 08:34:37.337	4.74
602	7	47.46083840	9.64283600	2026-03-19 08:34:37.337	4.74
603	7	47.46083560	9.64283290	2026-03-19 08:34:37.629	4.72
604	7	47.46083560	9.64283290	2026-03-19 08:34:37.631	4.72
605	7	47.46083560	9.64283290	2026-03-19 08:34:37.631	4.72
606	7	47.46083180	9.64282940	2026-03-19 08:34:38.033	4.68
607	7	47.46083180	9.64282940	2026-03-19 08:34:38.035	4.68
608	7	47.46083180	9.64282940	2026-03-19 08:34:38.035	4.68
609	7	47.46082740	9.64282420	2026-03-19 08:34:38.633	4.64
610	7	47.46082740	9.64282420	2026-03-19 08:34:38.633	4.64
611	7	47.46082740	9.64282420	2026-03-19 08:34:38.633	4.64
612	7	47.46082600	9.64282250	2026-03-19 08:34:38.819	4.63
613	7	47.46082020	9.64281450	2026-03-19 08:34:39.627	4.62
614	7	47.46082020	9.64281450	2026-03-19 08:34:39.627	4.62
615	7	47.46092390	9.64287240	2026-03-19 08:35:04.629	24.42
616	7	47.46091830	9.64286940	2026-03-19 08:35:04.984	24.44
617	7	47.46088260	9.64284500	2026-03-19 08:35:05.63	19.88
618	7	47.46087480	9.64283980	2026-03-19 08:35:05.858	17.60
619	7	47.46087070	9.64283700	2026-03-19 08:35:06.589	16.23
620	7	47.46085410	9.64283250	2026-03-19 08:35:07.631	13.76
621	7	47.46085130	9.64283170	2026-03-19 08:35:07.7	12.88
622	7	47.46084450	9.64283280	2026-03-19 08:35:08.631	12.11
623	7	47.46084230	9.64283330	2026-03-19 08:35:09.15	11.00
624	7	47.46084040	9.64283540	2026-03-19 08:35:09.627	10.52
625	7	47.46083720	9.64283720	2026-03-19 08:35:10.623	7.18
626	7	47.46083500	9.64283920	2026-03-19 08:35:19.633	5.57
627	7	47.46083560	9.64283860	2026-03-19 08:35:20.142	5.57
628	7	47.46083840	9.64284070	2026-03-19 08:35:20.25	5.50
629	7	47.46083760	9.64284190	2026-03-19 08:35:20.625	5.40
630	7	47.46083740	9.64284230	2026-03-19 08:35:20.778	5.33
631	7	47.46083670	9.64284330	2026-03-19 08:35:21.439	5.31
632	7	47.46083820	9.64284600	2026-03-19 08:35:21.623	5.25
633	7	47.46083900	9.64284730	2026-03-19 08:35:21.876	5.21
634	7	47.46084140	9.64285130	2026-03-19 08:35:22.624	5.15
635	7	47.46084490	9.64285480	2026-03-19 08:35:23.631	5.04
636	7	47.46084610	9.64285610	2026-03-19 08:35:24.276	4.99
637	7	47.46084760	9.64285760	2026-03-19 08:35:24.627	4.87
638	7	47.46084820	9.64285820	2026-03-19 08:35:24.858	4.83
639	7	47.46084960	9.64285960	2026-03-19 08:35:25.626	4.68
640	7	47.46085080	9.64286070	2026-03-19 08:35:26.601	4.52
641	7	47.46085160	9.64286380	2026-03-19 08:35:27.624	4.28
642	7	47.46085150	9.64286400	2026-03-19 08:35:28.627	4.18
643	7	47.46085150	9.64286400	2026-03-19 08:35:29.517	4.18
644	7	47.46085210	9.64286590	2026-03-19 08:35:29.631	4.08
645	7	47.46085210	9.64286590	2026-03-19 08:35:29.632	4.08
646	7	47.46085220	9.64286630	2026-03-19 08:35:30.019	4.05
647	7	47.46085220	9.64286630	2026-03-19 08:35:30.021	4.05
648	7	47.46085320	9.64287130	2026-03-19 08:35:30.625	3.98
649	7	47.46085320	9.64287130	2026-03-19 08:35:30.626	3.98
650	7	47.46085430	9.64287710	2026-03-19 08:35:31.631	3.81
651	7	47.46085430	9.64287710	2026-03-19 08:35:31.631	3.81
652	7	47.46085460	9.64288030	2026-03-19 08:35:32.624	3.67
653	7	47.46085460	9.64288030	2026-03-19 08:35:32.624	3.67
654	7	47.46085450	9.64288110	2026-03-19 08:35:33.255	3.59
655	7	47.46085450	9.64288110	2026-03-19 08:35:33.256	3.59
656	7	47.46085460	9.64288290	2026-03-19 08:35:33.623	3.46
657	7	47.46085460	9.64288290	2026-03-19 08:35:33.623	3.46
658	7	47.46085480	9.64288260	2026-03-19 08:35:34.635	3.27
659	7	47.46085480	9.64288260	2026-03-19 08:35:34.635	3.27
660	7	47.46085470	9.64288240	2026-03-19 08:35:35.63	3.08
661	7	47.46085470	9.64288240	2026-03-19 08:35:35.631	3.08
662	7	47.46085420	9.64288280	2026-03-19 08:35:36.627	3.12
663	7	47.46085420	9.64288280	2026-03-19 08:35:36.627	3.12
664	7	47.46085390	9.64288230	2026-03-19 08:35:37.632	3.16
665	7	47.46085390	9.64288230	2026-03-19 08:35:37.633	3.16
666	7	47.46085340	9.64288270	2026-03-19 08:35:38.626	3.24
667	7	47.46085340	9.64288270	2026-03-19 08:35:38.627	3.24
668	7	47.46085420	9.64288240	2026-03-19 08:35:39.635	3.32
669	7	47.46085420	9.64288240	2026-03-19 08:35:39.635	3.32
670	7	47.46085440	9.64288240	2026-03-19 08:35:39.803	3.36
671	7	47.46085440	9.64288240	2026-03-19 08:35:39.804	3.36
672	7	47.46085500	9.64288050	2026-03-19 08:35:40.627	3.41
673	7	47.46085500	9.64288050	2026-03-19 08:35:40.628	3.41
674	7	47.46085440	9.64288020	2026-03-19 08:35:41.63	3.49
675	7	47.46085440	9.64288020	2026-03-19 08:35:41.631	3.49
676	7	47.46085400	9.64287960	2026-03-19 08:35:42.628	3.60
677	7	47.46085400	9.64287960	2026-03-19 08:35:42.629	3.60
678	7	47.46085420	9.64287950	2026-03-19 08:35:43.631	3.63
679	7	47.46085420	9.64287950	2026-03-19 08:35:43.632	3.63
680	7	47.46085420	9.64287880	2026-03-19 08:35:44.623	3.74
681	7	47.46085420	9.64287880	2026-03-19 08:35:44.624	3.74
682	7	47.46085390	9.64287980	2026-03-19 08:35:45.628	3.74
683	7	47.46085390	9.64287980	2026-03-19 08:35:45.628	3.74
684	7	47.46085430	9.64288010	2026-03-19 08:35:46.361	3.79
685	7	47.46085430	9.64288010	2026-03-19 08:35:46.362	3.79
686	7	47.46085790	9.64288190	2026-03-19 08:35:46.623	3.81
687	7	47.46085790	9.64288190	2026-03-19 08:35:46.624	3.81
688	7	47.46085830	9.64288250	2026-03-19 08:35:47.63	3.82
689	7	47.46085830	9.64288250	2026-03-19 08:35:47.631	3.82
690	7	47.46085810	9.64288270	2026-03-19 08:35:48.63	3.80
691	7	47.46085810	9.64288270	2026-03-19 08:35:48.631	3.80
692	7	47.46085790	9.64288270	2026-03-19 08:35:49.626	3.73
693	7	47.46085790	9.64288270	2026-03-19 08:35:49.627	3.73
694	7	47.46085760	9.64288260	2026-03-19 08:35:50.629	3.70
695	7	47.46085760	9.64288260	2026-03-19 08:35:50.629	3.70
696	7	47.46085740	9.64288260	2026-03-19 08:35:51.63	3.63
697	7	47.46085740	9.64288260	2026-03-19 08:35:51.632	3.63
698	7	47.46085710	9.64288270	2026-03-19 08:35:52.624	3.61
699	7	47.46085710	9.64288270	2026-03-19 08:35:52.624	3.61
700	7	47.46085710	9.64288270	2026-03-19 08:35:52.914	3.59
701	7	47.46085710	9.64288270	2026-03-19 08:35:52.914	3.59
702	7	47.46085790	9.64288250	2026-03-19 08:35:53.631	3.50
703	7	47.46085790	9.64288250	2026-03-19 08:35:53.632	3.50
704	7	47.46085770	9.64288260	2026-03-19 08:35:54.634	3.48
705	7	47.46085770	9.64288260	2026-03-19 08:35:54.634	3.48
706	7	47.46085770	9.64288260	2026-03-19 08:35:55.056	3.44
707	7	47.46085770	9.64288260	2026-03-19 08:35:55.056	3.44
708	7	47.46085770	9.64288260	2026-03-19 08:35:55.159	3.44
709	7	47.46085760	9.64288260	2026-03-19 08:35:55.634	3.43
710	7	47.46085760	9.64288260	2026-03-19 08:35:55.634	3.43
711	7	47.46085760	9.64288260	2026-03-19 08:35:55.634	3.43
712	7	47.46085740	9.64288250	2026-03-19 08:35:56.628	3.37
713	7	47.46085740	9.64288250	2026-03-19 08:35:56.628	3.37
714	7	47.46085740	9.64288250	2026-03-19 08:35:56.628	3.37
715	7	47.46085720	9.64288250	2026-03-19 08:35:57.454	3.37
716	7	47.46085720	9.64288250	2026-03-19 08:35:57.454	3.37
717	7	47.46085720	9.64288250	2026-03-19 08:35:57.454	3.37
718	7	47.46085690	9.64288260	2026-03-19 08:35:57.634	3.35
719	7	47.46085690	9.64288260	2026-03-19 08:35:57.634	3.35
720	7	47.46085690	9.64288260	2026-03-19 08:35:57.634	3.35
721	7	47.46085630	9.64288260	2026-03-19 08:35:58.257	3.37
722	7	47.46085630	9.64288260	2026-03-19 08:35:58.258	3.37
723	7	47.46085630	9.64288260	2026-03-19 08:35:58.258	3.37
724	7	47.46085580	9.64288270	2026-03-19 08:35:58.63	3.38
725	7	47.46085580	9.64288270	2026-03-19 08:35:58.631	3.38
726	7	47.46085580	9.64288270	2026-03-19 08:35:58.631	3.38
727	7	47.46085510	9.64288330	2026-03-19 08:35:59.154	3.38
728	7	47.46085510	9.64288330	2026-03-19 08:35:59.155	3.38
729	7	47.46085510	9.64288330	2026-03-19 08:35:59.155	3.38
730	7	47.46085510	9.64288370	2026-03-19 08:35:59.469	3.41
731	7	47.46085510	9.64288370	2026-03-19 08:35:59.469	3.41
732	7	47.46085510	9.64288370	2026-03-19 08:35:59.469	3.41
733	7	47.46085580	9.64288490	2026-03-19 08:35:59.574	3.42
734	7	47.46085580	9.64288490	2026-03-19 08:35:59.574	3.42
735	7	47.46085580	9.64288490	2026-03-19 08:35:59.574	3.42
1360	11	47.46169832	9.62740844	2026-03-19 09:45:15.755	27.39
1361	12	47.46327466	9.62635541	2026-03-19 09:52:08.556	15.68
1362	12	47.46327466	9.62635541	2026-03-19 09:52:08.562	15.68
1363	12	47.46327456	9.62635564	2026-03-19 09:52:08.575	15.68
1364	12	47.46330292	9.62631454	2026-03-19 09:52:08.742	14.72
1365	12	47.46334119	9.62624019	2026-03-19 09:52:09.184	13.21
1366	12	47.46340668	9.62637549	2026-03-19 09:52:10.896	25.16
1367	12	47.46328712	9.62634816	2026-03-19 09:52:14.218	18.40
1368	12	47.46325827	9.62633564	2026-03-19 09:52:15.22	13.73
1225	11	47.46161933	9.62746250	2026-03-19 09:45:09.036	16.86
1226	11	47.46161933	9.62746250	2026-03-19 09:45:09.208	16.86
1227	11	47.46160486	9.62775506	2026-03-19 09:45:09.21	135.17
1232	11	47.46157610	9.62752901	2026-03-19 09:45:09.228	62.28
1233	11	47.46166985	9.62741756	2026-03-19 09:45:09.736	29.71
1234	11	47.46169082	9.62742773	2026-03-19 09:45:13.196	30.48
1239	11	47.46169225	9.62742516	2026-03-19 09:45:14.188	30.58
736	7	47.46085190	9.64288880	2026-03-19 08:36:00.627	3.55
737	7	47.46085190	9.64288880	2026-03-19 08:36:00.627	3.55
738	7	47.46085190	9.64288880	2026-03-19 08:36:00.627	3.55
739	7	47.46085140	9.64288970	2026-03-19 08:36:00.72	3.64
740	7	47.46085140	9.64288970	2026-03-19 08:36:00.72	3.64
741	7	47.46085140	9.64288970	2026-03-19 08:36:00.72	3.64
742	7	47.46084850	9.64289410	2026-03-19 08:36:01.436	3.78
743	7	47.46084850	9.64289410	2026-03-19 08:36:01.436	3.78
744	7	47.46084850	9.64289410	2026-03-19 08:36:01.436	3.78
745	7	47.46084480	9.64289830	2026-03-19 08:36:01.631	3.96
746	7	47.46084480	9.64289830	2026-03-19 08:36:01.631	3.96
747	7	47.46084480	9.64289830	2026-03-19 08:36:01.631	3.96
748	7	47.46084150	9.64290220	2026-03-19 08:36:02.013	4.12
749	7	47.46084150	9.64290220	2026-03-19 08:36:02.013	4.12
750	7	47.46084150	9.64290220	2026-03-19 08:36:02.013	4.12
751	7	47.46083350	9.64291160	2026-03-19 08:36:02.622	4.39
752	7	47.46083350	9.64291160	2026-03-19 08:36:02.623	4.39
753	7	47.46083350	9.64291160	2026-03-19 08:36:02.623	4.39
754	7	47.46083120	9.64291420	2026-03-19 08:36:02.738	4.63
755	7	47.46083120	9.64291420	2026-03-19 08:36:02.738	4.63
756	7	47.46083120	9.64291420	2026-03-19 08:36:02.738	4.63
757	7	47.46082550	9.64292080	2026-03-19 08:36:03.318	4.89
758	7	47.46082550	9.64292080	2026-03-19 08:36:03.319	4.89
759	7	47.46082550	9.64292080	2026-03-19 08:36:03.319	4.89
760	7	47.46082120	9.64292590	2026-03-19 08:36:03.623	4.99
761	7	47.46082120	9.64292590	2026-03-19 08:36:03.624	4.99
762	7	47.46082120	9.64292590	2026-03-19 08:36:03.624	4.99
763	7	47.46081330	9.64293570	2026-03-19 08:36:04.538	5.41
764	7	47.46081330	9.64293570	2026-03-19 08:36:04.539	5.41
765	7	47.46081330	9.64293570	2026-03-19 08:36:04.539	5.41
766	7	47.46081130	9.64293840	2026-03-19 08:36:04.624	5.82
767	7	47.46081130	9.64293840	2026-03-19 08:36:04.624	5.82
768	7	47.46081130	9.64293840	2026-03-19 08:36:04.624	5.82
769	7	47.46080670	9.64294490	2026-03-19 08:36:05.151	5.91
770	7	47.46080670	9.64294490	2026-03-19 08:36:05.152	5.91
771	7	47.46080670	9.64294490	2026-03-19 08:36:05.152	5.91
772	7	47.46080210	9.64295100	2026-03-19 08:36:05.628	5.96
773	7	47.46080210	9.64295100	2026-03-19 08:36:05.628	5.96
774	7	47.46080210	9.64295100	2026-03-19 08:36:05.629	5.96
775	7	47.46079930	9.64295510	2026-03-19 08:36:05.954	6.30
776	7	47.46079930	9.64295510	2026-03-19 08:36:05.954	6.30
777	7	47.46079930	9.64295510	2026-03-19 08:36:05.954	6.30
778	7	47.46079320	9.64295200	2026-03-19 08:36:06.594	6.41
779	7	47.46079320	9.64295200	2026-03-19 08:36:06.594	6.41
780	7	47.46079320	9.64295200	2026-03-19 08:36:06.594	6.41
781	7	47.46078750	9.64295470	2026-03-19 08:36:07.161	6.50
782	7	47.46078750	9.64295470	2026-03-19 08:36:07.162	6.50
783	7	47.46078750	9.64295470	2026-03-19 08:36:07.162	6.50
784	7	47.46078410	9.64296020	2026-03-19 08:36:07.625	6.47
785	7	47.46078410	9.64296020	2026-03-19 08:36:07.626	6.47
786	7	47.46078410	9.64296020	2026-03-19 08:36:07.626	6.47
787	7	47.46078160	9.64296410	2026-03-19 08:36:07.997	6.52
788	7	47.46078160	9.64296410	2026-03-19 08:36:07.997	6.52
789	7	47.46078160	9.64296410	2026-03-19 08:36:07.997	6.52
790	7	47.46077770	9.64297120	2026-03-19 08:36:08.625	6.51
791	7	47.46077770	9.64297120	2026-03-19 08:36:08.626	6.51
792	7	47.46077770	9.64297120	2026-03-19 08:36:08.626	6.51
793	7	47.46077570	9.64297470	2026-03-19 08:36:08.958	6.50
794	7	47.46077570	9.64297470	2026-03-19 08:36:08.958	6.50
795	7	47.46077570	9.64297470	2026-03-19 08:36:08.958	6.50
796	7	47.46077290	9.64298190	2026-03-19 08:36:09.625	6.45
797	7	47.46077290	9.64298190	2026-03-19 08:36:09.626	6.45
798	7	47.46077290	9.64298190	2026-03-19 08:36:09.626	6.45
799	7	47.46077240	9.64298410	2026-03-19 08:36:09.799	6.44
800	7	47.46077240	9.64298410	2026-03-19 08:36:09.799	6.44
801	7	47.46077240	9.64298410	2026-03-19 08:36:09.799	6.44
802	7	47.45944370	9.64212640	2026-03-19 08:43:49.629	19.09
803	8	47.45895220	9.63898990	2026-03-19 08:46:57.741	19.39
804	8	47.45897630	9.63899710	2026-03-19 08:46:59.603	21.43
805	8	47.45898080	9.63899840	2026-03-19 08:47:00.561	22.11
806	8	47.45899480	9.63900110	2026-03-19 08:47:00.597	19.44
807	8	47.45900320	9.63900090	2026-03-19 08:47:01.611	16.83
808	8	47.45900660	9.63899440	2026-03-19 08:47:02.607	14.85
809	8	47.45900720	9.63899000	2026-03-19 08:47:03.608	13.36
810	8	47.45900810	9.63898740	2026-03-19 08:47:04.231	12.19
811	8	47.45900730	9.63898560	2026-03-19 08:47:04.606	11.28
812	8	47.45900870	9.63898210	2026-03-19 08:47:05.607	5.97
813	8	47.45900870	9.63897990	2026-03-19 08:47:06.337	5.62
814	8	47.45900860	9.63897980	2026-03-19 08:47:06.607	5.34
815	8	47.45900830	9.63897850	2026-03-19 08:47:06.817	4.62
816	8	47.45900810	9.63897840	2026-03-19 08:47:07.601	4.35
817	8	47.45900830	9.63897700	2026-03-19 08:47:08.607	3.86
818	8	47.45900850	9.63897550	2026-03-19 08:47:09.602	3.50
819	8	47.45900870	9.63897430	2026-03-19 08:47:10.608	3.26
820	8	47.45900870	9.63897370	2026-03-19 08:47:11.193	3.23
821	8	47.45900860	9.63897390	2026-03-19 08:47:11.606	3.03
822	8	47.45900850	9.63897360	2026-03-19 08:47:12.609	3.01
823	8	47.45903780	9.63902200	2026-03-19 09:21:39.687	19.09
824	8	47.45903440	9.63901290	2026-03-19 09:21:40.677	20.88
825	8	47.45902910	9.63900660	2026-03-19 09:21:41.193	20.69
826	8	47.45873620	9.63067580	2026-03-19 09:26:13.823	98.40
827	8	47.45854200	9.63026370	2026-03-19 09:26:14.63	5.54
1369	12	47.46304303	9.62636306	2026-03-19 10:17:05.162	51.95
1370	12	47.46304302	9.62636309	2026-03-19 10:17:05.162	70.85
1371	12	47.46304302	9.62636309	2026-03-19 10:17:05.184	70.91
1372	12	47.46332991	9.62634369	2026-03-19 10:17:05.448	22.73
\.


--
-- Data for Name: kalender_events; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.kalender_events (id, titel, start_zeit, end_zeit, ort, beschreibung, organisator, mitarbeiter_ids, synced_at) FROM stdin;
\.


--
-- Data for Name: kalender_settings; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.kalender_settings (id, exchange_url, exchange_user, exchange_pass, sync_intervall_min, letzter_sync) FROM stdin;
1	http://mail.solano.co.at	office@solano.co.at	20Rba5#B*AU	15	\N
\.


--
-- Data for Name: ma_kosten_einstellungen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ma_kosten_einstellungen (id, stundensatz_fa, stundensatz_ha, stundensatz_gf, warnschwelle, aktualisiert_am) FROM stdin;
1	60.00	40.00	35.00	55.00	2026-03-17 12:22:12.468558
\.


--
-- Data for Name: mitarbeiter; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.mitarbeiter (id, name, pin, aktiv, ist_admin, zeige_winterdienst, zeige_gebaeudereinigung, zeige_gruenpflege, ist_chef, winterdienst_alarm, soll_stunden, beschaeftigung, zeige_projekte, darf_nachrichten, nachricht_verfuegbar, sieht_aktive_einsaetze, sieht_einsatz_details, kann_einsteigen, darf_bestellen, darf_export, darf_artikelanlage) FROM stdin;
2	Mitarbeiter 2	5678	f	f	t	t	t	f	t	38.50	vollzeit	t	f	t	f	f	f	f	f	f
4	Calvin	0000	f	f	f	t	f	f	t	38.50	vollzeit	t	f	t	f	f	f	f	f	f
10	Ferdi	2602	t	f	f	t	f	f	f	34.00	geringfuegig	f	t	t	t	f	t	t	f	t
8	Michi	1994	t	f	t	t	t	t	t	40.00	vollzeit	t	f	t	t	t	t	t	t	t
1	Superuser	2706	t	t	t	t	t	f	t	38.50	vollzeit	t	t	t	t	t	t	t	t	t
9	Chiara	2601	t	f	f	t	f	f	f	34.00	geringfuegig	f	t	t	t	f	t	t	f	t
3	Stefano	5584	t	f	t	t	t	t	t	40.00	vollzeit	t	f	t	t	t	t	t	t	t
7	Rene	2312	f	f	t	t	t	t	f	38.50	vollzeit	t	f	t	f	f	f	f	f	f
6	Roman Dall	1414	t	f	t	t	t	t	f	38.50	vollzeit	t	t	t	t	t	t	f	f	f
5	Steffi	1212	t	f	t	t	t	t	f	38.50	vollzeit	t	t	t	t	t	t	f	f	f
\.


--
-- Data for Name: nachrichten; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.nachrichten (id, von_id, von_name, an_id, an_name, text, gesendet_am, antwort, antwort_am, gelesen, ist_arbeitsanweisung) FROM stdin;
\.


--
-- Data for Name: projekt_auftraege; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projekt_auftraege (id, auftraggeber_id, auftraggeber_name, auftragsnummer, mitarbeiter_id, mitarbeiter_name, anzahl_mitarbeiter, fahrt_start, ankunft, abfahrt_zeit, fahrt_ende, fahrzeit_hin_min, arbeitszeit_min, fahrzeit_zurueck_min, km_hin, km_zurueck, gps_punkte, notiz, besonderheiten, status, montagewert_netto, gutschrift_betrag, gutschrift_datum, gutschrift_nummer, erstellt_am, abgeschlossen_am, arbeitszeit_manuell_min, sessions, kundenname, adresse, tour_id, tour_position, naechster_auftrag_id, km_verbindung, rapport_erforderlich, rapport_beschreibung, geplant_datum, adresse_strasse, adresse_plz, adresse_land, sort_order, ma_typen, adresse_ort, fahrtkosten_pauschale, geplant_uhrzeit, geplant_dauer_min, sonderverguetung, rapport_betrag, erneuter_einsatz_noetig, erneuter_einsatz_datum, einsatz_history, fz_diesel_preis, fz_verbrauch_100km, fz_maut_pro_km, fz_abnuetzung_pro_km, ma_stundensatz_fa, ma_stundensatz_ha, ma_stundensatz_gf, ma_warnschwelle, telefon, email, ist_aufmass, auftragstyp) FROM stdin;
28	2	Hornbach	\N	3	Stefano	2	2026-03-23 11:36:00.534962+00	2026-03-23 11:57:22.73684+00	2026-03-23 12:08:30.065401+00	2026-03-23 14:11:11.71804+00	21	11	123	12.20	0.00	[{"ts": "2026-03-23T11:36:01.048Z", "acc": 34, "lat": 47.3721329, "lng": 9.6925135}, {"ts": "2026-03-23T11:36:01.591Z", "acc": 22, "lat": 47.3722261, "lng": 9.6926538}, {"ts": "2026-03-23T11:36:02.588Z", "acc": 16, "lat": 47.3722098, "lng": 9.6926272}, {"ts": "2026-03-23T11:37:40.584Z", "acc": 4, "lat": 47.370087, "lng": 9.6907053}, {"ts": "2026-03-23T11:37:41.585Z", "acc": 4, "lat": 47.3699832, "lng": 9.6906549}, {"ts": "2026-03-23T11:37:42.581Z", "acc": 4, "lat": 47.3698797, "lng": 9.6906036}, {"ts": "2026-03-23T11:37:43.585Z", "acc": 4, "lat": 47.369776, "lng": 9.6905494}, {"ts": "2026-03-23T11:37:44.582Z", "acc": 4, "lat": 47.3696731, "lng": 9.6905012}, {"ts": "2026-03-23T11:37:45.583Z", "acc": 4, "lat": 47.3695727, "lng": 9.6904463}, {"ts": "2026-03-23T11:37:46.593Z", "acc": 4, "lat": 47.3694764, "lng": 9.6904098}, {"ts": "2026-03-23T11:37:47.588Z", "acc": 4, "lat": 47.3693861, "lng": 9.6903623}, {"ts": "2026-03-23T11:37:48.581Z", "acc": 4, "lat": 47.3692943, "lng": 9.6903169}, {"ts": "2026-03-23T11:37:49.580Z", "acc": 4, "lat": 47.369207, "lng": 9.6902778}, {"ts": "2026-03-23T11:37:50.581Z", "acc": 4, "lat": 47.3691226, "lng": 9.690233}, {"ts": "2026-03-23T11:37:51.581Z", "acc": 4, "lat": 47.3690417, "lng": 9.6901944}, {"ts": "2026-03-23T11:37:52.580Z", "acc": 4, "lat": 47.368987, "lng": 9.690163}, {"ts": "2026-03-23T11:37:53.586Z", "acc": 4, "lat": 47.3689061, "lng": 9.6901245}, {"ts": "2026-03-23T11:37:54.586Z", "acc": 4, "lat": 47.3688264, "lng": 9.6900845}, {"ts": "2026-03-23T11:37:55.590Z", "acc": 4, "lat": 47.3687476, "lng": 9.6900463}, {"ts": "2026-03-23T11:37:56.583Z", "acc": 4, "lat": 47.3686747, "lng": 9.6900057}, {"ts": "2026-03-23T11:37:57.582Z", "acc": 4, "lat": 47.3686039, "lng": 9.6899756}, {"ts": "2026-03-23T11:37:58.585Z", "acc": 4, "lat": 47.3685357, "lng": 9.6899379}, {"ts": "2026-03-23T11:37:59.583Z", "acc": 4, "lat": 47.3684493, "lng": 9.6899019}, {"ts": "2026-03-23T11:38:00.582Z", "acc": 4, "lat": 47.3683609, "lng": 9.6898605}, {"ts": "2026-03-23T11:38:01.588Z", "acc": 4, "lat": 47.368275, "lng": 9.6898181}, {"ts": "2026-03-23T11:38:02.585Z", "acc": 4, "lat": 47.3682033, "lng": 9.6897791}, {"ts": "2026-03-23T11:38:03.584Z", "acc": 4, "lat": 47.3681205, "lng": 9.689741}, {"ts": "2026-03-23T11:38:04.583Z", "acc": 4, "lat": 47.368034, "lng": 9.689696}, {"ts": "2026-03-23T11:38:05.588Z", "acc": 4, "lat": 47.3679555, "lng": 9.689655}, {"ts": "2026-03-23T11:38:06.577Z", "acc": 4, "lat": 47.3678807, "lng": 9.689613}, {"ts": "2026-03-23T11:38:07.576Z", "acc": 4, "lat": 47.3677952, "lng": 9.6895704}, {"ts": "2026-03-23T11:38:08.583Z", "acc": 4, "lat": 47.3677207, "lng": 9.689529}, {"ts": "2026-03-23T11:38:09.587Z", "acc": 4, "lat": 47.3676591, "lng": 9.6894805}, {"ts": "2026-03-23T11:38:10.584Z", "acc": 4, "lat": 47.3675933, "lng": 9.6894352}, {"ts": "2026-03-23T11:38:11.587Z", "acc": 4, "lat": 47.3675205, "lng": 9.6893951}, {"ts": "2026-03-23T11:38:12.582Z", "acc": 4, "lat": 47.3674624, "lng": 9.6893445}, {"ts": "2026-03-23T11:38:13.585Z", "acc": 4, "lat": 47.3674152, "lng": 9.6892784}, {"ts": "2026-03-23T11:38:14.580Z", "acc": 4, "lat": 47.367383, "lng": 9.6892013}, {"ts": "2026-03-23T11:38:15.585Z", "acc": 4, "lat": 47.3673621, "lng": 9.6891068}, {"ts": "2026-03-23T11:38:16.584Z", "acc": 4, "lat": 47.3673582, "lng": 9.6890117}, {"ts": "2026-03-23T11:38:17.585Z", "acc": 4, "lat": 47.3673601, "lng": 9.6889059}, {"ts": "2026-03-23T11:38:18.581Z", "acc": 4, "lat": 47.367369, "lng": 9.6888002}, {"ts": "2026-03-23T11:38:19.587Z", "acc": 4, "lat": 47.3673693, "lng": 9.6886925}, {"ts": "2026-03-23T11:38:20.583Z", "acc": 4, "lat": 47.3673732, "lng": 9.6885776}, {"ts": "2026-03-23T11:38:21.581Z", "acc": 4, "lat": 47.3673769, "lng": 9.6884616}, {"ts": "2026-03-23T11:38:22.585Z", "acc": 4, "lat": 47.3673813, "lng": 9.688347}, {"ts": "2026-03-23T11:38:23.584Z", "acc": 4, "lat": 47.367386, "lng": 9.688246}, {"ts": "2026-03-23T11:38:24.582Z", "acc": 4, "lat": 47.3673953, "lng": 9.6881625}, {"ts": "2026-03-23T11:38:25.581Z", "acc": 4, "lat": 47.3674062, "lng": 9.6880913}, {"ts": "2026-03-23T11:38:26.582Z", "acc": 4, "lat": 47.3674211, "lng": 9.6880258}, {"ts": "2026-03-23T11:38:27.581Z", "acc": 4, "lat": 47.367442, "lng": 9.687961}, {"ts": "2026-03-23T11:38:28.582Z", "acc": 4, "lat": 47.3674757, "lng": 9.6878872}, {"ts": "2026-03-23T11:38:29.588Z", "acc": 4, "lat": 47.367507, "lng": 9.6878097}, {"ts": "2026-03-23T11:38:30.583Z", "acc": 4, "lat": 47.3675462, "lng": 9.6877341}, {"ts": "2026-03-23T11:38:31.588Z", "acc": 4, "lat": 47.3675879, "lng": 9.6876701}, {"ts": "2026-03-23T11:38:32.582Z", "acc": 4, "lat": 47.3676378, "lng": 9.6876004}, {"ts": "2026-03-23T11:38:33.582Z", "acc": 4, "lat": 47.3676797, "lng": 9.6875339}, {"ts": "2026-03-23T11:38:34.583Z", "acc": 4, "lat": 47.367728, "lng": 9.6874717}, {"ts": "2026-03-23T11:38:35.584Z", "acc": 4, "lat": 47.3677784, "lng": 9.6874144}, {"ts": "2026-03-23T11:38:36.586Z", "acc": 4, "lat": 47.367817, "lng": 9.6873688}, {"ts": "2026-03-23T11:38:37.587Z", "acc": 4, "lat": 47.3678571, "lng": 9.6873249}, {"ts": "2026-03-23T11:38:38.590Z", "acc": 4, "lat": 47.3678907, "lng": 9.6872873}, {"ts": "2026-03-23T11:38:39.572Z", "acc": 5, "lat": 47.3678907, "lng": 9.6872873}, {"ts": "2026-03-23T11:38:39.575Z", "acc": 5, "lat": 47.3679133, "lng": 9.6872635}, {"ts": "2026-03-23T11:38:40.585Z", "acc": 5, "lat": 47.367922, "lng": 9.6872461}, {"ts": "2026-03-23T11:38:41.585Z", "acc": 5, "lat": 47.3679225, "lng": 9.6872443}, {"ts": "2026-03-23T11:38:42.583Z", "acc": 5, "lat": 47.3679238, "lng": 9.6872411}, {"ts": "2026-03-23T11:38:43.587Z", "acc": 5, "lat": 47.3679255, "lng": 9.6872387}, {"ts": "2026-03-23T11:38:44.576Z", "acc": 4, "lat": 47.3679262, "lng": 9.6872366}, {"ts": "2026-03-23T11:38:45.585Z", "acc": 4, "lat": 47.3679285, "lng": 9.6872349}, {"ts": "2026-03-23T11:38:46.584Z", "acc": 4, "lat": 47.3679278, "lng": 9.6872344}, {"ts": "2026-03-23T11:38:47.588Z", "acc": 4, "lat": 47.3679279, "lng": 9.6872316}, {"ts": "2026-03-23T11:38:48.584Z", "acc": 5, "lat": 47.3679274, "lng": 9.6872303}, {"ts": "2026-03-23T11:38:49.583Z", "acc": 6, "lat": 47.3679279, "lng": 9.6872301}, {"ts": "2026-03-23T11:38:50.584Z", "acc": 7, "lat": 47.3679285, "lng": 9.6872304}, {"ts": "2026-03-23T11:38:51.586Z", "acc": 9, "lat": 47.3679279, "lng": 9.6872311}, {"ts": "2026-03-23T11:38:52.581Z", "acc": 10, "lat": 47.3679271, "lng": 9.6872319}, {"ts": "2026-03-23T11:38:53.587Z", "acc": 10, "lat": 47.3679348, "lng": 9.6872215}, {"ts": "2026-03-23T11:38:54.588Z", "acc": 10, "lat": 47.3679528, "lng": 9.687199}, {"ts": "2026-03-23T11:38:55.587Z", "acc": 10, "lat": 47.3679807, "lng": 9.6871635}, {"ts": "2026-03-23T11:38:56.586Z", "acc": 10, "lat": 47.3680206, "lng": 9.6871153}, {"ts": "2026-03-23T11:38:57.596Z", "acc": 10, "lat": 47.3680681, "lng": 9.6870592}, {"ts": "2026-03-23T11:38:58.583Z", "acc": 10, "lat": 47.3681339, "lng": 9.6869905}, {"ts": "2026-03-23T11:38:59.584Z", "acc": 10, "lat": 47.3682009, "lng": 9.6869161}, {"ts": "2026-03-23T11:39:00.584Z", "acc": 10, "lat": 47.3682721, "lng": 9.6868375}, {"ts": "2026-03-23T11:39:01.589Z", "acc": 10, "lat": 47.368351, "lng": 9.6867511}, {"ts": "2026-03-23T11:39:02.590Z", "acc": 10, "lat": 47.3684376, "lng": 9.6866514}, {"ts": "2026-03-23T11:39:03.583Z", "acc": 10, "lat": 47.3685302, "lng": 9.6865504}, {"ts": "2026-03-23T11:39:04.582Z", "acc": 10, "lat": 47.3686392, "lng": 9.6864417}, {"ts": "2026-03-23T11:39:05.590Z", "acc": 10, "lat": 47.3687411, "lng": 9.686337}, {"ts": "2026-03-23T11:39:06.589Z", "acc": 10, "lat": 47.3688453, "lng": 9.6862233}, {"ts": "2026-03-23T11:39:07.582Z", "acc": 10, "lat": 47.3689522, "lng": 9.6861094}, {"ts": "2026-03-23T11:39:08.582Z", "acc": 10, "lat": 47.369058, "lng": 9.6859935}, {"ts": "2026-03-23T11:39:09.583Z", "acc": 10, "lat": 47.3691612, "lng": 9.6858802}, {"ts": "2026-03-23T11:39:10.581Z", "acc": 10, "lat": 47.3692635, "lng": 9.6857643}, {"ts": "2026-03-23T11:39:11.585Z", "acc": 10, "lat": 47.3693636, "lng": 9.6856462}, {"ts": "2026-03-23T11:39:12.586Z", "acc": 10, "lat": 47.3694589, "lng": 9.6855284}, {"ts": "2026-03-23T11:39:13.584Z", "acc": 10, "lat": 47.36955, "lng": 9.6854143}, {"ts": "2026-03-23T11:39:14.582Z", "acc": 10, "lat": 47.3696405, "lng": 9.6852956}, {"ts": "2026-03-23T11:39:15.589Z", "acc": 10, "lat": 47.3697264, "lng": 9.6851777}, {"ts": "2026-03-23T11:39:16.583Z", "acc": 10, "lat": 47.3698108, "lng": 9.6850604}, {"ts": "2026-03-23T11:39:17.590Z", "acc": 10, "lat": 47.3698934, "lng": 9.6849452}, {"ts": "2026-03-23T11:39:18.582Z", "acc": 10, "lat": 47.369977, "lng": 9.6848318}, {"ts": "2026-03-23T11:39:19.587Z", "acc": 10, "lat": 47.3700616, "lng": 9.68472}, {"ts": "2026-03-23T11:39:20.590Z", "acc": 10, "lat": 47.3701416, "lng": 9.684605}, {"ts": "2026-03-23T11:39:21.584Z", "acc": 10, "lat": 47.3702249, "lng": 9.6844866}, {"ts": "2026-03-23T11:39:22.585Z", "acc": 10, "lat": 47.3703056, "lng": 9.6843654}, {"ts": "2026-03-23T11:39:23.581Z", "acc": 10, "lat": 47.3703885, "lng": 9.6842381}, {"ts": "2026-03-23T11:39:24.585Z", "acc": 10, "lat": 47.3704723, "lng": 9.6841082}, {"ts": "2026-03-23T11:39:25.584Z", "acc": 10, "lat": 47.3705545, "lng": 9.6839752}, {"ts": "2026-03-23T11:39:26.586Z", "acc": 10, "lat": 47.3706392, "lng": 9.6838419}, {"ts": "2026-03-23T11:39:27.587Z", "acc": 10, "lat": 47.3707211, "lng": 9.6837091}, {"ts": "2026-03-23T11:39:28.584Z", "acc": 10, "lat": 47.3708033, "lng": 9.6835749}, {"ts": "2026-03-23T11:39:29.577Z", "acc": 10, "lat": 47.3708884, "lng": 9.6834378}, {"ts": "2026-03-23T11:39:30.582Z", "acc": 10, "lat": 47.3709735, "lng": 9.6832993}, {"ts": "2026-03-23T11:39:31.585Z", "acc": 10, "lat": 47.3710579, "lng": 9.6831592}, {"ts": "2026-03-23T11:39:32.579Z", "acc": 10, "lat": 47.3711444, "lng": 9.6830171}, {"ts": "2026-03-23T11:39:33.588Z", "acc": 10, "lat": 47.3712303, "lng": 9.6828708}, {"ts": "2026-03-23T11:39:34.580Z", "acc": 10, "lat": 47.3713157, "lng": 9.6827235}, {"ts": "2026-03-23T11:39:35.586Z", "acc": 10, "lat": 47.3714002, "lng": 9.6825749}, {"ts": "2026-03-23T11:39:36.585Z", "acc": 10, "lat": 47.3714863, "lng": 9.6824274}, {"ts": "2026-03-23T11:39:37.580Z", "acc": 10, "lat": 47.3715705, "lng": 9.6822776}, {"ts": "2026-03-23T11:39:38.584Z", "acc": 10, "lat": 47.3716524, "lng": 9.682129}, {"ts": "2026-03-23T11:39:39.588Z", "acc": 10, "lat": 47.3717321, "lng": 9.6819827}, {"ts": "2026-03-23T11:39:40.585Z", "acc": 10, "lat": 47.3718105, "lng": 9.6818385}, {"ts": "2026-03-23T11:39:41.589Z", "acc": 10, "lat": 47.3718884, "lng": 9.6816948}, {"ts": "2026-03-23T11:39:42.585Z", "acc": 10, "lat": 47.3719641, "lng": 9.681552}, {"ts": "2026-03-23T11:39:43.585Z", "acc": 10, "lat": 47.3720402, "lng": 9.6814078}, {"ts": "2026-03-23T11:39:44.583Z", "acc": 10, "lat": 47.3721168, "lng": 9.6812639}, {"ts": "2026-03-23T11:39:45.583Z", "acc": 10, "lat": 47.3721933, "lng": 9.6811206}, {"ts": "2026-03-23T11:39:46.583Z", "acc": 10, "lat": 47.3722697, "lng": 9.6809796}, {"ts": "2026-03-23T11:39:47.586Z", "acc": 10, "lat": 47.3723441, "lng": 9.6808412}, {"ts": "2026-03-23T11:39:48.584Z", "acc": 10, "lat": 47.372417, "lng": 9.6807035}, {"ts": "2026-03-23T11:39:49.585Z", "acc": 10, "lat": 47.3724888, "lng": 9.6805684}, {"ts": "2026-03-23T11:39:50.583Z", "acc": 10, "lat": 47.3725588, "lng": 9.6804346}, {"ts": "2026-03-23T11:39:51.580Z", "acc": 10, "lat": 47.3726284, "lng": 9.6803029}, {"ts": "2026-03-23T11:39:52.582Z", "acc": 10, "lat": 47.3726977, "lng": 9.6801723}, {"ts": "2026-03-23T11:39:53.579Z", "acc": 10, "lat": 47.372766, "lng": 9.6800426}, {"ts": "2026-03-23T11:39:54.585Z", "acc": 10, "lat": 47.3728329, "lng": 9.6799166}, {"ts": "2026-03-23T11:39:55.591Z", "acc": 10, "lat": 47.3728986, "lng": 9.679795}, {"ts": "2026-03-23T11:39:56.585Z", "acc": 10, "lat": 47.3729614, "lng": 9.67968}, {"ts": "2026-03-23T11:39:57.587Z", "acc": 10, "lat": 47.3730186, "lng": 9.6795743}, {"ts": "2026-03-23T11:39:58.587Z", "acc": 10, "lat": 47.3730683, "lng": 9.679482}, {"ts": "2026-03-23T11:39:59.582Z", "acc": 10, "lat": 47.3731084, "lng": 9.6794072}, {"ts": "2026-03-23T11:40:00.580Z", "acc": 10, "lat": 47.3731391, "lng": 9.67935}, {"ts": "2026-03-23T11:40:01.590Z", "acc": 10, "lat": 47.3731634, "lng": 9.6793047}, {"ts": "2026-03-23T11:40:02.558Z", "acc": 11, "lat": 47.3731634, "lng": 9.6793047}, {"ts": "2026-03-23T11:40:02.578Z", "acc": 11, "lat": 47.3731804, "lng": 9.6792729}, {"ts": "2026-03-23T11:40:03.585Z", "acc": 11, "lat": 47.3731887, "lng": 9.6792565}, {"ts": "2026-03-23T11:40:04.587Z", "acc": 11, "lat": 47.3731921, "lng": 9.6792508}, {"ts": "2026-03-23T11:40:05.589Z", "acc": 11, "lat": 47.373193, "lng": 9.6792488}, {"ts": "2026-03-23T11:40:06.587Z", "acc": 11, "lat": 47.3731929, "lng": 9.6792491}, {"ts": "2026-03-23T11:40:07.592Z", "acc": 9, "lat": 47.3731823, "lng": 9.6792244}, {"ts": "2026-03-23T11:40:08.585Z", "acc": 8, "lat": 47.3732103, "lng": 9.6792265}, {"ts": "2026-03-23T11:56:33.592Z", "acc": 6, "lat": 47.303153, "lng": 9.5844277}, {"ts": "2026-03-23T11:56:34.580Z", "acc": 5, "lat": 47.3031527, "lng": 9.5844329}, {"ts": "2026-03-23T11:56:35.582Z", "acc": 4, "lat": 47.3031532, "lng": 9.5844303}, {"ts": "2026-03-23T11:56:36.576Z", "acc": 4, "lat": 47.3031529, "lng": 9.5844302}, {"ts": "2026-03-23T11:57:17.715Z", "acc": 4, "lat": 47.3033999, "lng": 9.5843421}, {"ts": "2026-03-23T11:57:18.573Z", "acc": 4, "lat": 47.3033842, "lng": 9.5843423}, {"ts": "2026-03-23T11:57:19.585Z", "acc": 4, "lat": 47.3033702, "lng": 9.5843433}, {"ts": "2026-03-23T11:57:20.586Z", "acc": 4, "lat": 47.303356, "lng": 9.5843441}, {"ts": "2026-03-23T11:57:21.584Z", "acc": 4, "lat": 47.3033422, "lng": 9.5843436}, {"ts": "2026-03-23T14:11:07.570Z", "acc": 11, "lat": 47.4687354, "lng": 9.6253691}, {"ts": "2026-03-23T14:11:08.560Z", "acc": 10, "lat": 47.4687163, "lng": 9.6253534}, {"ts": "2026-03-23T14:11:09.563Z", "acc": 9, "lat": 47.4687047, "lng": 9.6253228}, {"ts": "2026-03-23T14:11:10.568Z", "acc": 8, "lat": 47.4686884, "lng": 9.6253168}]	Aufmass Sichtschutzzaun\nTel: \n+43 (69981733998	\N	abgeschlossen	\N	\N	\N	\N	2026-03-23 09:21:31.815812+00	2026-03-23 14:11:11.71804+00	0	[]	Winsaur Bernhard	\N	\N	1	\N	0.00	f	\N	\N	Rohresfeld 4a	6812	Österreich	0	[]	Meiningen	0.00	\N	120	0.00	0.00	f	\N	[]	2.000	11.00	0.0000	0.2500	60.00	40.00	35.00	55.00	\N	\N	f	montage
21	2	Hornbach	77188686	3	Stefano	2	\N	\N	\N	\N	\N	0	\N	0.00	0.00	[{"ts": "2026-03-23T08:39:03.819Z", "acc": 4, "lat": 47.4663952, "lng": 9.6286519}, {"ts": "2026-03-23T08:39:04.600Z", "acc": 4, "lat": 47.4663976, "lng": 9.6286484}, {"ts": "2026-03-23T08:39:05.596Z", "acc": 4, "lat": 47.4663987, "lng": 9.6286474}, {"ts": "2026-03-23T08:39:06.601Z", "acc": 4, "lat": 47.4663989, "lng": 9.6286466}, {"ts": "2026-03-23T08:39:07.598Z", "acc": 4, "lat": 47.4663993, "lng": 9.6286465}, {"ts": "2026-03-23T08:39:08.603Z", "acc": 4, "lat": 47.4664044, "lng": 9.6286486}, {"ts": "2026-03-23T08:39:09.597Z", "acc": 4, "lat": 47.4664111, "lng": 9.6286398}, {"ts": "2026-03-23T08:39:10.605Z", "acc": 4, "lat": 47.4664175, "lng": 9.6286299}, {"ts": "2026-03-23T08:39:10.837Z", "acc": 5, "lat": 47.4664179, "lng": 9.6286297}, {"ts": "2026-03-23T08:39:11.606Z", "acc": 5, "lat": 47.4664315, "lng": 9.6286013}, {"ts": "2026-03-23T08:39:11.968Z", "acc": 5, "lat": 47.4664425, "lng": 9.6285826}, {"ts": "2026-03-23T08:39:12.463Z", "acc": 5, "lat": 47.4664377, "lng": 9.6285903}, {"ts": "2026-03-23T08:39:12.603Z", "acc": 5, "lat": 47.4664522, "lng": 9.6285762}, {"ts": "2026-03-23T08:39:13.614Z", "acc": 5, "lat": 47.4664609, "lng": 9.6285042}, {"ts": "2026-03-23T08:39:14.605Z", "acc": 5, "lat": 47.466481, "lng": 9.6284265}, {"ts": "2026-03-23T08:39:15.605Z", "acc": 5, "lat": 47.4664921, "lng": 9.6283587}, {"ts": "2026-03-23T08:39:16.603Z", "acc": 4, "lat": 47.4664994, "lng": 9.6282809}, {"ts": "2026-03-23T08:39:17.598Z", "acc": 4, "lat": 47.46651, "lng": 9.6282006}, {"ts": "2026-03-23T08:39:18.605Z", "acc": 4, "lat": 47.4665138, "lng": 9.628114}, {"ts": "2026-03-23T08:39:19.601Z", "acc": 4, "lat": 47.4665163, "lng": 9.6280404}, {"ts": "2026-03-23T08:39:20.610Z", "acc": 4, "lat": 47.4665151, "lng": 9.6279799}, {"ts": "2026-03-23T08:39:21.602Z", "acc": 4, "lat": 47.4665055, "lng": 9.627937}, {"ts": "2026-03-23T08:39:22.600Z", "acc": 4, "lat": 47.4664958, "lng": 9.6279208}, {"ts": "2026-03-23T08:39:23.601Z", "acc": 4, "lat": 47.4664878, "lng": 9.6279171}, {"ts": "2026-03-23T08:39:24.605Z", "acc": 4, "lat": 47.4665051, "lng": 9.6278865}, {"ts": "2026-03-23T08:39:25.603Z", "acc": 4, "lat": 47.4665052, "lng": 9.6278388}, {"ts": "2026-03-23T08:39:26.071Z", "acc": 4, "lat": 47.4664994, "lng": 9.6278192}, {"ts": "2026-03-23T08:39:26.510Z", "acc": 4, "lat": 47.4664921, "lng": 9.6278041}, {"ts": "2026-03-23T08:39:26.603Z", "acc": 4, "lat": 47.4664886, "lng": 9.6278004}, {"ts": "2026-03-23T08:39:27.494Z", "acc": 4, "lat": 47.4664647, "lng": 9.6277762}, {"ts": "2026-03-23T08:39:27.601Z", "acc": 4, "lat": 47.4664574, "lng": 9.6277755}, {"ts": "2026-03-23T08:39:28.484Z", "acc": 4, "lat": 47.466453, "lng": 9.6277775}, {"ts": "2026-03-23T08:39:28.605Z", "acc": 4, "lat": 47.4663477, "lng": 9.6278955}, {"ts": "2026-03-23T08:39:29.597Z", "acc": 4, "lat": 47.466247, "lng": 9.6279581}, {"ts": "2026-03-23T08:39:30.605Z", "acc": 4, "lat": 47.4661633, "lng": 9.6279963}, {"ts": "2026-03-23T08:39:31.602Z", "acc": 4, "lat": 47.4660842, "lng": 9.6280292}, {"ts": "2026-03-23T08:39:32.604Z", "acc": 4, "lat": 47.4660022, "lng": 9.6280566}, {"ts": "2026-03-23T08:39:33.600Z", "acc": 4, "lat": 47.4659172, "lng": 9.6280839}, {"ts": "2026-03-23T08:39:34.602Z", "acc": 4, "lat": 47.4658342, "lng": 9.628107}, {"ts": "2026-03-23T08:39:35.599Z", "acc": 4, "lat": 47.4657574, "lng": 9.628134}, {"ts": "2026-03-23T08:39:36.597Z", "acc": 4, "lat": 47.4656825, "lng": 9.6281592}, {"ts": "2026-03-23T08:39:37.595Z", "acc": 4, "lat": 47.4656098, "lng": 9.6281835}, {"ts": "2026-03-23T08:39:38.604Z", "acc": 4, "lat": 47.4655342, "lng": 9.628209}, {"ts": "2026-03-23T08:39:39.600Z", "acc": 4, "lat": 47.4654553, "lng": 9.6282342}, {"ts": "2026-03-23T08:39:40.605Z", "acc": 4, "lat": 47.4653744, "lng": 9.6282588}, {"ts": "2026-03-23T08:39:41.600Z", "acc": 4, "lat": 47.4652987, "lng": 9.6282843}, {"ts": "2026-03-23T08:39:42.602Z", "acc": 4, "lat": 47.4652196, "lng": 9.628313}, {"ts": "2026-03-23T08:39:43.599Z", "acc": 4, "lat": 47.4651417, "lng": 9.6283426}, {"ts": "2026-03-23T08:39:44.598Z", "acc": 4, "lat": 47.4650686, "lng": 9.6283734}, {"ts": "2026-03-23T08:39:45.598Z", "acc": 4, "lat": 47.4649969, "lng": 9.6284035}, {"ts": "2026-03-23T08:39:46.605Z", "acc": 4, "lat": 47.4649259, "lng": 9.6284345}, {"ts": "2026-03-23T08:39:47.598Z", "acc": 4, "lat": 47.4648542, "lng": 9.6284652}, {"ts": "2026-03-23T08:39:48.601Z", "acc": 4, "lat": 47.4647806, "lng": 9.6285}, {"ts": "2026-03-23T08:39:49.609Z", "acc": 4, "lat": 47.4647032, "lng": 9.6285332}, {"ts": "2026-03-23T08:39:50.605Z", "acc": 4, "lat": 47.4646249, "lng": 9.6285655}, {"ts": "2026-03-23T08:39:51.607Z", "acc": 4, "lat": 47.4645442, "lng": 9.6285972}, {"ts": "2026-03-23T08:39:52.602Z", "acc": 4, "lat": 47.4644634, "lng": 9.628626}, {"ts": "2026-03-23T08:39:53.598Z", "acc": 4, "lat": 47.4643832, "lng": 9.6286513}, {"ts": "2026-03-23T08:39:54.606Z", "acc": 4, "lat": 47.4643017, "lng": 9.6286681}, {"ts": "2026-03-23T08:39:55.605Z", "acc": 4, "lat": 47.4642204, "lng": 9.628681}, {"ts": "2026-03-23T08:39:56.602Z", "acc": 4, "lat": 47.4641409, "lng": 9.6286936}, {"ts": "2026-03-23T08:39:57.603Z", "acc": 4, "lat": 47.4640629, "lng": 9.6286985}, {"ts": "2026-03-23T08:39:58.605Z", "acc": 4, "lat": 47.4639864, "lng": 9.6286932}, {"ts": "2026-03-23T08:39:59.609Z", "acc": 4, "lat": 47.4639133, "lng": 9.628684}, {"ts": "2026-03-23T08:40:00.602Z", "acc": 4, "lat": 47.4638431, "lng": 9.628669}, {"ts": "2026-03-23T08:40:03.502Z", "acc": 4, "lat": 47.4637294, "lng": 9.6286293}, {"ts": "2026-03-23T08:40:03.586Z", "acc": 4, "lat": 47.4637209, "lng": 9.6286163}, {"ts": "2026-03-23T08:40:04.239Z", "acc": 14, "lat": 47.4637064, "lng": 9.6286058}, {"ts": "2026-03-23T08:40:04.607Z", "acc": 13, "lat": 47.4637073, "lng": 9.6286107}, {"ts": "2026-03-23T08:40:05.605Z", "acc": 14, "lat": 47.4637083, "lng": 9.628613}, {"ts": "2026-03-23T08:40:06.605Z", "acc": 14, "lat": 47.4637096, "lng": 9.6286158}, {"ts": "2026-03-23T08:40:07.596Z", "acc": 13, "lat": 47.4637094, "lng": 9.6286166}, {"ts": "2026-03-23T08:40:08.601Z", "acc": 15, "lat": 47.463702, "lng": 9.6286147}, {"ts": "2026-03-23T08:40:09.603Z", "acc": 7, "lat": 47.4636874, "lng": 9.6286105}, {"ts": "2026-03-23T08:40:10.607Z", "acc": 8, "lat": 47.4636715, "lng": 9.6286042}, {"ts": "2026-03-23T08:40:11.368Z", "acc": 8, "lat": 47.4636695, "lng": 9.6286028}, {"ts": "2026-03-23T08:40:11.600Z", "acc": 8, "lat": 47.4636489, "lng": 9.6285985}, {"ts": "2026-03-23T08:40:12.604Z", "acc": 9, "lat": 47.4636263, "lng": 9.6285951}, {"ts": "2026-03-23T08:40:13.600Z", "acc": 10, "lat": 47.4635873, "lng": 9.6285975}, {"ts": "2026-03-23T08:40:14.525Z", "acc": 10, "lat": 47.46355, "lng": 9.6286046}, {"ts": "2026-03-23T08:40:15.611Z", "acc": 9, "lat": 47.4635064, "lng": 9.6287155}, {"ts": "2026-03-23T08:40:16.604Z", "acc": 9, "lat": 47.4634717, "lng": 9.6287975}, {"ts": "2026-03-23T08:40:17.603Z", "acc": 8, "lat": 47.4634281, "lng": 9.6288968}, {"ts": "2026-03-23T08:40:18.607Z", "acc": 7, "lat": 47.4633795, "lng": 9.629007}, {"ts": "2026-03-23T08:40:19.605Z", "acc": 4, "lat": 47.4633306, "lng": 9.6291205}, {"ts": "2026-03-23T08:40:20.606Z", "acc": 4, "lat": 47.4632784, "lng": 9.6292423}, {"ts": "2026-03-23T08:40:21.595Z", "acc": 4, "lat": 47.4632186, "lng": 9.629375}, {"ts": "2026-03-23T08:40:22.602Z", "acc": 4, "lat": 47.4631533, "lng": 9.6295031}, {"ts": "2026-03-23T08:40:23.595Z", "acc": 4, "lat": 47.4630764, "lng": 9.6296202}, {"ts": "2026-03-23T08:40:24.598Z", "acc": 4, "lat": 47.4629914, "lng": 9.6297169}, {"ts": "2026-03-23T08:40:25.599Z", "acc": 4, "lat": 47.4629069, "lng": 9.6297967}, {"ts": "2026-03-23T08:40:26.604Z", "acc": 4, "lat": 47.4628219, "lng": 9.6298716}, {"ts": "2026-03-23T08:40:27.600Z", "acc": 4, "lat": 47.4627423, "lng": 9.6299432}, {"ts": "2026-03-23T08:40:28.600Z", "acc": 4, "lat": 47.4626621, "lng": 9.6300139}, {"ts": "2026-03-23T08:40:29.596Z", "acc": 4, "lat": 47.4625778, "lng": 9.6300857}, {"ts": "2026-03-23T08:40:30.599Z", "acc": 4, "lat": 47.4624879, "lng": 9.6301617}, {"ts": "2026-03-23T08:40:31.595Z", "acc": 4, "lat": 47.4623971, "lng": 9.6302394}, {"ts": "2026-03-23T08:40:32.602Z", "acc": 4, "lat": 47.4623008, "lng": 9.6303177}, {"ts": "2026-03-23T08:40:33.593Z", "acc": 4, "lat": 47.4622026, "lng": 9.6304009}, {"ts": "2026-03-23T08:40:34.595Z", "acc": 4, "lat": 47.4621018, "lng": 9.6304861}, {"ts": "2026-03-23T08:40:35.593Z", "acc": 4, "lat": 47.4620018, "lng": 9.6305753}, {"ts": "2026-03-23T08:40:36.597Z", "acc": 4, "lat": 47.4619012, "lng": 9.6306663}, {"ts": "2026-03-23T08:40:37.596Z", "acc": 4, "lat": 47.4617993, "lng": 9.6307528}, {"ts": "2026-03-23T08:40:38.598Z", "acc": 4, "lat": 47.4616928, "lng": 9.6308451}, {"ts": "2026-03-23T08:40:39.604Z", "acc": 4, "lat": 47.4615863, "lng": 9.6309353}, {"ts": "2026-03-23T08:40:40.600Z", "acc": 4, "lat": 47.4614806, "lng": 9.6310236}, {"ts": "2026-03-23T08:40:41.592Z", "acc": 4, "lat": 47.4613763, "lng": 9.6311097}, {"ts": "2026-03-23T08:40:42.593Z", "acc": 4, "lat": 47.4612729, "lng": 9.6311972}, {"ts": "2026-03-23T08:40:43.596Z", "acc": 4, "lat": 47.4611696, "lng": 9.6312838}, {"ts": "2026-03-23T08:40:44.597Z", "acc": 4, "lat": 47.4610718, "lng": 9.6313774}, {"ts": "2026-03-23T08:40:45.604Z", "acc": 4, "lat": 47.4609749, "lng": 9.6314657}, {"ts": "2026-03-23T08:40:46.597Z", "acc": 4, "lat": 47.4608816, "lng": 9.6315571}, {"ts": "2026-03-23T08:40:47.595Z", "acc": 4, "lat": 47.4607931, "lng": 9.6316479}, {"ts": "2026-03-23T08:40:48.598Z", "acc": 4, "lat": 47.4607084, "lng": 9.6317365}, {"ts": "2026-03-23T08:40:49.594Z", "acc": 4, "lat": 47.4606225, "lng": 9.6318194}, {"ts": "2026-03-23T08:40:50.601Z", "acc": 4, "lat": 47.4605341, "lng": 9.6318929}, {"ts": "2026-03-23T08:40:51.600Z", "acc": 4, "lat": 47.4604392, "lng": 9.6319575}, {"ts": "2026-03-23T08:40:52.593Z", "acc": 4, "lat": 47.460339, "lng": 9.6320031}, {"ts": "2026-03-23T08:40:53.596Z", "acc": 4, "lat": 47.460236, "lng": 9.6320426}, {"ts": "2026-03-23T08:40:54.603Z", "acc": 4, "lat": 47.4601349, "lng": 9.6320819}, {"ts": "2026-03-23T08:40:55.602Z", "acc": 4, "lat": 47.4600346, "lng": 9.6321376}, {"ts": "2026-03-23T08:40:56.600Z", "acc": 4, "lat": 47.4599358, "lng": 9.6322094}, {"ts": "2026-03-23T08:40:57.593Z", "acc": 4, "lat": 47.4598429, "lng": 9.6322969}, {"ts": "2026-03-23T08:40:58.599Z", "acc": 4, "lat": 47.4597503, "lng": 9.6324053}, {"ts": "2026-03-23T08:40:59.597Z", "acc": 4, "lat": 47.4596704, "lng": 9.6325311}, {"ts": "2026-03-23T08:41:00.602Z", "acc": 4, "lat": 47.4596039, "lng": 9.6326675}, {"ts": "2026-03-23T08:41:01.594Z", "acc": 4, "lat": 47.4595421, "lng": 9.6328154}, {"ts": "2026-03-23T08:41:02.603Z", "acc": 4, "lat": 47.4594903, "lng": 9.6329743}, {"ts": "2026-03-23T08:41:03.597Z", "acc": 4, "lat": 47.4594452, "lng": 9.6331192}, {"ts": "2026-03-23T08:41:04.598Z", "acc": 5, "lat": 47.4594077, "lng": 9.6332859}, {"ts": "2026-03-23T08:41:05.606Z", "acc": 6, "lat": 47.4593742, "lng": 9.6334635}, {"ts": "2026-03-23T08:41:06.601Z", "acc": 7, "lat": 47.4593454, "lng": 9.6336321}, {"ts": "2026-03-23T08:41:07.600Z", "acc": 8, "lat": 47.4593242, "lng": 9.6337993}, {"ts": "2026-03-23T08:41:08.601Z", "acc": 9, "lat": 47.4593062, "lng": 9.6339674}, {"ts": "2026-03-23T08:41:09.607Z", "acc": 9, "lat": 47.4592977, "lng": 9.6341309}, {"ts": "2026-03-23T08:41:10.597Z", "acc": 8, "lat": 47.4592869, "lng": 9.6343041}, {"ts": "2026-03-23T08:41:11.598Z", "acc": 6, "lat": 47.4592834, "lng": 9.6344612}, {"ts": "2026-03-23T08:41:12.598Z", "acc": 5, "lat": 47.4592784, "lng": 9.6346195}, {"ts": "2026-03-23T08:41:13.595Z", "acc": 4, "lat": 47.4592748, "lng": 9.6347707}, {"ts": "2026-03-23T08:41:14.599Z", "acc": 4, "lat": 47.459274, "lng": 9.6349167}, {"ts": "2026-03-23T08:41:15.590Z", "acc": 4, "lat": 47.4592726, "lng": 9.6350596}, {"ts": "2026-03-23T08:41:16.595Z", "acc": 4, "lat": 47.4592713, "lng": 9.6351986}, {"ts": "2026-03-23T08:41:17.606Z", "acc": 4, "lat": 47.4592674, "lng": 9.6353382}, {"ts": "2026-03-23T08:41:18.594Z", "acc": 4, "lat": 47.4592712, "lng": 9.6354846}, {"ts": "2026-03-23T08:41:19.596Z", "acc": 4, "lat": 47.4592833, "lng": 9.6356309}, {"ts": "2026-03-23T08:41:20.593Z", "acc": 4, "lat": 47.4593043, "lng": 9.6357822}, {"ts": "2026-03-23T08:41:21.598Z", "acc": 4, "lat": 47.4593291, "lng": 9.6359356}, {"ts": "2026-03-23T08:41:22.599Z", "acc": 4, "lat": 47.4593614, "lng": 9.6360875}, {"ts": "2026-03-23T08:41:23.596Z", "acc": 4, "lat": 47.459396, "lng": 9.6362425}, {"ts": "2026-03-23T08:41:24.601Z", "acc": 4, "lat": 47.4594291, "lng": 9.6363898}, {"ts": "2026-03-23T08:41:25.595Z", "acc": 4, "lat": 47.459461, "lng": 9.6365459}, {"ts": "2026-03-23T08:41:26.600Z", "acc": 4, "lat": 47.4594971, "lng": 9.6366957}, {"ts": "2026-03-23T08:41:27.592Z", "acc": 4, "lat": 47.4595305, "lng": 9.6368464}, {"ts": "2026-03-23T08:41:28.597Z", "acc": 4, "lat": 47.4595674, "lng": 9.6369873}, {"ts": "2026-03-23T08:41:29.599Z", "acc": 4, "lat": 47.4596033, "lng": 9.6371252}, {"ts": "2026-03-23T08:49:56.681Z", "acc": 58, "lat": 47.4787603, "lng": 9.6570928}, {"ts": "2026-03-23T08:49:57.604Z", "acc": 4, "lat": 47.4787609, "lng": 9.6570927}, {"ts": "2026-03-23T08:49:58.601Z", "acc": 4, "lat": 47.4787614, "lng": 9.6570924}, {"ts": "2026-03-23T08:49:59.601Z", "acc": 4, "lat": 47.4787627, "lng": 9.6570965}, {"ts": "2026-03-23T08:50:00.615Z", "acc": 4, "lat": 47.4787642, "lng": 9.6571035}, {"ts": "2026-03-23T08:50:01.595Z", "acc": 4, "lat": 47.4787643, "lng": 9.6571066}, {"ts": "2026-03-23T08:50:02.586Z", "acc": 4, "lat": 47.4787643, "lng": 9.6571066}, {"ts": "2026-03-23T08:50:03.595Z", "acc": 4, "lat": 47.4787643, "lng": 9.6571061}, {"ts": "2026-03-23T08:50:04.601Z", "acc": 4, "lat": 47.4787644, "lng": 9.6571059}, {"ts": "2026-03-23T08:50:05.598Z", "acc": 4, "lat": 47.4787642, "lng": 9.6571066}, {"ts": "2026-03-23T08:50:06.604Z", "acc": 4, "lat": 47.4787638, "lng": 9.6571071}, {"ts": "2026-03-23T08:50:07.604Z", "acc": 4, "lat": 47.4787636, "lng": 9.6571076}, {"ts": "2026-03-23T08:50:08.596Z", "acc": 4, "lat": 47.4787633, "lng": 9.6571076}, {"ts": "2026-03-23T08:50:09.596Z", "acc": 4, "lat": 47.4787633, "lng": 9.6571071}, {"ts": "2026-03-23T08:50:10.597Z", "acc": 4, "lat": 47.4787631, "lng": 9.6571069}, {"ts": "2026-03-23T08:50:11.593Z", "acc": 4, "lat": 47.4787632, "lng": 9.6571069}, {"ts": "2026-03-23T08:50:12.587Z", "acc": 4, "lat": 47.4787629, "lng": 9.6571069}, {"ts": "2026-03-23T08:50:13.598Z", "acc": 4, "lat": 47.4787628, "lng": 9.6571069}, {"ts": "2026-03-23T08:50:14.601Z", "acc": 4, "lat": 47.4787625, "lng": 9.6571068}, {"ts": "2026-03-23T09:22:32.605Z", "acc": 4, "lat": 47.4782138, "lng": 9.6568504}, {"ts": "2026-03-23T09:22:33.603Z", "acc": 4, "lat": 47.4781708, "lng": 9.656861}, {"ts": "2026-03-23T09:22:33.603Z", "acc": 4, "lat": 47.4781708, "lng": 9.656861}, {"ts": "2026-03-23T09:22:33.603Z", "acc": 4, "lat": 47.4781708, "lng": 9.656861}, {"ts": "2026-03-23T09:22:34.596Z", "acc": 4, "lat": 47.4781281, "lng": 9.6568685}, {"ts": "2026-03-23T09:22:34.597Z", "acc": 4, "lat": 47.4781281, "lng": 9.6568685}, {"ts": "2026-03-23T09:22:34.597Z", "acc": 4, "lat": 47.4781281, "lng": 9.6568685}, {"ts": "2026-03-23T09:22:35.601Z", "acc": 4, "lat": 47.4780815, "lng": 9.6568786}, {"ts": "2026-03-23T09:22:35.602Z", "acc": 4, "lat": 47.4780815, "lng": 9.6568786}, {"ts": "2026-03-23T09:22:35.602Z", "acc": 4, "lat": 47.4780815, "lng": 9.6568786}, {"ts": "2026-03-23T09:22:36.600Z", "acc": 4, "lat": 47.4780315, "lng": 9.6568786}, {"ts": "2026-03-23T09:22:36.601Z", "acc": 4, "lat": 47.4780315, "lng": 9.6568786}, {"ts": "2026-03-23T09:22:36.601Z", "acc": 4, "lat": 47.4780315, "lng": 9.6568786}, {"ts": "2026-03-23T09:22:37.605Z", "acc": 4, "lat": 47.4779752, "lng": 9.6568694}, {"ts": "2026-03-23T09:22:37.605Z", "acc": 4, "lat": 47.4779752, "lng": 9.6568694}, {"ts": "2026-03-23T09:22:37.605Z", "acc": 4, "lat": 47.4779752, "lng": 9.6568694}, {"ts": "2026-03-23T09:22:38.597Z", "acc": 4, "lat": 47.4779289, "lng": 9.6568393}, {"ts": "2026-03-23T09:22:38.597Z", "acc": 4, "lat": 47.4779289, "lng": 9.6568393}, {"ts": "2026-03-23T09:22:38.597Z", "acc": 4, "lat": 47.4779289, "lng": 9.6568393}, {"ts": "2026-03-23T09:22:39.604Z", "acc": 4, "lat": 47.4778884, "lng": 9.6567895}, {"ts": "2026-03-23T09:22:39.604Z", "acc": 4, "lat": 47.4778884, "lng": 9.6567895}, {"ts": "2026-03-23T09:22:39.604Z", "acc": 4, "lat": 47.4778884, "lng": 9.6567895}, {"ts": "2026-03-23T09:22:40.600Z", "acc": 4, "lat": 47.4778592, "lng": 9.6567227}, {"ts": "2026-03-23T09:22:40.600Z", "acc": 4, "lat": 47.4778592, "lng": 9.6567227}, {"ts": "2026-03-23T09:22:40.600Z", "acc": 4, "lat": 47.4778592, "lng": 9.6567227}, {"ts": "2026-03-23T09:22:41.596Z", "acc": 4, "lat": 47.4778389, "lng": 9.6566431}, {"ts": "2026-03-23T09:22:41.596Z", "acc": 4, "lat": 47.4778389, "lng": 9.6566431}, {"ts": "2026-03-23T09:22:41.596Z", "acc": 4, "lat": 47.4778389, "lng": 9.6566431}, {"ts": "2026-03-23T09:22:42.597Z", "acc": 4, "lat": 47.4778194, "lng": 9.6565455}, {"ts": "2026-03-23T09:22:42.598Z", "acc": 4, "lat": 47.4778194, "lng": 9.6565455}, {"ts": "2026-03-23T09:22:42.598Z", "acc": 4, "lat": 47.4778194, "lng": 9.6565455}, {"ts": "2026-03-23T09:22:43.598Z", "acc": 4, "lat": 47.4777944, "lng": 9.6564401}, {"ts": "2026-03-23T09:22:43.598Z", "acc": 4, "lat": 47.4777944, "lng": 9.6564401}, {"ts": "2026-03-23T09:22:43.598Z", "acc": 4, "lat": 47.4777944, "lng": 9.6564401}, {"ts": "2026-03-23T09:22:44.598Z", "acc": 4, "lat": 47.4777624, "lng": 9.6563467}, {"ts": "2026-03-23T09:22:44.598Z", "acc": 4, "lat": 47.4777624, "lng": 9.6563467}, {"ts": "2026-03-23T09:22:44.598Z", "acc": 4, "lat": 47.4777624, "lng": 9.6563467}, {"ts": "2026-03-23T09:22:45.602Z", "acc": 4, "lat": 47.4777323, "lng": 9.6562441}, {"ts": "2026-03-23T09:22:45.602Z", "acc": 4, "lat": 47.4777323, "lng": 9.6562441}, {"ts": "2026-03-23T09:22:45.602Z", "acc": 4, "lat": 47.4777323, "lng": 9.6562441}, {"ts": "2026-03-23T09:22:46.594Z", "acc": 4, "lat": 47.4776921, "lng": 9.6561351}, {"ts": "2026-03-23T09:22:46.595Z", "acc": 4, "lat": 47.4776921, "lng": 9.6561351}, {"ts": "2026-03-23T09:22:46.595Z", "acc": 4, "lat": 47.4776921, "lng": 9.6561351}, {"ts": "2026-03-23T09:22:47.596Z", "acc": 4, "lat": 47.4776459, "lng": 9.6560221}, {"ts": "2026-03-23T09:22:47.596Z", "acc": 4, "lat": 47.4776459, "lng": 9.6560221}, {"ts": "2026-03-23T09:22:47.596Z", "acc": 4, "lat": 47.4776459, "lng": 9.6560221}, {"ts": "2026-03-23T09:22:48.597Z", "acc": 4, "lat": 47.4776034, "lng": 9.655908}, {"ts": "2026-03-23T09:22:48.597Z", "acc": 4, "lat": 47.4776034, "lng": 9.655908}, {"ts": "2026-03-23T09:22:48.597Z", "acc": 4, "lat": 47.4776034, "lng": 9.655908}, {"ts": "2026-03-23T09:22:49.599Z", "acc": 4, "lat": 47.4775597, "lng": 9.6557971}, {"ts": "2026-03-23T09:22:49.599Z", "acc": 4, "lat": 47.4775597, "lng": 9.6557971}, {"ts": "2026-03-23T09:22:49.599Z", "acc": 4, "lat": 47.4775597, "lng": 9.6557971}, {"ts": "2026-03-23T09:22:50.598Z", "acc": 4, "lat": 47.477516, "lng": 9.6556855}, {"ts": "2026-03-23T09:22:50.599Z", "acc": 4, "lat": 47.477516, "lng": 9.6556855}, {"ts": "2026-03-23T09:22:50.599Z", "acc": 4, "lat": 47.477516, "lng": 9.6556855}, {"ts": "2026-03-23T09:22:51.588Z", "acc": 4, "lat": 47.4774729, "lng": 9.6555725}, {"ts": "2026-03-23T09:22:51.589Z", "acc": 4, "lat": 47.4774729, "lng": 9.6555725}, {"ts": "2026-03-23T09:22:51.589Z", "acc": 4, "lat": 47.4774729, "lng": 9.6555725}, {"ts": "2026-03-23T09:22:52.592Z", "acc": 4, "lat": 47.4774293, "lng": 9.6554589}, {"ts": "2026-03-23T09:22:52.592Z", "acc": 4, "lat": 47.4774293, "lng": 9.6554589}, {"ts": "2026-03-23T09:22:52.592Z", "acc": 4, "lat": 47.4774293, "lng": 9.6554589}, {"ts": "2026-03-23T09:22:53.590Z", "acc": 4, "lat": 47.4773835, "lng": 9.6553455}, {"ts": "2026-03-23T09:22:53.591Z", "acc": 4, "lat": 47.4773835, "lng": 9.6553455}, {"ts": "2026-03-23T09:22:53.591Z", "acc": 4, "lat": 47.4773835, "lng": 9.6553455}, {"ts": "2026-03-23T09:22:54.598Z", "acc": 4, "lat": 47.4773401, "lng": 9.6552318}, {"ts": "2026-03-23T09:22:54.599Z", "acc": 4, "lat": 47.4773401, "lng": 9.6552318}, {"ts": "2026-03-23T09:22:54.599Z", "acc": 4, "lat": 47.4773401, "lng": 9.6552318}, {"ts": "2026-03-23T09:22:55.603Z", "acc": 4, "lat": 47.4772941, "lng": 9.6551182}, {"ts": "2026-03-23T09:22:55.603Z", "acc": 4, "lat": 47.4772941, "lng": 9.6551182}, {"ts": "2026-03-23T09:22:55.603Z", "acc": 4, "lat": 47.4772941, "lng": 9.6551182}, {"ts": "2026-03-23T09:22:56.598Z", "acc": 4, "lat": 47.4772491, "lng": 9.6550044}, {"ts": "2026-03-23T09:22:56.599Z", "acc": 4, "lat": 47.4772491, "lng": 9.6550044}, {"ts": "2026-03-23T09:22:56.599Z", "acc": 4, "lat": 47.4772491, "lng": 9.6550044}, {"ts": "2026-03-23T09:22:57.598Z", "acc": 4, "lat": 47.4772033, "lng": 9.6548923}, {"ts": "2026-03-23T09:22:57.598Z", "acc": 4, "lat": 47.4772033, "lng": 9.6548923}, {"ts": "2026-03-23T09:22:57.599Z", "acc": 4, "lat": 47.4772033, "lng": 9.6548923}, {"ts": "2026-03-23T09:22:58.597Z", "acc": 4, "lat": 47.4771575, "lng": 9.6547779}, {"ts": "2026-03-23T09:22:58.597Z", "acc": 4, "lat": 47.4771575, "lng": 9.6547779}, {"ts": "2026-03-23T09:22:58.597Z", "acc": 4, "lat": 47.4771575, "lng": 9.6547779}, {"ts": "2026-03-23T09:22:59.600Z", "acc": 4, "lat": 47.4771128, "lng": 9.6546614}, {"ts": "2026-03-23T09:22:59.600Z", "acc": 4, "lat": 47.4771128, "lng": 9.6546614}, {"ts": "2026-03-23T09:22:59.600Z", "acc": 4, "lat": 47.4771128, "lng": 9.6546614}, {"ts": "2026-03-23T09:23:00.595Z", "acc": 4, "lat": 47.4770688, "lng": 9.6545432}, {"ts": "2026-03-23T09:23:00.595Z", "acc": 4, "lat": 47.4770688, "lng": 9.6545432}, {"ts": "2026-03-23T09:23:00.595Z", "acc": 4, "lat": 47.4770688, "lng": 9.6545432}, {"ts": "2026-03-23T09:23:01.601Z", "acc": 4, "lat": 47.4770221, "lng": 9.6544226}, {"ts": "2026-03-23T09:23:01.602Z", "acc": 4, "lat": 47.4770221, "lng": 9.6544226}, {"ts": "2026-03-23T09:23:01.602Z", "acc": 4, "lat": 47.4770221, "lng": 9.6544226}, {"ts": "2026-03-23T09:23:02.593Z", "acc": 4, "lat": 47.4769752, "lng": 9.6543032}, {"ts": "2026-03-23T09:23:02.593Z", "acc": 4, "lat": 47.4769752, "lng": 9.6543032}, {"ts": "2026-03-23T09:23:02.593Z", "acc": 4, "lat": 47.4769752, "lng": 9.6543032}, {"ts": "2026-03-23T09:30:55.499Z", "acc": 5, "lat": 47.4683937, "lng": 9.6255512}, {"ts": "2026-03-23T09:30:55.499Z", "acc": 5, "lat": 47.4683937, "lng": 9.6255512}, {"ts": "2026-03-23T09:30:55.499Z", "acc": 5, "lat": 47.4683937, "lng": 9.6255512}, {"ts": "2026-03-23T09:30:55.586Z", "acc": 5, "lat": 47.4683935, "lng": 9.625553}, {"ts": "2026-03-23T09:30:55.587Z", "acc": 5, "lat": 47.4683935, "lng": 9.625553}, {"ts": "2026-03-23T09:30:55.587Z", "acc": 5, "lat": 47.4683935, "lng": 9.625553}, {"ts": "2026-03-23T09:30:56.589Z", "acc": 4, "lat": 47.4684002, "lng": 9.6255374}, {"ts": "2026-03-23T09:30:56.589Z", "acc": 4, "lat": 47.4684002, "lng": 9.6255374}, {"ts": "2026-03-23T09:30:56.589Z", "acc": 4, "lat": 47.4684002, "lng": 9.6255374}, {"ts": "2026-03-23T09:30:57.592Z", "acc": 4, "lat": 47.4684031, "lng": 9.6255301}, {"ts": "2026-03-23T09:30:57.592Z", "acc": 4, "lat": 47.4684031, "lng": 9.6255301}, {"ts": "2026-03-23T09:30:57.592Z", "acc": 4, "lat": 47.4684031, "lng": 9.6255301}, {"ts": "2026-03-23T09:30:58.589Z", "acc": 4, "lat": 47.4684555, "lng": 9.6254488}, {"ts": "2026-03-23T09:30:58.590Z", "acc": 4, "lat": 47.4684555, "lng": 9.6254488}, {"ts": "2026-03-23T09:30:58.590Z", "acc": 4, "lat": 47.4684555, "lng": 9.6254488}, {"ts": "2026-03-23T09:30:59.588Z", "acc": 4, "lat": 47.4684533, "lng": 9.6254469}, {"ts": "2026-03-23T09:30:59.588Z", "acc": 4, "lat": 47.4684533, "lng": 9.6254469}, {"ts": "2026-03-23T09:30:59.589Z", "acc": 4, "lat": 47.4684533, "lng": 9.6254469}, {"ts": "2026-03-23T09:31:00.587Z", "acc": 4, "lat": 47.468448, "lng": 9.6254469}, {"ts": "2026-03-23T09:31:00.587Z", "acc": 4, "lat": 47.468448, "lng": 9.6254469}, {"ts": "2026-03-23T09:31:00.588Z", "acc": 4, "lat": 47.468448, "lng": 9.6254469}, {"ts": "2026-03-23T09:31:01.597Z", "acc": 4, "lat": 47.4684443, "lng": 9.62545}, {"ts": "2026-03-23T09:31:01.597Z", "acc": 4, "lat": 47.4684443, "lng": 9.62545}, {"ts": "2026-03-23T09:31:01.597Z", "acc": 4, "lat": 47.4684443, "lng": 9.62545}, {"ts": "2026-03-23T09:31:02.593Z", "acc": 4, "lat": 47.468442, "lng": 9.6254512}, {"ts": "2026-03-23T09:31:02.594Z", "acc": 4, "lat": 47.468442, "lng": 9.6254512}, {"ts": "2026-03-23T09:31:02.594Z", "acc": 4, "lat": 47.468442, "lng": 9.6254512}, {"ts": "2026-03-23T09:31:03.590Z", "acc": 4, "lat": 47.4684405, "lng": 9.6254528}, {"ts": "2026-03-23T09:31:03.591Z", "acc": 4, "lat": 47.4684405, "lng": 9.6254528}, {"ts": "2026-03-23T09:31:03.591Z", "acc": 4, "lat": 47.4684405, "lng": 9.6254528}]	Aufmass Senkrechtmarkise Soluna Sonderbestellung\nTel: 069918101215	\N	geplant	\N	\N	\N	\N	2026-03-20 07:11:37.25436+00	\N	0	[]	Hochenburger	\N	\N	1	\N	0.00	f	\N	\N	Herrenfeld 17b	6972	Österreich	0	[]	Fussach	0.00	\N	120	0.00	0.00	f	\N	[{"datum": "2026-03-23", "km_hin": 5.4, "km_zurueck": 5.4, "fahrt_start": "2026-03-23T08:39:04.004Z", "km_verbindung": 0, "arbeitszeit_min": 25, "fahrzeit_hin_min": 11, "anzahl_mitarbeiter": 2, "fahrzeit_zurueck_min": 16}]	2.000	11.00	0.0000	0.2500	60.00	40.00	35.00	55.00	\N	\N	f	montage
31	3	Blank	12345	8	Michi	2	\N	\N	\N	\N	0	0	0	0.00	0.00	[]	\N	\N	geplant	\N	\N	\N	\N	2026-03-23 15:32:43.567553+00	\N	0	[]	Test	\N	\N	1	\N	0.00	f	\N	2026-03-23	\N	\N	Österreich	0	[]	\N	0.00	16:32:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	06644183088	office@solano.co.at	f	montage
19	2	Hornbach	77177670	3	Stefano	2	\N	\N	\N	\N	0	0	0	0.00	0.00	[]	Tel: 06504407701	\N	geplant	\N	\N	\N	\N	2026-03-18 17:36:09.72653+00	\N	0	[]	Karoline Manser	\N	\N	1	\N	0.00	f	\N	2026-04-09	Müllerstrasse 3b	6850	Österreich	0	[]	Dornbirn	0.00	08:00:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
17	2	Hornbach	77188252	3	Stefano	2	2026-03-23 11:17:19.605889+00	2026-03-23 11:32:31.826148+00	2026-03-23 11:32:36.747307+00	2026-03-23 11:32:44.386608+00	15	0	0	2.00	15.00	[{"ts": "2026-03-23T11:32:23.268Z", "acc": 44, "lat": 47.3721266, "lng": 9.6925239}, {"ts": "2026-03-23T11:32:24.595Z", "acc": 26, "lat": 47.3723202, "lng": 9.6926085}, {"ts": "2026-03-23T11:32:25.589Z", "acc": 19, "lat": 47.372308, "lng": 9.6925857}, {"ts": "2026-03-23T11:32:26.587Z", "acc": 16, "lat": 47.3721929, "lng": 9.69266}, {"ts": "2026-03-23T11:32:27.585Z", "acc": 14, "lat": 47.3722129, "lng": 9.6926113}, {"ts": "2026-03-23T11:32:28.587Z", "acc": 6, "lat": 47.3722231, "lng": 9.6925954}, {"ts": "2026-03-23T11:32:29.584Z", "acc": 5, "lat": 47.3722283, "lng": 9.6925523}, {"ts": "2026-03-23T11:32:30.590Z", "acc": 5, "lat": 47.3722195, "lng": 9.6925309}, {"ts": "2026-03-23T11:32:38.591Z", "acc": 5, "lat": 47.3722249, "lng": 9.6924927}, {"ts": "2026-03-23T11:32:39.588Z", "acc": 4, "lat": 47.3722267, "lng": 9.6924818}, {"ts": "2026-03-23T11:32:40.588Z", "acc": 5, "lat": 47.3723284, "lng": 9.6926772}, {"ts": "2026-03-23T11:32:41.581Z", "acc": 5, "lat": 47.3723206, "lng": 9.692586}, {"ts": "2026-03-23T11:32:42.588Z", "acc": 5, "lat": 47.3723216, "lng": 9.6925511}, {"ts": "2026-03-23T11:32:43.587Z", "acc": 5, "lat": 47.3723101, "lng": 9.6925383}]	noch kein Termin!!!\nAufmass Kassettenmarkise Catania 6x3 Artnr. 10468370\nTel: 066488205339  Email: maxguenther90@gmail.com	\N	abgeschlossen	\N	\N	\N	\N	2026-03-18 17:32:48.658077+00	2026-03-23 11:32:44.386608+00	0	[]	Max Günther	\N	\N	1	\N	0.00	f	\N	2026-03-23	Radezkystrasse 59/1	6845	Österreich	0	[]	Hohenems	0.00	12:15:00	120	0.00	0.00	f	\N	[]	2.000	11.00	0.0000	0.2500	60.00	40.00	35.00	55.00	\N	\N	f	montage
13	1	Heim & Haus	860214	3	Stefano	2	2026-03-20 08:40:25.043667+00	2026-03-20 08:59:47.110298+00	2026-03-20 10:43:41.975118+00	2026-03-20 10:43:57.274+00	19	104	0	9.00	0.00	[{"ts": "2026-03-20T08:40:24.924Z", "acc": 4, "lat": 47.468393, "lng": 9.6254962}, {"ts": "2026-03-20T08:40:25.449Z", "acc": 4, "lat": 47.4684999, "lng": 9.625479}, {"ts": "2026-03-20T08:40:26.448Z", "acc": 4, "lat": 47.4684793, "lng": 9.6254825}, {"ts": "2026-03-20T08:59:26.777Z", "acc": 20, "lat": 47.4812427, "lng": 9.7299199}, {"ts": "2026-03-20T08:59:27.444Z", "acc": 20, "lat": 47.4812422, "lng": 9.7299225}, {"ts": "2026-03-20T08:59:28.443Z", "acc": 16, "lat": 47.4812413, "lng": 9.729925}, {"ts": "2026-03-20T08:59:29.446Z", "acc": 4, "lat": 47.4812419, "lng": 9.7299257}, {"ts": "2026-03-20T08:59:30.449Z", "acc": 4, "lat": 47.4812425, "lng": 9.7299255}, {"ts": "2026-03-20T08:59:31.445Z", "acc": 4, "lat": 47.4812429, "lng": 9.7299266}, {"ts": "2026-03-20T08:59:32.445Z", "acc": 4, "lat": 47.4812439, "lng": 9.7299293}, {"ts": "2026-03-20T08:59:33.452Z", "acc": 4, "lat": 47.4812445, "lng": 9.7299318}, {"ts": "2026-03-20T08:59:34.448Z", "acc": 4, "lat": 47.4812449, "lng": 9.7299316}, {"ts": "2026-03-20T08:59:35.451Z", "acc": 4, "lat": 47.4812455, "lng": 9.7299315}, {"ts": "2026-03-20T08:59:36.452Z", "acc": 4, "lat": 47.4812458, "lng": 9.7299312}, {"ts": "2026-03-20T08:59:37.449Z", "acc": 4, "lat": 47.4812455, "lng": 9.7299314}, {"ts": "2026-03-20T08:59:38.442Z", "acc": 4, "lat": 47.4812451, "lng": 9.729932}, {"ts": "2026-03-20T08:59:39.450Z", "acc": 4, "lat": 47.4812452, "lng": 9.729932}, {"ts": "2026-03-20T08:59:40.458Z", "acc": 4, "lat": 47.4812444, "lng": 9.7299327}, {"ts": "2026-03-20T08:59:41.447Z", "acc": 4, "lat": 47.4812439, "lng": 9.7299327}, {"ts": "2026-03-20T08:59:42.454Z", "acc": 4, "lat": 47.4812435, "lng": 9.7299323}, {"ts": "2026-03-20T08:59:43.450Z", "acc": 4, "lat": 47.4812431, "lng": 9.7299321}, {"ts": "2026-03-20T08:59:44.447Z", "acc": 4, "lat": 47.4812423, "lng": 9.7299335}, {"ts": "2026-03-20T08:59:45.451Z", "acc": 4, "lat": 47.4812417, "lng": 9.7299345}, {"ts": "2026-03-20T08:59:46.454Z", "acc": 4, "lat": 47.4812414, "lng": 9.7299352}]	\N	\N	abgeschlossen	\N	\N	\N	\N	2026-03-18 17:23:57.533596+00	2026-03-20 10:43:57.274+00	0	[]	Milz	\N	407ee813	1	14	0.00	t	Erste Anfahrt für umsonst, Kunde Termin bestätigt und war nicht zuhause. 	2026-03-20	Thaläckerstrasse 17	6923	Österreich	0	[]	Lauterach	0.00	10:00:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
16	2	Hornbach	77173334	3	Stefano	2	\N	\N	\N	\N	0	0	0	0.00	0.00	[]	Betonfundamente für Zaun, Vorarbeit	\N	geplant	\N	\N	\N	\N	2026-03-18 17:29:17.914245+00	\N	0	[]	Stefanie Caron	\N	\N	1	\N	0.00	f	\N	2026-03-24	Rheinstrasse 45	6800	Österreich	0	[]	Feldkirch	0.00	08:00:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
11	1	Heim & Haus	860626+860627	8	Michi	2	2026-03-18 07:27:31.685792+00	2026-03-18 08:20:50.283093+00	2026-03-18 13:18:25.366012+00	2026-03-18 13:18:31.981+00	53	298	0	39.00	0.00	[{"ts": "2026-03-18T08:13:25.744Z", "lat": 47.22442745510285, "lng": 9.619460258392388}, {"ts": "2026-03-18T08:13:26.079Z", "lat": 47.22440136080263, "lng": 9.619638130628388}, {"ts": "2026-03-18T08:13:27.078Z", "lat": 47.22437755157663, "lng": 9.61981546004606}, {"ts": "2026-03-18T08:13:28.081Z", "lat": 47.22435182157959, "lng": 9.619992450099613}, {"ts": "2026-03-18T08:13:29.086Z", "lat": 47.224325462793985, "lng": 9.620169482346423}, {"ts": "2026-03-18T08:13:30.087Z", "lat": 47.22429993288511, "lng": 9.620346434484984}, {"ts": "2026-03-18T08:13:31.091Z", "lat": 47.22427510445016, "lng": 9.620525528596444}, {"ts": "2026-03-18T08:13:32.090Z", "lat": 47.22425090742895, "lng": 9.62070361007989}, {"ts": "2026-03-18T08:13:33.088Z", "lat": 47.22422741531791, "lng": 9.620881859974867}, {"ts": "2026-03-18T08:13:34.092Z", "lat": 47.224203430444184, "lng": 9.621061249663581}, {"ts": "2026-03-18T08:13:35.092Z", "lat": 47.224178530352624, "lng": 9.621244418433916}, {"ts": "2026-03-18T08:13:36.093Z", "lat": 47.2241534386183, "lng": 9.621426406903097}, {"ts": "2026-03-18T08:13:37.093Z", "lat": 47.22412779582769, "lng": 9.621609978783896}, {"ts": "2026-03-18T08:13:38.092Z", "lat": 47.22410229815773, "lng": 9.621796098540974}, {"ts": "2026-03-18T08:13:39.097Z", "lat": 47.22407806800621, "lng": 9.621982996587413}, {"ts": "2026-03-18T08:13:40.094Z", "lat": 47.224052306682125, "lng": 9.622168988973849}, {"ts": "2026-03-18T08:13:41.091Z", "lat": 47.22402650311622, "lng": 9.622350381105377}, {"ts": "2026-03-18T08:13:42.088Z", "lat": 47.22400080227141, "lng": 9.622527337222749}, {"ts": "2026-03-18T08:13:43.095Z", "lat": 47.22397791789904, "lng": 9.622700903016195}, {"ts": "2026-03-18T08:13:44.090Z", "lat": 47.22395047022101, "lng": 9.622858474935768}, {"ts": "2026-03-18T08:13:45.094Z", "lat": 47.22392807052852, "lng": 9.623030739228756}, {"ts": "2026-03-18T08:13:46.090Z", "lat": 47.22390369891986, "lng": 9.623203565662608}, {"ts": "2026-03-18T08:13:47.095Z", "lat": 47.223877316822424, "lng": 9.623370230674078}, {"ts": "2026-03-18T08:13:48.094Z", "lat": 47.2238507057521, "lng": 9.623537409987371}, {"ts": "2026-03-18T08:13:49.094Z", "lat": 47.2238272019501, "lng": 9.623689493624912}, {"ts": "2026-03-18T08:13:50.095Z", "lat": 47.22380141283566, "lng": 9.62383965572161}, {"ts": "2026-03-18T08:13:51.098Z", "lat": 47.223773743172565, "lng": 9.623981706426825}, {"ts": "2026-03-18T08:13:52.093Z", "lat": 47.223751704197824, "lng": 9.624121557974213}, {"ts": "2026-03-18T08:13:53.088Z", "lat": 47.22373339294551, "lng": 9.62425499266468}, {"ts": "2026-03-18T08:13:54.095Z", "lat": 47.22371548683239, "lng": 9.62438776128303}, {"ts": "2026-03-18T08:13:55.103Z", "lat": 47.22370653645428, "lng": 9.624502363028562}, {"ts": "2026-03-18T08:13:56.087Z", "lat": 47.22369382116217, "lng": 9.624589066988738}, {"ts": "2026-03-18T08:13:57.092Z", "lat": 47.2236692055672, "lng": 9.624644983331713}, {"ts": "2026-03-18T08:13:58.088Z", "lat": 47.2236308232672, "lng": 9.624680036861873}, {"ts": "2026-03-18T08:13:59.091Z", "lat": 47.22357603296204, "lng": 9.624633390753608}, {"ts": "2026-03-18T08:14:00.084Z", "lat": 47.22351773388409, "lng": 9.624644870316205}, {"ts": "2026-03-18T08:14:01.086Z", "lat": 47.22345186723827, "lng": 9.6246791599783}, {"ts": "2026-03-18T08:20:31.585Z", "lat": 47.199664876290306, "lng": 9.652735049321779}, {"ts": "2026-03-18T08:20:31.588Z", "lat": 47.19975729788218, "lng": 9.652903642531369}, {"ts": "2026-03-18T08:20:31.602Z", "lat": 47.19975943947111, "lng": 9.65290756278623}, {"ts": "2026-03-18T08:20:33.030Z", "lat": 47.199763880873064, "lng": 9.652915692930684}, {"ts": "2026-03-18T08:20:33.041Z", "lat": 47.19976391342665, "lng": 9.652915752521176}, {"ts": "2026-03-18T08:20:34.903Z", "lat": 47.199607827800506, "lng": 9.652984620170336}, {"ts": "2026-03-18T08:20:35.902Z", "lat": 47.199618983734325, "lng": 9.653018371732164}, {"ts": "2026-03-18T08:20:36.920Z", "lat": 47.19966500851143, "lng": 9.65288461767064}, {"ts": "2026-03-18T08:20:38.066Z", "lat": 47.199680650574145, "lng": 9.652883028358657}, {"ts": "2026-03-18T08:20:38.941Z", "lat": 47.19971307910922, "lng": 9.65285854229999}, {"ts": "2026-03-18T08:20:40.039Z", "lat": 47.19973085797296, "lng": 9.652860820007254}, {"ts": "2026-03-18T08:20:41.060Z", "lat": 47.19973749403812, "lng": 9.652860466498675}, {"ts": "2026-03-18T08:20:42.072Z", "lat": 47.199739573747316, "lng": 9.652859539313942}, {"ts": "2026-03-18T08:20:43.070Z", "lat": 47.19973976401277, "lng": 9.652856534281254}, {"ts": "2026-03-18T08:20:44.073Z", "lat": 47.199740858654586, "lng": 9.652857600563614}, {"ts": "2026-03-18T08:20:45.078Z", "lat": 47.19974236065149, "lng": 9.652859415883622}, {"ts": "2026-03-18T08:20:46.077Z", "lat": 47.19974230025779, "lng": 9.652858326457945}, {"ts": "2026-03-18T08:20:47.073Z", "lat": 47.19974254349706, "lng": 9.65285480912494}, {"ts": "2026-03-18T08:20:48.073Z", "lat": 47.19974230025809, "lng": 9.652858326457944}, {"ts": "2026-03-18T08:20:49.071Z", "lat": 47.19974134539223, "lng": 9.652857095009969}]	\N	\N	abgeschlossen	\N	\N	\N	\N	2026-03-17 15:58:16.746485+00	2026-03-18 13:18:31.981+00	0	[]	Familie Gassner	\N	e18f190a	1	12	0.00	t	Rapport geschrieben wegen Bohrungen durch Stahlträger	2026-03-18	Gampelünerstraße 49	6820	Österreich	0	[]	Frastanz	0.00	09:00:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
29	1	Heim & Haus	866393	3	Stefano	2	\N	\N	\N	\N	0	0	0	0.00	0.00	[]	Aufmass!!! Tel.:00436643858549	\N	geplant	\N	\N	\N	\N	2026-03-23 14:17:41.830767+00	\N	0	[]	Verena Schneider	\N	\N	1	\N	0.00	f	\N	2026-03-27	Vesenweg 4a	6850	Österreich	0	[]	Dornbirn	0.00	08:30:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
14	1	Heim & Haus	863232	1	Superuser	2	2026-03-20 11:34:27.938701+00	2026-03-20 11:51:15.544522+00	2026-03-20 14:10:36.07769+00	2026-03-20 14:10:40.479+00	17	139	0	12.00	0.00	[{"ts": "2026-03-20T11:50:48.616Z", "acc": 36, "lat": 47.554430693222955, "lng": 9.747943869993238}, {"ts": "2026-03-20T11:50:48.617Z", "acc": 36, "lat": 47.554430693222955, "lng": 9.747943869993238}, {"ts": "2026-03-20T11:50:48.651Z", "acc": 36, "lat": 47.554405935200634, "lng": 9.747847361487844}, {"ts": "2026-03-20T11:50:50.905Z", "acc": 40, "lat": 47.55439480176408, "lng": 9.747810316348406}, {"ts": "2026-03-20T11:50:52.428Z", "acc": 31, "lat": 47.554406602888996, "lng": 9.74789681361181}, {"ts": "2026-03-20T11:50:54.001Z", "acc": 14, "lat": 47.55426555182945, "lng": 9.747746330610784}, {"ts": "2026-03-20T11:50:55.030Z", "acc": 16, "lat": 47.5542450479027, "lng": 9.747713545738703}, {"ts": "2026-03-20T11:50:56.024Z", "acc": 11, "lat": 47.554234813185325, "lng": 9.747752020882539}, {"ts": "2026-03-20T11:50:57.028Z", "acc": 8, "lat": 47.55422053843911, "lng": 9.747761220274972}, {"ts": "2026-03-20T11:50:58.065Z", "acc": 6, "lat": 47.55420667618496, "lng": 9.747750108075865}, {"ts": "2026-03-20T11:50:59.063Z", "acc": 5, "lat": 47.554201895107205, "lng": 9.747750443048004}, {"ts": "2026-03-20T11:51:00.063Z", "acc": 5, "lat": 47.55420521457896, "lng": 9.747744826278298}, {"ts": "2026-03-20T11:51:01.066Z", "acc": 5, "lat": 47.55420756798033, "lng": 9.74775589039353}, {"ts": "2026-03-20T11:51:02.075Z", "acc": 5, "lat": 47.554214081060195, "lng": 9.747772947080014}, {"ts": "2026-03-20T11:51:03.066Z", "acc": 5, "lat": 47.55421761879963, "lng": 9.747775857858102}, {"ts": "2026-03-20T11:51:04.069Z", "acc": 5, "lat": 47.55421761879994, "lng": 9.747775857858102}, {"ts": "2026-03-20T11:51:05.066Z", "acc": 5, "lat": 47.55422167258127, "lng": 9.747779798437007}, {"ts": "2026-03-20T11:51:06.065Z", "acc": 5, "lat": 47.55422189670827, "lng": 9.747776093974057}, {"ts": "2026-03-20T11:51:07.066Z", "acc": 5, "lat": 47.55422235930986, "lng": 9.747773887588254}, {"ts": "2026-03-20T11:51:08.069Z", "acc": 5, "lat": 47.554220707148005, "lng": 9.74777074067465}, {"ts": "2026-03-20T11:51:09.076Z", "acc": 5, "lat": 47.554218738214175, "lng": 9.747768876208005}, {"ts": "2026-03-20T11:51:10.073Z", "acc": 5, "lat": 47.55421672144599, "lng": 9.747766993734832}, {"ts": "2026-03-20T11:51:11.078Z", "acc": 5, "lat": 47.55421809369598, "lng": 9.747773245070285}, {"ts": "2026-03-20T11:51:12.075Z", "acc": 5, "lat": 47.55421889122174, "lng": 9.747778738655153}, {"ts": "2026-03-20T11:51:13.078Z", "acc": 5, "lat": 47.55421958879934, "lng": 9.747781720221957}, {"ts": "2026-03-20T11:51:14.075Z", "acc": 5, "lat": 47.55422005866569, "lng": 9.747783809302701}, {"ts": "2026-03-20T11:51:15.078Z", "acc": 5, "lat": 47.55422262449794, "lng": 9.747787169924804}]	\N	\N	geplant	\N	\N	\N	\N	2026-03-18 17:24:56.046329+00	2026-03-20 14:10:40.479+00	0	[]	Lux	\N	407ee813	1	15	0.00	t	Extraanfahrt weil Halter beschädigt, Rapport schreiben	2026-03-20	Lindauerstrasse 81a	6912	Österreich	0	[]	Hörbranz	0.00	13:30:00	120	0.00	0.00	t	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
12	1	Heim & Haus	866167	8	Michi	2	2026-03-18 13:18:31.981+00	2026-03-18 13:46:44.793376+00	2026-03-18 13:58:16.192112+00	2026-03-18 14:42:47.664561+00	28	12	45	22.60	28.40	[{"ts": "2026-03-18T13:46:23.040Z", "lat": 47.31728655327682, "lng": 9.672078847911287}, {"ts": "2026-03-18T13:46:23.041Z", "lat": 47.31728655327682, "lng": 9.672078847911287}, {"ts": "2026-03-18T13:46:23.045Z", "lat": 47.31728604645138, "lng": 9.67207645189786}, {"ts": "2026-03-18T13:46:24.078Z", "lat": 47.31729122383721, "lng": 9.672092894074341}, {"ts": "2026-03-18T13:46:25.078Z", "lat": 47.31729459622372, "lng": 9.672092894074341}, {"ts": "2026-03-18T13:46:26.078Z", "lat": 47.31730214891473, "lng": 9.672102124356458}, {"ts": "2026-03-18T13:46:27.078Z", "lat": 47.31730694172908, "lng": 9.672110911289492}, {"ts": "2026-03-18T13:46:28.080Z", "lat": 47.31728460545067, "lng": 9.672079870450355}, {"ts": "2026-03-18T13:46:29.080Z", "lat": 47.31727666492581, "lng": 9.672072802967904}, {"ts": "2026-03-18T13:46:30.104Z", "lat": 47.317269208674915, "lng": 9.67206797950091}, {"ts": "2026-03-18T13:46:31.087Z", "lat": 47.317263511018425, "lng": 9.67206330612552}, {"ts": "2026-03-18T13:46:32.088Z", "lat": 47.317261711774684, "lng": 9.672064848583268}, {"ts": "2026-03-18T13:46:33.095Z", "lat": 47.31725907264415, "lng": 9.672066185254614}, {"ts": "2026-03-18T13:46:34.088Z", "lat": 47.31725784796992, "lng": 9.672067216211758}, {"ts": "2026-03-18T13:46:35.086Z", "lat": 47.31725683484873, "lng": 9.672069641913849}, {"ts": "2026-03-18T13:46:36.087Z", "lat": 47.31725766891263, "lng": 9.672070968625198}, {"ts": "2026-03-18T13:46:37.090Z", "lat": 47.3172590533864, "lng": 9.672071069547691}, {"ts": "2026-03-18T13:46:38.088Z", "lat": 47.317260028755555, "lng": 9.672071197661497}, {"ts": "2026-03-18T13:46:39.088Z", "lat": 47.317259609824276, "lng": 9.672071899551195}, {"ts": "2026-03-18T13:46:40.085Z", "lat": 47.31725918535106, "lng": 9.6720716213014}, {"ts": "2026-03-18T13:46:41.117Z", "lat": 47.31725918462409, "lng": 9.672072524608687}, {"ts": "2026-03-18T13:46:42.082Z", "lat": 47.31725850170947, "lng": 9.672073382165275}, {"ts": "2026-03-18T13:46:43.089Z", "lat": 47.317259063737936, "lng": 9.672074394692395}, {"ts": "2026-03-18T13:46:44.084Z", "lat": 47.31725875038287, "lng": 9.672074738037965}, {"ts": "2026-03-18T14:17:25.252Z", "lat": 47.3747337935811, "lng": 9.674837483294583}, {"ts": "2026-03-18T14:17:25.864Z", "lat": 47.3747632503666, "lng": 9.674033945384709}, {"ts": "2026-03-18T14:17:25.864Z", "lat": 47.3747632503666, "lng": 9.674033945384709}, {"ts": "2026-03-18T14:17:26.888Z", "lat": 47.374822311471924, "lng": 9.67400037365912}, {"ts": "2026-03-18T14:17:26.888Z", "lat": 47.374822311471924, "lng": 9.67400037365912}, {"ts": "2026-03-18T14:17:27.983Z", "lat": 47.37484640758888, "lng": 9.67402909544469}, {"ts": "2026-03-18T14:17:27.983Z", "lat": 47.37484640758888, "lng": 9.67402909544469}, {"ts": "2026-03-18T14:17:29.062Z", "lat": 47.37486405808003, "lng": 9.674016344327102}, {"ts": "2026-03-18T14:17:29.062Z", "lat": 47.37486405808003, "lng": 9.674016344327102}, {"ts": "2026-03-18T14:17:30.076Z", "lat": 47.37488106149336, "lng": 9.674014319756598}, {"ts": "2026-03-18T14:17:30.076Z", "lat": 47.37488106149336, "lng": 9.674014319756598}, {"ts": "2026-03-18T14:17:31.074Z", "lat": 47.374902242026636, "lng": 9.67399971346279}, {"ts": "2026-03-18T14:17:31.074Z", "lat": 47.374902242026636, "lng": 9.67399971346279}, {"ts": "2026-03-18T14:17:32.074Z", "lat": 47.37492766539039, "lng": 9.674000007104215}, {"ts": "2026-03-18T14:17:32.074Z", "lat": 47.37492766539039, "lng": 9.674000007104215}, {"ts": "2026-03-18T14:17:33.076Z", "lat": 47.37494196708042, "lng": 9.674021262161551}, {"ts": "2026-03-18T14:17:33.076Z", "lat": 47.37494196708042, "lng": 9.674021262161551}, {"ts": "2026-03-18T14:17:34.075Z", "lat": 47.37495518575292, "lng": 9.674060347458996}, {"ts": "2026-03-18T14:17:34.076Z", "lat": 47.37495518575292, "lng": 9.674060347458996}, {"ts": "2026-03-18T14:17:35.075Z", "lat": 47.374978950733606, "lng": 9.674113067384686}, {"ts": "2026-03-18T14:17:35.075Z", "lat": 47.374978950733606, "lng": 9.674113067384686}, {"ts": "2026-03-18T14:17:36.085Z", "lat": 47.375006481937056, "lng": 9.67415505137945}, {"ts": "2026-03-18T14:17:36.085Z", "lat": 47.375006481937056, "lng": 9.67415505137945}, {"ts": "2026-03-18T14:17:37.081Z", "lat": 47.375029181522244, "lng": 9.674187056642822}, {"ts": "2026-03-18T14:17:37.081Z", "lat": 47.375029181522244, "lng": 9.674187056642822}, {"ts": "2026-03-18T14:17:38.080Z", "lat": 47.37504881180513, "lng": 9.674228570741215}, {"ts": "2026-03-18T14:17:38.080Z", "lat": 47.37504881180513, "lng": 9.674228570741215}, {"ts": "2026-03-18T14:17:39.081Z", "lat": 47.37507113693824, "lng": 9.674262452541834}, {"ts": "2026-03-18T14:17:39.082Z", "lat": 47.37507113693824, "lng": 9.674262452541834}, {"ts": "2026-03-18T14:17:40.080Z", "lat": 47.375103781661075, "lng": 9.674310073343241}, {"ts": "2026-03-18T14:17:40.080Z", "lat": 47.375103781661075, "lng": 9.674310073343241}, {"ts": "2026-03-18T14:17:41.079Z", "lat": 47.37513513972467, "lng": 9.674363611752382}, {"ts": "2026-03-18T14:17:41.080Z", "lat": 47.37513513972467, "lng": 9.674363611752382}, {"ts": "2026-03-18T14:17:42.077Z", "lat": 47.37515824658399, "lng": 9.674414150661073}, {"ts": "2026-03-18T14:17:42.077Z", "lat": 47.37515824658399, "lng": 9.674414150661073}, {"ts": "2026-03-18T14:17:43.093Z", "lat": 47.37518085609579, "lng": 9.674460867914426}, {"ts": "2026-03-18T14:17:43.093Z", "lat": 47.37518085609579, "lng": 9.674460867914426}, {"ts": "2026-03-18T14:17:44.089Z", "lat": 47.3752039294309, "lng": 9.674511194887746}, {"ts": "2026-03-18T14:17:44.089Z", "lat": 47.3752039294309, "lng": 9.674511194887746}, {"ts": "2026-03-18T14:17:45.088Z", "lat": 47.37522625667084, "lng": 9.67457949563342}, {"ts": "2026-03-18T14:17:45.088Z", "lat": 47.37522625667084, "lng": 9.67457949563342}, {"ts": "2026-03-18T14:17:46.089Z", "lat": 47.37523954599323, "lng": 9.674671473873309}, {"ts": "2026-03-18T14:17:46.089Z", "lat": 47.37523954599323, "lng": 9.674671473873309}, {"ts": "2026-03-18T14:17:47.098Z", "lat": 47.37520866636611, "lng": 9.674774896159233}, {"ts": "2026-03-18T14:17:47.098Z", "lat": 47.37520866636611, "lng": 9.674774896159233}, {"ts": "2026-03-18T14:17:48.091Z", "lat": 47.375222095626945, "lng": 9.674867628442783}, {"ts": "2026-03-18T14:17:48.092Z", "lat": 47.375222095626945, "lng": 9.674867628442783}, {"ts": "2026-03-18T14:17:49.093Z", "lat": 47.37526986745437, "lng": 9.674960086208099}, {"ts": "2026-03-18T14:17:49.093Z", "lat": 47.37526986745437, "lng": 9.674960086208099}, {"ts": "2026-03-18T14:17:50.091Z", "lat": 47.375293138244096, "lng": 9.67505491681309}, {"ts": "2026-03-18T14:17:50.091Z", "lat": 47.375293138244096, "lng": 9.67505491681309}, {"ts": "2026-03-18T14:17:51.091Z", "lat": 47.37527462242996, "lng": 9.675148869823527}, {"ts": "2026-03-18T14:17:51.092Z", "lat": 47.37527462242996, "lng": 9.675148869823527}, {"ts": "2026-03-18T14:17:52.086Z", "lat": 47.375255952987985, "lng": 9.675226162327684}, {"ts": "2026-03-18T14:17:52.086Z", "lat": 47.375255952987985, "lng": 9.675226162327684}, {"ts": "2026-03-18T14:17:53.093Z", "lat": 47.37524405311258, "lng": 9.67529744604804}, {"ts": "2026-03-18T14:17:53.094Z", "lat": 47.37524405311258, "lng": 9.67529744604804}, {"ts": "2026-03-18T14:17:54.091Z", "lat": 47.375253631053376, "lng": 9.67532171147044}, {"ts": "2026-03-18T14:17:54.091Z", "lat": 47.375253631053376, "lng": 9.67532171147044}, {"ts": "2026-03-18T14:17:55.087Z", "lat": 47.37524177798155, "lng": 9.675346886359417}, {"ts": "2026-03-18T14:17:55.088Z", "lat": 47.37524177798155, "lng": 9.675346886359417}, {"ts": "2026-03-18T14:17:56.087Z", "lat": 47.37523921476308, "lng": 9.675341415387852}, {"ts": "2026-03-18T14:17:56.088Z", "lat": 47.37523921476308, "lng": 9.675341415387852}, {"ts": "2026-03-18T14:17:57.088Z", "lat": 47.37523381542114, "lng": 9.67534981399633}, {"ts": "2026-03-18T14:17:57.088Z", "lat": 47.37523381542114, "lng": 9.67534981399633}, {"ts": "2026-03-18T14:17:58.090Z", "lat": 47.375203138829185, "lng": 9.675364622148734}, {"ts": "2026-03-18T14:17:58.091Z", "lat": 47.375203138829185, "lng": 9.675364622148734}, {"ts": "2026-03-18T14:17:59.093Z", "lat": 47.37521196369301, "lng": 9.675387033871734}, {"ts": "2026-03-18T14:17:59.094Z", "lat": 47.37521196369301, "lng": 9.675387033871734}, {"ts": "2026-03-18T14:18:00.089Z", "lat": 47.37520820591057, "lng": 9.675409544082928}, {"ts": "2026-03-18T14:18:00.089Z", "lat": 47.37520820591057, "lng": 9.675409544082928}, {"ts": "2026-03-18T14:18:01.092Z", "lat": 47.3752041774649, "lng": 9.675433675646072}, {"ts": "2026-03-18T14:18:01.092Z", "lat": 47.3752041774649, "lng": 9.675433675646072}, {"ts": "2026-03-18T14:18:02.098Z", "lat": 47.37520425460486, "lng": 9.67543321355532}, {"ts": "2026-03-18T14:18:02.098Z", "lat": 47.37520425460486, "lng": 9.67543321355532}, {"ts": "2026-03-18T14:18:03.095Z", "lat": 47.37516096528667, "lng": 9.675437039859716}, {"ts": "2026-03-18T14:18:03.095Z", "lat": 47.37516096528667, "lng": 9.675437039859716}, {"ts": "2026-03-18T14:18:04.088Z", "lat": 47.37515398260579, "lng": 9.675449852914953}, {"ts": "2026-03-18T14:18:04.088Z", "lat": 47.37515398260579, "lng": 9.675449852914953}, {"ts": "2026-03-18T14:18:05.091Z", "lat": 47.37514745742525, "lng": 9.675462479035485}, {"ts": "2026-03-18T14:18:05.091Z", "lat": 47.37514745742525, "lng": 9.675462479035485}, {"ts": "2026-03-18T14:18:06.088Z", "lat": 47.375141837206556, "lng": 9.675473767902746}, {"ts": "2026-03-18T14:18:06.088Z", "lat": 47.375141837206556, "lng": 9.675473767902746}, {"ts": "2026-03-18T14:18:07.088Z", "lat": 47.375133820476265, "lng": 9.675489634206038}, {"ts": "2026-03-18T14:18:07.090Z", "lat": 47.375133820476265, "lng": 9.675489634206038}, {"ts": "2026-03-18T14:18:08.089Z", "lat": 47.37511757772753, "lng": 9.675522274744816}, {"ts": "2026-03-18T14:18:08.089Z", "lat": 47.37511757772753, "lng": 9.675522274744816}, {"ts": "2026-03-18T14:18:09.090Z", "lat": 47.37509285778776, "lng": 9.675569475311045}, {"ts": "2026-03-18T14:18:09.090Z", "lat": 47.37509285778776, "lng": 9.675569475311045}, {"ts": "2026-03-18T14:18:10.089Z", "lat": 47.375058438395754, "lng": 9.675633058162328}, {"ts": "2026-03-18T14:18:10.090Z", "lat": 47.375058438395754, "lng": 9.675633058162328}, {"ts": "2026-03-18T14:18:11.091Z", "lat": 47.37502716726629, "lng": 9.67569069211443}, {"ts": "2026-03-18T14:18:11.091Z", "lat": 47.37502716726629, "lng": 9.67569069211443}, {"ts": "2026-03-18T14:18:12.093Z", "lat": 47.37499884674707, "lng": 9.675746829958506}, {"ts": "2026-03-18T14:18:12.093Z", "lat": 47.37499884674707, "lng": 9.675746829958506}, {"ts": "2026-03-18T14:18:13.094Z", "lat": 47.37497056742527, "lng": 9.675799313724848}, {"ts": "2026-03-18T14:18:13.094Z", "lat": 47.37497056742527, "lng": 9.675799313724848}, {"ts": "2026-03-18T14:18:14.086Z", "lat": 47.37494427721076, "lng": 9.675849575554615}, {"ts": "2026-03-18T14:18:14.087Z", "lat": 47.37494427721076, "lng": 9.675849575554615}, {"ts": "2026-03-18T14:18:15.086Z", "lat": 47.37492275331731, "lng": 9.675892055541622}, {"ts": "2026-03-18T14:18:15.086Z", "lat": 47.37492275331731, "lng": 9.675892055541622}, {"ts": "2026-03-18T14:18:16.097Z", "lat": 47.37490994478276, "lng": 9.675914245941629}, {"ts": "2026-03-18T14:18:16.097Z", "lat": 47.37490994478276, "lng": 9.675914245941629}, {"ts": "2026-03-18T14:18:17.094Z", "lat": 47.37490334955761, "lng": 9.675928341159134}, {"ts": "2026-03-18T14:18:17.094Z", "lat": 47.37490334955761, "lng": 9.675928341159134}, {"ts": "2026-03-18T14:18:18.089Z", "lat": 47.37489628537613, "lng": 9.675940354520833}, {"ts": "2026-03-18T14:18:18.089Z", "lat": 47.37489628537613, "lng": 9.675940354520833}, {"ts": "2026-03-18T14:18:19.094Z", "lat": 47.37488950191807, "lng": 9.675951395390276}, {"ts": "2026-03-18T14:18:19.094Z", "lat": 47.37488950191807, "lng": 9.675951395390276}, {"ts": "2026-03-18T14:18:20.093Z", "lat": 47.374882533905414, "lng": 9.67596469767527}, {"ts": "2026-03-18T14:18:20.093Z", "lat": 47.374882533905414, "lng": 9.67596469767527}, {"ts": "2026-03-18T14:18:21.090Z", "lat": 47.37487262503179, "lng": 9.67598168895485}, {"ts": "2026-03-18T14:18:21.090Z", "lat": 47.37487262503179, "lng": 9.67598168895485}, {"ts": "2026-03-18T14:18:22.095Z", "lat": 47.3748585575536, "lng": 9.676008784444038}, {"ts": "2026-03-18T14:18:22.095Z", "lat": 47.3748585575536, "lng": 9.676008784444038}, {"ts": "2026-03-18T14:18:23.089Z", "lat": 47.374837754337356, "lng": 9.67604839086808}, {"ts": "2026-03-18T14:18:23.089Z", "lat": 47.374837754337356, "lng": 9.67604839086808}, {"ts": "2026-03-18T14:18:24.097Z", "lat": 47.3748124942053, "lng": 9.676097333310494}, {"ts": "2026-03-18T14:18:24.098Z", "lat": 47.3748124942053, "lng": 9.676097333310494}, {"ts": "2026-03-18T14:18:25.088Z", "lat": 47.374788444500886, "lng": 9.676141882066359}, {"ts": "2026-03-18T14:18:25.088Z", "lat": 47.374788444500886, "lng": 9.676141882066359}, {"ts": "2026-03-18T14:18:26.088Z", "lat": 47.374767077425915, "lng": 9.676182732607273}, {"ts": "2026-03-18T14:18:26.088Z", "lat": 47.374767077425915, "lng": 9.676182732607273}, {"ts": "2026-03-18T14:18:27.094Z", "lat": 47.37474624988457, "lng": 9.676221380952233}, {"ts": "2026-03-18T14:18:27.094Z", "lat": 47.37474624988457, "lng": 9.676221380952233}, {"ts": "2026-03-18T14:18:28.097Z", "lat": 47.37472418832255, "lng": 9.676264640727423}, {"ts": "2026-03-18T14:18:28.098Z", "lat": 47.37472418832255, "lng": 9.676264640727423}, {"ts": "2026-03-18T14:18:29.089Z", "lat": 47.37469942267724, "lng": 9.676312541308489}, {"ts": "2026-03-18T14:18:29.090Z", "lat": 47.37469942267724, "lng": 9.676312541308489}, {"ts": "2026-03-18T14:18:30.093Z", "lat": 47.374674431006504, "lng": 9.67636001667479}, {"ts": "2026-03-18T14:18:30.093Z", "lat": 47.374674431006504, "lng": 9.67636001667479}, {"ts": "2026-03-18T14:18:31.094Z", "lat": 47.37464757273906, "lng": 9.676413176925907}, {"ts": "2026-03-18T14:18:31.094Z", "lat": 47.37464757273906, "lng": 9.676413176925907}, {"ts": "2026-03-18T14:18:32.091Z", "lat": 47.37461873899922, "lng": 9.67647136741599}, {"ts": "2026-03-18T14:18:32.091Z", "lat": 47.37461873899922, "lng": 9.67647136741599}, {"ts": "2026-03-18T14:18:33.095Z", "lat": 47.37458502272185, "lng": 9.676538604908318}, {"ts": "2026-03-18T14:18:33.095Z", "lat": 47.37458502272185, "lng": 9.676538604908318}, {"ts": "2026-03-18T14:18:34.088Z", "lat": 47.37454948886073, "lng": 9.676613025376785}, {"ts": "2026-03-18T14:18:34.089Z", "lat": 47.37454948886073, "lng": 9.676613025376785}, {"ts": "2026-03-18T14:18:35.086Z", "lat": 47.374513405359565, "lng": 9.676684723785296}, {"ts": "2026-03-18T14:18:35.086Z", "lat": 47.374513405359565, "lng": 9.676684723785296}, {"ts": "2026-03-18T14:18:36.088Z", "lat": 47.374477671482644, "lng": 9.676759780050638}, {"ts": "2026-03-18T14:18:36.088Z", "lat": 47.374477671482644, "lng": 9.676759780050638}, {"ts": "2026-03-18T14:18:37.088Z", "lat": 47.374439800912434, "lng": 9.676841303629914}, {"ts": "2026-03-18T14:18:37.088Z", "lat": 47.374439800912434, "lng": 9.676841303629914}, {"ts": "2026-03-18T14:20:24.601Z", "lat": 47.38076680420877, "lng": 9.68045701915161}, {"ts": "2026-03-18T14:20:24.601Z", "lat": 47.38076680420877, "lng": 9.68045701915161}, {"ts": "2026-03-18T14:20:24.604Z", "lat": 47.38635614416958, "lng": 9.680033261050541}, {"ts": "2026-03-18T14:20:24.604Z", "lat": 47.38635614416958, "lng": 9.680033261050541}, {"ts": "2026-03-18T14:20:24.618Z", "lat": 47.3867883610147, "lng": 9.679970545139048}, {"ts": "2026-03-18T14:20:24.618Z", "lat": 47.3867883610147, "lng": 9.679970545139048}, {"ts": "2026-03-18T14:20:27.267Z", "lat": 47.38859068201622, "lng": 9.680275707176419}, {"ts": "2026-03-18T14:20:27.268Z", "lat": 47.38859068201622, "lng": 9.680275707176419}, {"ts": "2026-03-18T14:20:27.915Z", "lat": 47.38931837906958, "lng": 9.684453969954907}, {"ts": "2026-03-18T14:20:27.915Z", "lat": 47.38931837906958, "lng": 9.684453969954907}, {"ts": "2026-03-18T14:20:28.936Z", "lat": 47.38940254559342, "lng": 9.684442342266792}, {"ts": "2026-03-18T14:20:28.936Z", "lat": 47.38940254559342, "lng": 9.684442342266792}, {"ts": "2026-03-18T14:26:45.079Z", "lat": 47.42129415894888, "lng": 9.660042561085556}, {"ts": "2026-03-18T14:26:45.080Z", "lat": 47.42129415894888, "lng": 9.660042561085556}, {"ts": "2026-03-18T14:26:45.080Z", "lat": 47.42129415894888, "lng": 9.660042561085556}, {"ts": "2026-03-18T14:26:45.080Z", "lat": 47.42129415894888, "lng": 9.660042561085556}, {"ts": "2026-03-18T14:26:46.087Z", "lat": 47.42145034198902, "lng": 9.66000002314948}, {"ts": "2026-03-18T14:26:46.087Z", "lat": 47.42145034198902, "lng": 9.66000002314948}, {"ts": "2026-03-18T14:26:47.086Z", "lat": 47.4215225630142, "lng": 9.659981688429017}, {"ts": "2026-03-18T14:26:47.086Z", "lat": 47.4215225630142, "lng": 9.659981688429017}, {"ts": "2026-03-18T14:26:48.084Z", "lat": 47.42160477659889, "lng": 9.659966875566218}, {"ts": "2026-03-18T14:26:48.084Z", "lat": 47.42160477659889, "lng": 9.659966875566218}, {"ts": "2026-03-18T14:42:32.287Z", "lat": 47.46848829206804, "lng": 9.625428736699785}, {"ts": "2026-03-18T14:42:32.288Z", "lat": 47.46848829206804, "lng": 9.625428736699785}, {"ts": "2026-03-18T14:42:34.347Z", "lat": 47.46847657709257, "lng": 9.625380111754025}, {"ts": "2026-03-18T14:42:34.347Z", "lat": 47.46847657709257, "lng": 9.625380111754025}, {"ts": "2026-03-18T14:42:35.319Z", "lat": 47.4684812635949, "lng": 9.625378546888133}, {"ts": "2026-03-18T14:42:35.320Z", "lat": 47.4684812635949, "lng": 9.625378546888133}, {"ts": "2026-03-18T14:42:36.340Z", "lat": 47.46847504937802, "lng": 9.6253727985026}, {"ts": "2026-03-18T14:42:36.340Z", "lat": 47.46847504937802, "lng": 9.6253727985026}, {"ts": "2026-03-18T14:42:37.363Z", "lat": 47.46847720448311, "lng": 9.625399578495125}, {"ts": "2026-03-18T14:42:37.364Z", "lat": 47.46847720448311, "lng": 9.625399578495125}, {"ts": "2026-03-18T14:42:38.350Z", "lat": 47.46847715163562, "lng": 9.625409979425864}, {"ts": "2026-03-18T14:42:38.350Z", "lat": 47.46847715163562, "lng": 9.625409979425864}, {"ts": "2026-03-18T14:42:39.069Z", "lat": 47.46843164537386, "lng": 9.6254205917462}, {"ts": "2026-03-18T14:42:39.069Z", "lat": 47.46843164537386, "lng": 9.6254205917462}, {"ts": "2026-03-18T14:42:40.068Z", "lat": 47.46841955084472, "lng": 9.625423495264805}, {"ts": "2026-03-18T14:42:40.069Z", "lat": 47.46841955084472, "lng": 9.625423495264805}, {"ts": "2026-03-18T14:42:41.661Z", "lat": 47.46841590910759, "lng": 9.62542069178161}, {"ts": "2026-03-18T14:42:41.662Z", "lat": 47.46841590910759, "lng": 9.62542069178161}, {"ts": "2026-03-18T14:42:42.074Z", "lat": 47.46841459896957, "lng": 9.625419713654269}, {"ts": "2026-03-18T14:42:42.075Z", "lat": 47.46841459896957, "lng": 9.625419713654269}, {"ts": "2026-03-18T14:42:43.077Z", "lat": 47.46841512207101, "lng": 9.625428695266255}, {"ts": "2026-03-18T14:42:43.077Z", "lat": 47.46841512207101, "lng": 9.625428695266255}, {"ts": "2026-03-18T14:42:44.079Z", "lat": 47.46841480425191, "lng": 9.625428253310227}, {"ts": "2026-03-18T14:42:44.079Z", "lat": 47.46841480425191, "lng": 9.625428253310227}, {"ts": "2026-03-18T14:42:45.074Z", "lat": 47.46841478219829, "lng": 9.62543019533779}, {"ts": "2026-03-18T14:42:45.074Z", "lat": 47.46841478219829, "lng": 9.62543019533779}, {"ts": "2026-03-18T14:42:46.078Z", "lat": 47.46841790118477, "lng": 9.62543019533779}, {"ts": "2026-03-18T14:42:46.078Z", "lat": 47.46841790118477, "lng": 9.62543019533779}, {"ts": "2026-03-18T14:42:47.071Z", "lat": 47.46841454454204, "lng": 9.62543678587726}, {"ts": "2026-03-18T14:42:47.071Z", "lat": 47.46841454454204, "lng": 9.62543678587726}]	Aufmaß!	\N	abgeschlossen	\N	\N	\N	\N	2026-03-17 15:59:06.73982+00	2026-03-18 14:42:47.664561+00	0	[]	Fritsch Franz	\N	e18f190a	2	\N	0.00	f	\N	2026-03-18	Sala 11	6833	Österreich	1	[]	Fraxern	0.00	11:30:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
20	1	Heim & Haus	862311	3	Stefano	2	\N	\N	\N	\N	0	0	0	0.00	0.00	[]	Tel: 00436765636179	\N	geplant	\N	\N	\N	\N	2026-03-18 17:39:31.603402+00	\N	0	[]	Wolfgang Lampert	\N	\N	1	\N	0.00	f	\N	2026-03-31	Lorenz-Schertler-Strasse 17	6922	Österreich	0	[]	Wolfurt	0.00	08:00:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
15	1	Heim & Haus	858806	1	Superuser	2	2026-03-20 14:10:40.479+00	2026-03-20 14:47:03.857506+00	2026-03-20 16:52:31.907821+00	2026-03-20 17:57:15.867125+00	36	125	65	25.00	25.00	[{"ts": "2026-03-20T14:46:50.091Z", "acc": 5, "lat": 47.35652622540715, "lng": 9.675263918508099}, {"ts": "2026-03-20T14:46:50.092Z", "acc": 5, "lat": 47.35652622540715, "lng": 9.675263918508099}, {"ts": "2026-03-20T14:46:50.703Z", "acc": 37, "lat": 47.35681237657769, "lng": 9.675322417731266}, {"ts": "2026-03-20T14:46:51.984Z", "acc": 29, "lat": 47.35681056403418, "lng": 9.675333663200323}, {"ts": "2026-03-20T14:46:53.403Z", "acc": 32, "lat": 47.35670586320833, "lng": 9.675273456370393}, {"ts": "2026-03-20T14:46:54.429Z", "acc": 21, "lat": 47.35661815268051, "lng": 9.675305832359141}, {"ts": "2026-03-20T14:46:55.449Z", "acc": 17, "lat": 47.35662493458224, "lng": 9.675285457033308}, {"ts": "2026-03-20T14:46:56.446Z", "acc": 14, "lat": 47.35657432675257, "lng": 9.675303028364963}, {"ts": "2026-03-20T14:46:57.068Z", "acc": 9, "lat": 47.356522966769646, "lng": 9.67530815204851}, {"ts": "2026-03-20T14:46:58.067Z", "acc": 7, "lat": 47.356498435596286, "lng": 9.675319081127897}, {"ts": "2026-03-20T14:46:59.075Z", "acc": 6, "lat": 47.35649640810161, "lng": 9.675311288387748}, {"ts": "2026-03-20T14:47:00.079Z", "acc": 6, "lat": 47.356496934440365, "lng": 9.6753094586986}, {"ts": "2026-03-20T14:47:01.073Z", "acc": 6, "lat": 47.356496793832505, "lng": 9.675307610959777}, {"ts": "2026-03-20T14:47:02.071Z", "acc": 6, "lat": 47.35649436048191, "lng": 9.675314985077556}, {"ts": "2026-03-20T14:47:03.072Z", "acc": 5, "lat": 47.35649141733767, "lng": 9.675319438671552}, {"ts": "2026-03-20T17:07:46.157Z", "acc": 6, "lat": 47.33299674614108, "lng": 9.640583325340494}, {"ts": "2026-03-20T17:07:47.089Z", "acc": 6, "lat": 47.333000215010635, "lng": 9.640578318422893}, {"ts": "2026-03-20T17:07:47.089Z", "acc": 6, "lat": 47.333000215010635, "lng": 9.640578318422893}, {"ts": "2026-03-20T17:07:48.084Z", "acc": 6, "lat": 47.33300417535317, "lng": 9.640578789628668}, {"ts": "2026-03-20T17:07:48.084Z", "acc": 6, "lat": 47.33300417535317, "lng": 9.640578789628668}, {"ts": "2026-03-20T17:07:49.088Z", "acc": 6, "lat": 47.33300417535317, "lng": 9.640578789628668}, {"ts": "2026-03-20T17:07:49.088Z", "acc": 6, "lat": 47.33300417535317, "lng": 9.640578789628668}, {"ts": "2026-03-20T17:07:50.086Z", "acc": 5, "lat": 47.33300417535317, "lng": 9.640578789628668}, {"ts": "2026-03-20T17:07:50.086Z", "acc": 5, "lat": 47.33300417535317, "lng": 9.640578789628668}, {"ts": "2026-03-20T17:07:51.084Z", "acc": 5, "lat": 47.33300417535317, "lng": 9.640578789628668}, {"ts": "2026-03-20T17:07:51.084Z", "acc": 5, "lat": 47.33300417535317, "lng": 9.640578789628668}, {"ts": "2026-03-20T17:07:52.086Z", "acc": 6, "lat": 47.33301105040537, "lng": 9.640572660844922}, {"ts": "2026-03-20T17:07:52.086Z", "acc": 6, "lat": 47.33301105040537, "lng": 9.640572660844922}, {"ts": "2026-03-20T17:07:53.090Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:53.090Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:54.086Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:54.086Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:55.085Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:55.085Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:56.090Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:56.090Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:57.088Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:57.088Z", "acc": 6, "lat": 47.333012877664174, "lng": 9.64057143450828}, {"ts": "2026-03-20T17:07:58.088Z", "acc": 6, "lat": 47.33301325306685, "lng": 9.640577083282746}, {"ts": "2026-03-20T17:07:58.088Z", "acc": 6, "lat": 47.33301325306685, "lng": 9.640577083282746}, {"ts": "2026-03-20T17:07:59.089Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:07:59.090Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:00.087Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:00.087Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:01.086Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:01.086Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:02.086Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:02.086Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:03.085Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:03.085Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:04.085Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:04.085Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:05.088Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:05.088Z", "acc": 6, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:06.086Z", "acc": 7, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:06.086Z", "acc": 7, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:07.086Z", "acc": 7, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:07.086Z", "acc": 7, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:08.087Z", "acc": 7, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:08.087Z", "acc": 7, "lat": 47.333013207256975, "lng": 9.640577148970397}, {"ts": "2026-03-20T17:08:09.085Z", "acc": 7, "lat": 47.33300161984734, "lng": 9.64058668913307}, {"ts": "2026-03-20T17:08:09.085Z", "acc": 7, "lat": 47.33300161984734, "lng": 9.64058668913307}, {"ts": "2026-03-20T17:08:10.086Z", "acc": 7, "lat": 47.33300161984734, "lng": 9.64058668913307}, {"ts": "2026-03-20T17:08:10.086Z", "acc": 7, "lat": 47.33300161984734, "lng": 9.64058668913307}, {"ts": "2026-03-20T17:08:11.091Z", "acc": 7, "lat": 47.3329971071463, "lng": 9.640587752876444}, {"ts": "2026-03-20T17:08:11.091Z", "acc": 7, "lat": 47.3329971071463, "lng": 9.640587752876444}, {"ts": "2026-03-20T17:08:12.079Z", "acc": 7, "lat": 47.33299710665865, "lng": 9.640587745837287}, {"ts": "2026-03-20T17:08:12.079Z", "acc": 7, "lat": 47.33299710665865, "lng": 9.640587745837287}, {"ts": "2026-03-20T17:08:13.083Z", "acc": 7, "lat": 47.33299710665865, "lng": 9.640587745837287}, {"ts": "2026-03-20T17:08:13.087Z", "acc": 7, "lat": 47.33299710665865, "lng": 9.640587745837287}, {"ts": "2026-03-20T17:12:00.566Z", "acc": 6, "lat": 47.34116278646894, "lng": 9.63107447510106}, {"ts": "2026-03-20T17:12:00.566Z", "acc": 6, "lat": 47.34116278646894, "lng": 9.63107447510106}, {"ts": "2026-03-20T17:12:01.177Z", "acc": 6, "lat": 47.341171792474476, "lng": 9.631078065801352}, {"ts": "2026-03-20T17:12:01.178Z", "acc": 6, "lat": 47.341171792474476, "lng": 9.631078065801352}, {"ts": "2026-03-20T17:12:02.172Z", "acc": 6, "lat": 47.34117514745383, "lng": 9.631072474058008}, {"ts": "2026-03-20T17:12:02.172Z", "acc": 6, "lat": 47.34117514745383, "lng": 9.631072474058008}, {"ts": "2026-03-20T17:57:09.849Z", "acc": 20, "lat": 47.4685997318963, "lng": 9.625371769131169}, {"ts": "2026-03-20T17:57:09.849Z", "acc": 20, "lat": 47.4685997318963, "lng": 9.625371769131169}, {"ts": "2026-03-20T17:57:09.938Z", "acc": 17, "lat": 47.468571002155855, "lng": 9.625366531206993}, {"ts": "2026-03-20T17:57:09.939Z", "acc": 17, "lat": 47.468571002155855, "lng": 9.625366531206993}, {"ts": "2026-03-20T17:57:14.097Z", "acc": 17, "lat": 47.46857100228825, "lng": 9.62536653123113}, {"ts": "2026-03-20T17:57:14.097Z", "acc": 17, "lat": 47.46857100228825, "lng": 9.62536653123113}, {"ts": "2026-03-20T17:57:14.341Z", "acc": 16, "lat": 47.46857340257935, "lng": 9.625335929165077}, {"ts": "2026-03-20T17:57:14.341Z", "acc": 16, "lat": 47.46857340257935, "lng": 9.625335929165077}]	\N	\N	abgeschlossen	\N	\N	\N	\N	2026-03-18 17:26:11.52071+00	2026-03-20 17:57:15.867125+00	0	[]	Franz-Schelling	\N	407ee813	2	\N	0.00	t	Extraanfahrt letztes Mal und nun einkleben der gewindestange 	2026-03-20	Oberer Stockenweg 1b	6845	Österreich	0	[]	Hohenems	0.00	\N	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
18	2	Hornbach	77153353	3	Stefano	2	\N	\N	\N	\N	0	0	0	0.00	0.00	[]	Tel: 068110726634	\N	geplant	\N	\N	\N	\N	2026-03-18 17:34:37.151432+00	\N	0	[]	Roland Scheidbach	\N	\N	1	\N	0.00	f	\N	\N	Sieberweg 16a	6800	Österreich	0	[]	Feldkirch	0.00	\N	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
27	3	Blank	123456789	8	Michi	2	2026-03-23 07:28:20.286041+00	2026-03-23 07:28:36.610909+00	2026-03-23 07:28:40.694685+00	2026-03-23 09:35:33.948519+00	0	0	0	10.00	0.00	[{"ts": "2026-03-23T07:28:32.112Z", "acc": 35, "lat": 47.46869316888408, "lng": 9.62535540329229}, {"ts": "2026-03-23T07:28:32.144Z", "acc": 35, "lat": 47.46869316888408, "lng": 9.62535540329229}, {"ts": "2026-03-23T07:28:32.593Z", "acc": 35, "lat": 47.46871331808407, "lng": 9.625355955518717}]	\N	\N	abgeschlossen	\N	\N	\N	\N	2026-03-23 07:28:20.178569+00	2026-03-23 09:35:33.948519+00	0	[]	safdfsghjdhj	\N	\N	1	\N	0.00	f	\N	2026-03-23	\N	\N	Österreich	0	[]	\N	0.00	10:00:00	120	0.00	0.00	f	\N	[]	2.000	11.00	0.0000	0.2500	60.00	40.00	35.00	55.00	\N	\N	f	montage
30	1	Heim & Haus	858595	3	Stefano	2	\N	\N	\N	\N	0	0	0	0.00	0.00	[]	DFR montieren tel:00436605482601	\N	geplant	\N	\N	\N	\N	2026-03-23 14:19:36.535326+00	\N	0	[]	Pfeiffer Dominic	\N	\N	1	\N	0.00	f	\N	2026-03-27	Törggenweg 4	6850	Österreich	0	[]	Dornbirn	0.00	09:00:00	120	0.00	0.00	f	\N	[]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	montage
\.


--
-- Data for Name: push_log; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.push_log (id, gesendet_am, gesendet_von, empfaenger, nachricht, erfolg, fehler) FROM stdin;
\.


--
-- Data for Name: push_subscriptions; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.push_subscriptions (id, mitarbeiter_id, mitarbeiter_name, subscription_json, erstellt_am) FROM stdin;
23	3	Stefano	{"endpoint":"https://fcm.googleapis.com/fcm/send/fXsqgpkMsQ4:APA91bGh99DWAawBAnYjaWRjDjS46BdNoNT2iHS_jFWz4SE55ZLwyR7yfmiOCo79H3FBT-sBpVOGRHCYpUrz5ewre5E65gUBwWkG8PBk_33T3LiWEztLwTF5AGI4Ljhd47iPM_dGNJ1z","expirationTime":null,"keys":{"p256dh":"BJRJeGSW1781ixwj0quyf1XYtDdS6kJRUsXEB9-W-iGraoiD1Xfsf6iqxedUsg2FbGg2Ow2LkagXeJTijtcSr5M","auth":"Umer4yo6QKkTQxx3yoXhAw"}}	2026-03-16 10:18:38.649044
14	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/eLdwpQ_tbM4:APA91bFwB0itVkUz7xpn5kWysalXEGhwv60eJolh81DZuKHjhHG_0ZMwCmgY74A5t_ENAovWu5xbTNIAFOoHGq6ZTk28-HTBJ-BUlqZJet9SdSllt95TscSVZo9XpVcxCsNT2fmV_oeL","expirationTime":null,"keys":{"p256dh":"BExWFIlPNaYHG1YDwnI_ECys_FFtpFyI7SV_Fz4X6zFmwCgiB2aoI6eiXigu4TUTF4Ez_J6FWgYt0H6vrpoyBrk","auth":"jvKO5y8_wE1kZyZqK61zoA"}}	2026-03-16 18:18:18.111876
13	6	Roman Dall	{"endpoint":"https://permanently-removed.invalid/fcm/send/f_VhreDcoGQ:APA91bEZJIaZgbp9qoBcNdisghrkJpvZmZVw4mcv3dJuPpFPC-cHQe4LaZ7vweNyFnvSlbOq65kQGdTdBqK1lS5T6K9yxlq-NVKhXndTdS9XWYzNvMPgYX8mMdaRpB_L3DtMjaw-QLvy","expirationTime":null,"keys":{"p256dh":"BJFRk8dlp97prfI4TFVBtHYUM89vRpGR944PKeIZN40uRUJQG-O6a0JRFKnSCMgmnr6zYBzY9Xq3JEADUzJnxIA","auth":"thQCtYg2C1bj7L9liVkuJQ"}}	2026-03-16 12:00:34.829594
10	5	Steffi	{"endpoint":"https://web.push.apple.com/QCXUC0ZfInHWEfl7uSzQJXND3YFH6t-ZomdafHf3jj_bmOzmX5Cu985xfCblHl8rys0tUOFzUYfohvFI_MfVgMG5hcCN7EV-I-uam3Tq5xr59HJY8mXokvMgaWB-QwHUrcmdgFUhMQnEPIq7c_NiACI2TbB5Q71KDIIJ1_4wb3U","keys":{"p256dh":"BLB1yf28BbE4AyY3wDYyCwVo8zJVtMxxBO7XXRHzHFAEP4QYpt1JBlyM1mWQgaW0vqLkunl-9GgC_elasQi9GFA","auth":"VYpLkEoYFNfk-GFK1buF2Q"}}	2026-03-16 06:55:10.763035
7	3	Stefano	{"endpoint":"https://fcm.googleapis.com/fcm/send/d51f77XymfA:APA91bG6hb9hVVw4zMV7J9thLXas2j4OveSUGq5gRC2it_RcOQ31Pvdv5nGwDtkjqfEUhLV4p1ZIY0rVNTXLZ6IeVDnVRZOXSNeVTdObFGyMYvr9QYGy_kj7mTV-ffg4yVx1TcYeH_S3","expirationTime":null,"keys":{"p256dh":"BDwnyUmtnK1iDLRO7OayAGoow-yj0bL95FJq4fACdiaSTW5gPlp1pfTk8r6u4WvlP-foRuy7HQRAe0Q2Z13DcBQ","auth":"A7ChtLXdDhub1bYrVw4kUQ"}}	2026-03-16 07:36:10.145489
1	9	Chiara	{"endpoint":"https://web.push.apple.com/QHGwPLlApO0day6U6N2sROwTxZBbriQV0mCxxOGXf6RzvDTfTyAVo1FZVeDlhMD7IOGhh4zZg9tSiSQbb2Fbjg68rG3cUHBtllFCcMTioTrGM-jlX3MJkUS1s56lN1xMIGVl4edb4KCKwqdTETfEVLMMD7KMbI6IhWSwJl4sd8Y","keys":{"p256dh":"BEq2kuk_H4tSYtfYyhYc_iPYy3BzAYZYz91LvPU_xM8VykQ5Q0QDHSFhM_pBEQL70fsYMbeGNuxNnja96IliTkc","auth":"QIdtX2YLfPVmgyk0VcqN4g"}}	2026-03-16 06:36:42.927416
16	1	Superuser	{"endpoint":"https://web.push.apple.com/QP7lclq75VsPUl9yURiYVZ-42TNU72NLR4cppQZSpuhoEVdsx9Q5utfpJ-_FQENXQcWkEmUqO3HX1vFqLCZVwC4w_oVG2lcuay1yxex62GPmLodbtwfqD2jWWL4fAFB5-eMkskMXNi7I09E-gPwg-sWOJymcwGNZP7Ga7ZANXgc","keys":{"p256dh":"BG-xT4j-leOaedSShuW1SgFcw4-_4wGjUCuNUqhfsye01g3sVwTHbOyLPyGUIEFYq_NxSScfULO4ZTdzQMbNV_c","auth":"7PDoYUOw9BHztssVMQXacg"}}	2026-03-16 18:27:22.709814
4	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/fDNEgBlZis0:APA91bEXlkyJ1SqiM5a7kcC1y_QNSbvcZ0QUFwTEtTy9UGRrYYCC3zhgq3kcCXBDF3YaqAJBYI6-iGgvQI2yB6mWS23vEmtCfJxo_yMGbrf_ZuvwRRkjpO7MLw5XDp_SHW3h6kPAFQUJ","expirationTime":null,"keys":{"p256dh":"BD4jcWwhUcACwuHGkqV2138dD98LySvREhU6zC9Io7hNNY0T8sq1_QawwZplAOd6q1JPd6TrmXDneReGATmPu_E","auth":"Gg9bUYluXUmffqAESt6Y6g"}}	2026-03-16 06:51:32.003228
24	3	Stefano	{"endpoint":"https://fcm.googleapis.com/fcm/send/fPt32BwFIpM:APA91bGgMUA81AeC30EEAQqraamKBhvIeQ6TpU_7Ytlf0xYNqev5F_HuDdbmvGJqbiid0JN_INwtyDCyg66h5_D9p7OKF2T0LU5NESzvrbJfpoMqy9X_g03w20NYVIwx-KzJzHjqIiWU","expirationTime":null,"keys":{"p256dh":"BOelk50qqOz6ZXJdFHtOcr2KCGKsvp4-B7Dm-7BCWHQcPj7-BQo9Q5XTgC6XrTstFCBe9auFOzXR8zJFvK-rk0s","auth":"uWcoOJ4Pw-DI22e7RQMXqg"}}	2026-03-18 17:21:54.092081
22	9	Chiara	{"endpoint":"https://web.push.apple.com/QJPLvURJWTZz7TgECRzLX_LZ7avSvtfuKFmKyVXTLWTMyjOJSQ8WN8KyssKGCfXBwchD0SAukCOtB7yllUIeXOzNkuddU1be9JF9M7xjgEC4ObmpqZc2qChQ8sMKOVwDHh1jBgndVUylXaIC2KiJMmgdIOVhlXDW47X5CzOmz3E","keys":{"p256dh":"BDT0SQ0HV-t6MFGoAxUaDn0x26-_V5FFCTBygv63GDFX33TP2sm7gC7VVNmkP5AxokAIwLqDakStU8ze-6bYZ3M","auth":"ndvANyT2GkVjA3aI03xZQg"}}	2026-03-16 10:04:50.561249
15	8	Michi	{"endpoint":"https://web.push.apple.com/QFQBKKmOo0TngOWE-FGdFnRj0Lw3Q4EQYI3FQNAlK_NLLqai8q3lbWVNP8HE-xpEs1NTzKClytQgMhAQSE11myb1m3GUo4U6j3IFfPssvNxFtuYX3RCjGhNIy8AIicwlp0BLZYCBpjYdBB5X5uuLGuFfqgLmXZYivBYJLXM0jiU","keys":{"p256dh":"BIGvKfFFX9jnv17qFXyimweWg0JEgjE8TQtrovfcfRGOB6IDX7zLKlN8OlTogTqdMBXa-Amhf9Ed_MGcHQBsZFw","auth":"leUaF-whsFFGdpBzFDwbBQ"}}	2026-03-16 18:25:17.507136
25	3	Stefano	{"endpoint":"https://fcm.googleapis.com/fcm/send/eXJd6vGmTyo:APA91bGde9JfLzkcTY31Tpqkok8TLFASx3p92f43gfwLgFhcO7tkNQWs2swT2qE2PdTtWVI_NomaOvhFyJFka2Ojw6P8vvI3q0fRlbdKRyR-pwPgHKWmH3GdVR38uerzWRXv1rpRyVZM","expirationTime":null,"keys":{"p256dh":"BOsE1agPmD7s4TihX2QeWcfQ8ahvXsaU_BHrhiNr8565ImknB2EfcnT8QQbOYfQ6v3uzed1B3la81a4NaLEroRI","auth":"S91hNMS1esNxkUXohdD0ow"}}	2026-03-18 17:21:54.298439
27	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/e0OEwg7rrCc:APA91bHjgNkJpCMkFccXZRCOO1GHLfwptP7Be-HEyxDUZ8RkbKcgDiK1UtLQ47iWjFRmAqO1t6-fappeZNpQcByy2SV4Tv8YQ4fk1U7ll8rkKusoWI5po2w_oRjXvUB07smhfTywRbYm","expirationTime":null,"keys":{"p256dh":"BFyCNYwDWAaPR8YkYmYiT_nKU32Z9WquOVRKtL4kJlGB-ghHCdUDqPbsGSyDgVrSa2xgFymdGaNZlvDJ6Rue0NA","auth":"vMH0vSDaHKkbaEHjo7eEbA"}}	2026-03-19 06:14:22.266053
57	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/cbEdV4V1ZhU:APA91bHSv4gGq2SJFbnF8oguXMGymuZI9TUi22Soasm3ex5YbOnSZ0xpLfXx_dZtF3crLlEmENoDjNNOhH3hgWCI872pMlIAe0csbsrcXrGI6p2Ww3pzQHRPN1BmVP_ZxSgKhCvBi6bc","expirationTime":null,"keys":{"p256dh":"BKC5-YMJqJMxFi6gIyZuACFaJOQYXtPMGTGmgHfmB2gyySCkFVMHrOjfe2lG5opkcuBVDIWIwrgW5g4o8P--YRk","auth":"4JbCOyrBtDSrG_XzD7YaZQ"}}	2026-03-21 11:21:33.415841
32	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/dWu4e61eOjc:APA91bFWXTz5QAeJYWqSFY6WyJ4zQ4orPsw55f6_xxqfSXo_fEfh18i_nrfI3EZECiVfhTrLh4iu7kgfAFN4I9sdU4d5sx8E5bhRP2Ysxp1SYlq5uUwd8kJ8VZpMoSMNgM8WmqDU-9ij","expirationTime":null,"keys":{"p256dh":"BHEhR9pKEGPlRIdJFRxnZf-upwGL4zATlWt4bI8n7c2dm52xZTSSg8nJSLBlJRoWBoYenHpdbAKGqqV_V0reyxo","auth":"hZSrpV4YkuktdmFfNRVpeg"}}	2026-03-19 07:02:04.511675
35	10	Ferdi	{"endpoint":"https://fcm.googleapis.com/fcm/send/cTMthvOJNQI:APA91bEFjnoxj9XUKy-YaCm61THJ9h4p5fLFfbw8L-RrEjJ84usP5TY3m8DBx_c7Gyy7nwk6eEUthtLQ_vzpnA42a-gVxQeLjUtdjkztj4fr95xvYIWd4CpOpKJXMXbW90fBSTYt8PTA","expirationTime":null,"keys":{"p256dh":"BK7oxMS2cDUih87oRCFKU_4tAAo0R8x3gLFZlbdoQbE2rcaOLxND6Q_cg43rSjkeiSXhw7GSdPHec4etiJVhIkg","auth":"asxUz-6DyMlnkC0llB7HMA"}}	2026-03-19 07:15:34.250304
37	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/cRQANd2_ft4:APA91bENZ0mh7kRh2KjKU9SZJNa4Mm4ItPxfD2zeXrTQgLR12NJx7EBBnrFozpR476dT2PDZBstoRsPfJO6pUO4Q6o7tjzgeIPqwGsAouFcQ1UvbedSm6-ghdjqwrqfIYKKreqlbGueV","expirationTime":null,"keys":{"p256dh":"BGOuH8bCfurVkrBYzfOUEPectP45cehjUd-nXwrSto95aCbyCbI-7ih7tOj8qbUenLeXjKNEtGw27G_OCTb_xGk","auth":"mdjAapnmVuuJkvid8VnykQ"}}	2026-03-19 11:18:04.077175
38	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/eMfrDUhAmZ8:APA91bGhC-yGDGcwb2f7v-F3TFySuCjZXqjqoOSc1kAlA1omMnLptWHMHY3Xs1gFal8OWrxaeDCVxPQXMR9oIxNqGeI-3t_8nRRfa2PfAjvHwOfG3IF5ogF-Wci2EPozUW2JVz1Wap8_","expirationTime":null,"keys":{"p256dh":"BBIhpvxw55F26_162JYAVGPgFLPG5oDKqredUVLiX4dEQDv0-HEcanLfmy8ud2YpOCTh9FX2M3wivmfSMJq9ChI","auth":"Pyu5A-3wNmy_DrGbIfH3OQ"}}	2026-03-20 05:40:07.806395
39	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/d4Mb5d9y_q8:APA91bGbrmYiGq3NMXGZa2eHDpWsXayVipwGSgCx5wUQK1eD0AEaqZJv0G0aTPdvdVBDCrsymsKkWWVLCwPAQQRJ9UFlU9Z2WolSs6qyFqeTFSIe_GAo-IKcF4VQn_MEOlz8uTmweX7Y","expirationTime":null,"keys":{"p256dh":"BDz4JryQgCBoVmYdfDxJCt5sVtRSlsUT2_l_JKEWOwh1kVCsjoFjx5-lmGRMOJbM9BVOH6-c04hnayHGesnIne4","auth":"fuLUBhghfDbrzp8ed3RyhA"}}	2026-03-20 05:48:15.28052
60	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/c6TTxMOA_P4:APA91bHEdccdFA1GeSatY1p4Bm3yH1_We--6hwVRPLdW90Hee3BNR1ztMtBECH8JLmqzq2MnsdSpMlsHACKv2CTY_ZKOi-NMRSS5n4JINL3SHIxfT5e8jkStjY9bLryGU91_TWjiyiZv","expirationTime":null,"keys":{"p256dh":"BNOBm3nDYastqcmhZVVjpcLROasYpqkY6J6lonWJLR6NxtBIspXhrdAVp9507z688XQ1R3Ixa1fzUEeCuByUDTY","auth":"sMf3UpJhxEQXLLiDOMR_xg"}}	2026-03-22 11:56:14.425577
41	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/eVH2MSsqPUM:APA91bFF0DP6f3tiJmaCpDHyUZZTbAtn_76tq2SWaOGPXqN19idRtO6ECSejKZ_cAhOxqXjs3P8lutc6UrYSwQEk_PX9OBFCXp-zjP8iNJZKrVAANk-57bvbDQ7JPmZbCnUZBUY5Zoh2","expirationTime":null,"keys":{"p256dh":"BHcBHrQx5pRR-HTvQY-Iu4zIVkTErd-fRP4OOPJD89gJHJQ6XkHOk3cZ_7ZBF6OVxKeMf4QPAP6vIJfHjQbf6i8","auth":"M557H7xGVyaHIP_B-pGMnQ"}}	2026-03-20 05:55:35.499464
61	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/eKu8K4ZNI1E:APA91bEDMqkv0ZLS73Fks4IaXoZNWXlME6cmGpID1nIeWM1cFHyNtjM3MFxioPZFkatfzv4kvh0rP37rpJu8Ht_bjccKhDhbdsCAA1dDS202tOTf87gefpvR14mPIfG30w8_eL3Udvnv","expirationTime":null,"keys":{"p256dh":"BI48gFTiCIdThOLX-x8OWPdXrOHyzXGNF-PtcIIAXjmkujZFsVI6ggwnM1PLFCG1ggJVIIpEbhHu2o73b9WpHKE","auth":"-Xs6TDZRm8QCuVsKnYn-sg"}}	2026-03-22 11:56:14.938975
67	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/cga-U5kyk7E:APA91bGnkshKpC_uHviwRLqzXxG4nEQ5iU915nWD0gOwtWTZzPuosTIa2Pjh5Y8nCNJ9J3jblGeIStmdWmumkY1IxP2E6YokgDsblDEK_XIe8T-DjfxnN_MhcSsg3IcYRZeH8PZrEA63","expirationTime":null,"keys":{"p256dh":"BDi-L_5S8d2tWaGOxjrXAnG4dG7MgB8RLPCkyda_GmmeqUw9dqmmj3HxIN9B1pvQuHIEbYDRlhLf85AnJQrdiio","auth":"sQTTDXAFrg-WVK49GKHK1A"}}	2026-03-22 16:05:44.943161
44	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/epSYGEyo7cg:APA91bE2jOpRfCeNlcw0tnoqjindkcdohC1M3M_BxJH6RD9O0jVOhD5v-bNZ8xUfnlNKAA_hXtZe7J-dl5xKwgE26VrzSTpRWUv-_fBq2tsWBkOos9gcf1vWUhgIZxT6SAIWFzWYgb67","expirationTime":null,"keys":{"p256dh":"BI4bqbNeYqYmv8yHXaCXvrfe5w3zDnqYXy4iMtqB58yyXqvrQ5_UzAx2EGwMHPTw_JlsuWMxqYm9-pEoFMaerF0","auth":"uQ6rNEWDut0wfPW7YfPEyA"}}	2026-03-20 06:02:24.960865
62	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/cB5-OsoyPmQ:APA91bHE4zliQjywj3_kAbRJd09y5-G8e1eIyZrPa-IpM1VyiX6s_2AhWRvR9hScXFN3jDeTvWdAKmUDzj-1_ZzDwGJHIwBt8-uyn6gvlO4lHWu5z6XZSmiLZHW0KqIbTy4ZGwpSuZnh","expirationTime":null,"keys":{"p256dh":"BFWl0LSGWom4MW86yIV7vXJk3ruwjtTpmgbM64abuKck2rjp3m0Cv7Upmu4MURNhi3JrxZeNhmXQSop5FidVqFE","auth":"wipkkeSoXMbgZQZ87_Zv0Q"}}	2026-03-22 12:22:50.923812
65	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/cZ2E82nLEdI:APA91bGF2KdJj-WznKPP7FoqW-4qxxnZ9hwKIJ5wX7wcdPPK6rpMonDmCC_g57IkVy8ICDup7YLE_6hW_1aQlVLR44GBh8gmsu12ajjTmqvPPTRLNVYS8oUjciWtb1jbHOMeuR7mlEmq","expirationTime":null,"keys":{"p256dh":"BHZ37hJAPCBU2frcO6WAL2MIXbGVfVb7QJvjxiEsxrGuOo7Ee-9DN6K4rRlwnf7olS3wNAYadzFwmuDzcFgrOPw","auth":"-arBsUtnllQ6ocYBf2Tf6Q"}}	2026-03-22 14:29:56.828343
53	1	Superuser	{"endpoint":"https://fcm.googleapis.com/fcm/send/d0C3EChV9Zw:APA91bESW-zqNeQ4B31WkrbOaHPeXrhatcWvoi1PRA8tNem92O4HRMSS2_UaiE_i-KXA85fNNXAeJ1nHUbdKuMMKaYuxM_5kq1ycJdroRLVL93XJdgiUz_Xp9XF7KpphJAsawB77mSJd","expirationTime":null,"keys":{"p256dh":"BNPCjuOeOsQWF4ue4LODC2U-h39s23r61ZQbNAStPYHNCrs_sM_quqPmz88PRUbv6Yiz50-FHOVeecNPNlIEmMg","auth":"gxNB_x_ah_byOyuxDrK78Q"}}	2026-03-20 07:26:36.063086
66	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/d3BPKgDZQ9g:APA91bG9jKY8zAxkovSkOQaL9iajwcc9dM-OotoIf6avIaQxF98F4UZHYG1VMLkQGkcXU07F9voBvyWHCXb93QPdzFsRZRiNZ-D9Py9ox4HgHfxGllFnvFEWZwUxt9aYQSzXl81Qbfvt","expirationTime":null,"keys":{"p256dh":"BI2rts1X4-AdnBOcnfwU9SA92xfiV1nmpLUiAtNR7Z3m-N7O8j26nCdOwqeABM72B5mwzf-XJvKOFIIO5uStwoc","auth":"MwaAo4jG_JAm9OrzpKxcFA"}}	2026-03-22 15:41:30.754694
70	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/dhanmjiTLv4:APA91bHNCwCgNlmh3wsrpc0aSXVY1d6KF4Kg8aoP5HE5svsJqZBMHxsq2JvKDvgxmoza8MAMTjmIEAwM6l8Xer3rFN9JAIGWghP3e2ki4VF5iUZc2NCgbUHfvKiBWlbFIuqN12c0PB--","expirationTime":null,"keys":{"p256dh":"BKpPM5F544pfcZ78RqGxmgDhTFIkBZIx3lH5q031Yg_aqhfFepxt0EGAbpNlfZ-MUVHcsiH9KutzWnSVZBv4g7c","auth":"loP5yGmNQyLvM-9IcLUIjQ"}}	2026-03-23 05:35:45.182387
76	3	Stefano	{"endpoint":"https://fcm.googleapis.com/fcm/send/dMoNqe7w5NQ:APA91bGLjblLt7rCucHJzmbLtuHpp-jZvfFBfAs6vTOkcncr8ZXOdbfrfDOETMOznUryblECg4Sx6hJ-mpcl0A2nPVvbW-lpYy27N8Esd4GxXZaR15tyzBw2aOhMTesv3eupxN7onVKF","expirationTime":null,"keys":{"p256dh":"BNnMJ5tof54pJMIzyLeJPrZ8MJv4yuhsEc8MF4C35LQhf-KvmvXBgY3JqQAG3NtMo_rV6T5NHnadLpSbO3jjuk4","auth":"z6jIrkXlCFPL1HB3B_xbcw"}}	2026-03-23 07:45:17.92218
77	3	Stefano	{"endpoint":"https://fcm.googleapis.com/fcm/send/fdgefaCKR8I:APA91bHbceii-5xcGIGYkSVkwEm-TLhlQ4rKxn4FLDQCLuiW8ZJHEjxS_z-eg6Gpm1X0U2hT-9i9wIDpIX2Fx0yrbJ3iPkSDobyqFFdGWZJu5heRFSs5oDSP2-VpH0E2jB4MWYaz8L_D","expirationTime":null,"keys":{"p256dh":"BNOAhGd0YYH-ptJ9p6X5powtSKTYIuGTiRSsPKVkROngKNNm8uCcB94qQzacJ1T-BGftnbKQbmXb9Uf6_LQFxGg","auth":"3tujRUUFNNk7zAOxipxt_g"}}	2026-03-23 09:42:39.30253
71	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/dE3lx4RW0OM:APA91bFuTKGUEVR-iDMLRj4kzgUxrW_hHBRDw1A6gzNxHjhmM6ve3SHBquzcIaZrscRQzObMElW2DEHm0rXEj3BxsHuRb6zAGHJg4D6JNbCdTxoVNaSkn6Xzgct67arxIsWkpOLCHMy8","expirationTime":null,"keys":{"p256dh":"BIw4-CfImjW19mLSObSltZ5jsnMxSXxlzAINjV8ldfzAqTiKOCLdsoic9RBHvNPUboZpmx6lJedRMLYLaTJDcTg","auth":"0t1j_p0COGkkkW8BatyTzA"}}	2026-03-23 07:26:08.373453
79	10	Ferdi	{"endpoint":"https://fcm.googleapis.com/fcm/send/cKKVxFISjAA:APA91bEC1VDLYZEn-ZYcDFnDFWAbQAu4Kxn7SXEdWpRs84zpLdaqNQvbqepp6byG1-AvSeTxpQK2_xQ6hqncW0JdnDUM1jzCCQLkEc9nj_kmLalNQFytmwtFFu-ZShHLWEwZT-oPXbG6","expirationTime":null,"keys":{"p256dh":"BGRI6OUAmJanmmjys3MiXGcj-Tygdh708NMPggZwgoLV2tYvm07FSnjAE1o9_7aezxQPAJvZeWsVbMM5U5GV1W0","auth":"U5U_nKI3HOecq2vZp4GKLA"}}	2026-03-23 14:14:31.567665
80	3	Stefano	{"endpoint":"https://fcm.googleapis.com/fcm/send/dOmlKbchbfY:APA91bHny7U5KAW6hVoxfqBlXBgDc2AbnHwqyylCVjvTn-LAjcCrDBhb_5eA4Ci8gAwzffOVZ8Yxru62Z81J_SQzdmn-b6Nnb4XCUc2iSrJkXSSDUj7aT0rxHfPE6USiJS7pxpo0_Ywj","expirationTime":null,"keys":{"p256dh":"BCHPf7DpeqP76nMi3WFLiXbQlBaOyU3dWIZrQExc6EIYOsZfr2-8gPvengyt2NqRhTU3E7nnbfc7F0YEmtDf-tM","auth":"EwNdrO-RDzMXpZ_RWE52pg"}}	2026-03-23 14:16:01.237368
81	3	Stefano	{"endpoint":"https://fcm.googleapis.com/fcm/send/cSjIU0RD9Pg:APA91bF3ZAfVUyeYExqTPqeK5GVFyjV8V9nLfujCaYdLBv9CyqiAyys0ymYa0YWe4hR4psZdU4P7t3RYC936d1-KFjgVH0tx_1go_iDRSa5s0Y_tcJyj7LTE4yVGKRjZO99O4VgsgReF","expirationTime":null,"keys":{"p256dh":"BCbtOcmoli54aFYN9ifAkmVyieW99Rd6a88q_CXZ8q-hwhHulgtqxSqESMt9F5-MAYZM1OJu-dkOV3E4W2R0Ql8","auth":"jLojS4o1ySx9A_ipYjXErQ"}}	2026-03-23 17:03:22.871382
82	8	Michi	{"endpoint":"https://fcm.googleapis.com/fcm/send/dapSQShLt74:APA91bH5iWJ51uxS640WTMqorOj5q2lQQryhOyyAho7TZ0wzSMuAXqKq60tcONqjsvl9jpl0IGy6YhI8IOQs7aRSpqI2xHgBJdSNRqwqsapfPSBOUfce7Uf_jjA9qyW3XB7tonpp05M6","expirationTime":null,"keys":{"p256dh":"BAGbrh8DpqZAJY3LZ1p-mJK8cA2TY7U5SVoJFKorgF-dj-0Xl_Rh8cvCLAw7fosjkLBGsPoMmTVogjH-MjQtfJc","auth":"IrOY8lPs0jdmt-U42H0F3g"}}	2026-03-23 19:06:32.59287
\.


--
-- Data for Name: system_logs; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.system_logs (id, created_at, level, aktion, ausgeloest_von, details, ip) FROM stdin;
1	2026-03-20 05:43:43.343884+00	info	server-start	system	{"port": "3001", "version": "–"}	\N
2	2026-03-20 05:48:31.347554+00	info	server-start	system	{"port": "3001", "version": "–"}	\N
3	2026-03-20 05:53:07.427758+00	warn	force-close-einsatz	Superuser	{"anlage_id": 13, "einsatz_id": "24"}	::1
4	2026-03-20 05:53:09.817901+00	warn	force-close-einsatz	Superuser	{"anlage_id": 20, "einsatz_id": "22"}	::1
5	2026-03-20 05:53:12.101914+00	warn	force-close-einsatz	Superuser	{"anlage_id": 21, "einsatz_id": "23"}	::1
6	2026-03-20 05:54:12.610767+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
7	2026-03-20 05:58:23.15898+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
8	2026-03-20 06:00:35.66488+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
9	2026-03-20 06:05:17.774097+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
10	2026-03-20 06:06:26.983478+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
11	2026-03-20 06:29:40.8116+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
12	2026-03-20 06:33:47.608354+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
13	2026-03-20 06:35:20.90314+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
14	2026-03-20 07:11:45.28056+00	info	server-start	system	{"port": "3001", "version": "1.0.0"}	\N
15	2026-03-20 07:16:58.252351+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
16	2026-03-20 07:20:41.036633+00	info	backup-erstellt	Superuser	{"datei": "solano_db_20260320_072040.sql", "groesse": 160696}	\N
17	2026-03-20 07:24:50.923811+00	info	backup-erstellt	Superuser	{"datei": "solano_db_20260320_072450.sql", "groesse": 160825}	\N
18	2026-03-20 07:28:15.028431+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
19	2026-03-20 07:31:55.743616+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
20	2026-03-20 07:33:23.490963+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": false, "uhrzeit": "02:00", "wochentage": ["0", "1", "2", "3", "4", "5", "6"]}	\N
21	2026-03-20 07:36:37.262979+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": false, "uhrzeit": "08:37", "wochentage": ["0", "1", "2", "3", "4", "5", "6"]}	\N
22	2026-03-20 07:40:26.253692+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
23	2026-03-20 07:42:32.208292+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
24	2026-03-20 08:13:05.138179+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
25	2026-03-20 08:24:13.742791+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
26	2026-03-20 08:33:46.309982+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "09:34", "wochentage": ["0", "1", "2", "3", "4", "5", "6"]}	\N
27	2026-03-20 08:34:00.286107+00	info	auto-backup	system	{"datei": "solano_db_auto_20260320_093400.sql", "groesse": 164479}	\N
28	2026-03-20 08:34:20.909085+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "02:00", "wochentage": ["0", "1", "2", "3", "4", "5", "6"]}	\N
29	2026-03-20 18:09:54.887959+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
30	2026-03-20 18:14:28.173015+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
31	2026-03-20 18:19:57.660676+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
32	2026-03-20 18:23:31.457035+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
33	2026-03-21 01:00:00.307793+00	info	auto-backup	system	{"datei": "solano_db_auto_20260321_020000.sql", "groesse": 179905}	\N
34	2026-03-21 06:42:38.261389+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
35	2026-03-21 07:06:47.262782+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
36	2026-03-21 07:18:04.577014+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
37	2026-03-21 07:29:04.241952+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
38	2026-03-21 07:34:49.772897+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
39	2026-03-21 07:40:53.897428+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
40	2026-03-21 07:52:01.913449+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
41	2026-03-21 08:00:57.754745+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
42	2026-03-21 08:03:34.075372+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
43	2026-03-21 08:14:35.7178+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
44	2026-03-21 08:24:30.760921+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
45	2026-03-21 08:28:29.551299+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
46	2026-03-21 08:34:37.349515+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
47	2026-03-21 08:41:48.82265+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
48	2026-03-21 09:03:33.158191+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
49	2026-03-21 09:15:22.170675+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
50	2026-03-21 09:22:02.726598+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
51	2026-03-21 09:30:27.103925+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
52	2026-03-21 09:40:16.602144+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
53	2026-03-21 09:42:08.519062+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
54	2026-03-21 16:24:38.776841+00	info	backup-erstellt	Superuser	{"datei": "solano_db_20260321_172438.sql", "groesse": 184148}	\N
55	2026-03-21 18:38:47.776438+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
56	2026-03-21 18:39:06.725963+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
57	2026-03-21 18:42:53.087067+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
58	2026-03-22 01:00:00.282123+00	info	auto-backup	system	{"datei": "solano_db_auto_20260322_020000.sql", "groesse": 184764}	\N
59	2026-03-22 06:45:26.749101+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
60	2026-03-22 06:54:03.793917+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
61	2026-03-22 07:03:40.140697+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
62	2026-03-22 07:06:55.783046+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
63	2026-03-22 07:07:49.58506+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "02:00", "wochentage": ["0", "1", "2", "3", "4", "5", "6"], "voll_wochentage": ["0"]}	\N
64	2026-03-22 07:08:03.283069+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260322_080757.tar.gz", "groesse": 121222783}	\N
65	2026-03-22 07:09:03.222466+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
66	2026-03-22 07:09:48.103533+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260322_080942.tar.gz", "groesse": 121222628}	\N
67	2026-03-22 07:12:00.704292+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
68	2026-03-22 07:13:45.792685+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
69	2026-03-22 07:14:49.558196+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260322_081443.tar.gz", "groesse": 121222869}	\N
70	2026-03-22 07:19:32.924286+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
71	2026-03-22 07:20:31.436069+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260322_082025.tar.gz", "groesse": 121224752}	\N
72	2026-03-22 07:24:16.425685+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
73	2026-03-22 07:55:51.68148+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
74	2026-03-22 08:26:43.304031+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
75	2026-03-22 08:30:44.101877+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
76	2026-03-22 08:38:40.424532+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
77	2026-03-22 08:49:59.232814+00	info	server-start	system	{"port": "3001", "version": "1.2.6"}	\N
78	2026-03-22 08:52:45.339637+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
79	2026-03-22 10:35:20.611451+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
80	2026-03-22 10:52:54.1901+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
81	2026-03-22 11:45:30.819798+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
82	2026-03-22 12:08:22.897964+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
83	2026-03-22 12:26:02.83108+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
84	2026-03-22 12:31:19.004111+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
85	2026-03-22 12:34:40.163777+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
86	2026-03-22 12:39:44.992023+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
87	2026-03-22 14:11:49.8532+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
88	2026-03-22 14:28:49.18765+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
89	2026-03-22 14:44:50.895355+00	info	server-start	system	{"port": "3001", "version": "1.9.1"}	\N
90	2026-03-22 16:44:52.410483+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260322_174446.tar.gz", "groesse": 121254351}	\N
91	2026-03-22 16:45:15.316665+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260322_174508.tar.gz", "groesse": 121254333}	\N
92	2026-03-23 01:00:00.344016+00	info	auto-backup	system	{"datei": "solano_db_auto_20260323_020000.sql", "groesse": 207440}	\N
93	2026-03-23 07:34:37.621364+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_auto_20260322_020000.sql"}	\N
94	2026-03-23 07:34:39.853129+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_20260321_172438.sql"}	\N
95	2026-03-23 07:34:41.717371+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_auto_20260321_020000.sql"}	\N
96	2026-03-23 07:34:43.572425+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_auto_20260320_093400.sql"}	\N
97	2026-03-23 07:34:45.594014+00	warn	backup-geloescht	Superuser	{"datei": "solano_full_20260322_080757.tar.gz"}	\N
98	2026-03-23 07:34:46.651907+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_20260320.sql"}	\N
99	2026-03-23 07:34:49.812395+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_20260320_072450.sql"}	\N
100	2026-03-23 07:34:51.657625+00	warn	backup-geloescht	Superuser	{"datei": "solano_full_20260322_080942.tar.gz"}	\N
101	2026-03-23 07:34:53.66828+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_20260320_080122.sql"}	\N
102	2026-03-23 07:34:55.962714+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_STAMP.sql"}	\N
103	2026-03-23 07:34:57.718386+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_20260320_072040.sql"}	\N
104	2026-03-23 07:34:59.552631+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_pre_bestelllisten_20260322_083412.sql"}	\N
105	2026-03-23 07:35:01.434091+00	warn	backup-geloescht	Superuser	{"datei": "solano_full_20260322_082025.tar.gz"}	\N
106	2026-03-23 07:35:03.093628+00	warn	backup-geloescht	Superuser	{"datei": "solano_full_20260322_081443.tar.gz"}	\N
107	2026-03-23 07:35:04.835669+00	warn	backup-geloescht	Superuser	{"datei": "solano_app_20260320_075942.tar.gz"}	\N
108	2026-03-23 07:35:06.657719+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_20260320_075942.sql"}	\N
109	2026-03-23 07:35:09.195196+00	warn	backup-geloescht	Superuser	{"datei": "solano_full_pre_bestelllisten_20260322_083412.tar.gz"}	\N
110	2026-03-23 07:35:10.758014+00	warn	backup-geloescht	Superuser	{"datei": "solano_full_20260322_174446.tar.gz"}	\N
111	2026-03-23 07:35:13.062308+00	warn	backup-geloescht	Superuser	{"datei": "solano_full_20260322_174508.tar.gz"}	\N
112	2026-03-23 07:35:14.802894+00	warn	backup-geloescht	Superuser	{"datei": "solano_db_auto_20260323_020000.sql"}	\N
113	2026-03-23 07:35:26.697043+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "08:36", "wochentage": ["0", "1", "2", "3", "4", "5", "6"], "voll_wochentage": ["0", "1"]}	\N
114	2026-03-23 07:37:02.93657+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "08:38", "wochentage": ["0", "1", "2", "3", "4", "5", "6"], "voll_wochentage": ["0", "1"]}	\N
115	2026-03-23 07:37:35.792953+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260323_083729.tar.gz", "groesse": 121254764}	\N
116	2026-03-23 07:38:40.987652+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260323_083835.tar.gz", "groesse": 121254707}	\N
117	2026-03-23 07:38:54.508062+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "08:39", "wochentage": ["0", "1", "2", "3", "4", "5", "6"], "voll_wochentage": []}	\N
118	2026-03-23 07:39:15.757266+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "08:40", "wochentage": ["0", "1", "2", "3", "4", "5", "6"], "voll_wochentage": []}	\N
119	2026-03-23 08:17:31.863266+00	info	server-start	system	{"port": "3001", "version": "2.0.2"}	\N
120	2026-03-23 09:35:33.957518+00	warn	force-close-projekt	Superuser	{"kunde": "safdfsghjdhj", "projekt_id": "27", "mitarbeiter": "Michi"}	::1
121	2026-03-23 09:35:42.363917+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "10:36", "wochentage": ["0", "1", "2", "3", "4", "5", "6"], "voll_wochentage": []}	\N
122	2026-03-23 09:36:05.300734+00	info	server-start	system	{"port": "3001", "version": "2.0.2"}	\N
123	2026-03-23 09:38:09.543911+00	info	server-start	system	{"port": "3001", "version": "2.0.2"}	\N
124	2026-03-23 09:40:00.262718+00	info	auto-backup	system	{"datei": "solano_db_auto_20260323_104000.sql", "groesse": 239852}	\N
125	2026-03-23 09:46:16.609913+00	info	backup-zeitplan-geaendert	Superuser	{"aktiv": true, "uhrzeit": "02:00", "wochentage": ["0", "1", "2", "3", "4", "5", "6"], "voll_wochentage": ["0"]}	\N
126	2026-03-23 14:35:10.474964+00	info	server-start	system	{"port": "3001", "version": "2.0.2"}	\N
127	2026-03-23 14:56:35.334496+00	info	server-start	system	{"port": "3001", "version": "2.0.2"}	\N
128	2026-03-23 15:57:11.206848+00	info	voll-backup-erstellt	Superuser	{"datei": "solano_full_20260323_165705.tar.gz", "groesse": 121265963}	\N
129	2026-03-23 15:57:15.682836+00	info	backup-erstellt	Superuser	{"datei": "solano_db_20260323_165715.sql", "groesse": 259382}	\N
130	2026-03-24 01:00:00.300592+00	info	auto-backup	system	{"datei": "solano_db_auto_20260324_020000.sql", "groesse": 260504}	\N
\.


--
-- Data for Name: todo_zuweisungen; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.todo_zuweisungen (todo_id, mitarbeiter_id, mitarbeiter_name) FROM stdin;
27	3	Stefano
\.


--
-- Data for Name: todos; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.todos (id, anlage_id, einsatz_id, mitarbeiter, mitarbeiter_id, beschreibung, erledigt, erstellt_am, erledigt_am, erledigt_von, zugewiesen_an_id, zugewiesen_an) FROM stdin;
27	18	6	Chiara	9	Wasserhahn keller defekt	f	2026-03-19 07:54:13.43787+00	\N	\N	3	Stefano
\.


--
-- Data for Name: todos_privat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.todos_privat (id, mitarbeiter_id, beschreibung, erledigt, erstellt_am, erledigt_am) FROM stdin;
6	1	Kleber im auto nachfüllen	f	2026-03-20 12:05:34.3364+00	\N
7	1	Bohrer 16x450	f	2026-03-20 12:49:21.623837+00	\N
10	1	GPS funktioniert überhaupt nicht	f	2026-03-20 17:07:19.347074+00	\N
22	8	Auto Abmeldung aus der App nach zwei Stunden inaktivität	f	2026-03-21 12:42:40.359415+00	\N
24	8	snake game für mittagpause einfügen	f	2026-03-21 12:45:44.311569+00	\N
25	1	Globale Suchfunktion nach allem in allen sparten und bereichen	f	2026-03-22 08:44:34.350107+00	\N
13	1	Spritpreise dürfen nicht in die vergangenheit die berechnung beeinflussen	t	2026-03-20 18:28:48.471593+00	2026-03-22 08:48:33.814+00
12	1	Feld Rapport einfügen	t	2026-03-20 18:22:54.534767+00	2026-03-22 08:48:36.313+00
11	1	To do nachträglich dazu schreiben	t	2026-03-20 17:07:40.305037+00	2026-03-22 08:48:38.641+00
9	1	Feld Sondervergütung hinzufügen	t	2026-03-20 14:20:57.338674+00	2026-03-22 08:48:40.142+00
8	1	Allgemeine Todo	t	2026-03-20 12:49:57.257527+00	2026-03-22 08:48:41.292+00
14	1	Geräteanmeldung überprüfen - 21 geräte angemeldet, davon 15x superuser, geräteanmeldung checken!	t	2026-03-20 18:29:51.519445+00	2026-03-22 08:48:45.124+00
21	8	PUSH sind dutzende geräte angemeldet	t	2026-03-21 12:42:26.492208+00	2026-03-22 13:00:15.706+00
20	8	abgeschlossene todo nicht löschen sondern durchstreichen und dann klappmenü Monat/Jahr	t	2026-03-21 11:25:46.691558+00	2026-03-22 13:00:17.993+00
19	8	To Do einfach weiter schreiben in der Zeile	t	2026-03-21 11:25:26.624198+00	2026-03-22 13:00:21.88+00
17	8	auftrag mehrmals öffnen, gar nichts stimmt daran	t	2026-03-21 11:24:03.904644+00	2026-03-22 13:00:26.072+00
16	8	Zeiterfassung SAMSTAG verschiebt ansicht und ist viel größer - selbe schrift verwenden	t	2026-03-21 11:23:50.899518+00	2026-03-22 13:00:27.773+00
15	8	Zeiterfassung: Mehrfaches kommen und gehen pro tag - Darstellung untereinander	t	2026-03-21 11:23:30.722781+00	2026-03-22 13:00:29.145+00
18	8	auftrag mehrmals öffnen - muss beim zweiten und dritten und vierten mal die stunden kilometer fahrzeit anzeigen mit den bereits geleisteten als info	t	2026-03-21 11:25:13.894359+00	2026-03-22 13:00:31.63+00
26	1	Bestellungen für Auto machen können bzpl. Kleber, schrauben, etc...	t	2026-03-22 12:59:24.845963+00	2026-03-22 16:10:09.271+00
32	8	Telefonliste bzw. Infos	f	2026-03-23 08:25:48.493532+00	\N
33	8	Feld Telefonnummer	f	2026-03-23 08:36:20.205835+00	\N
34	8	Aufmaß zum Auftrag hinzufügen	f	2026-03-23 08:39:02.384078+00	\N
35	8	Wenn Aufmaß, automatisch erneute Anfahrt für Montage selber Auftragsmummer	f	2026-03-23 08:39:29.389889+00	\N
36	8	Eigene Akte wie im psi für Hornbach aufmasse und Montagen	f	2026-03-23 08:45:24.412244+00	\N
37	8	GPS zeigt viel zu wenig 3,9 aber 5,4 waren es	f	2026-03-23 08:50:37.670284+00	\N
38	1	Auftrag - erneuter einsatz nötig automatisch nach haken aufmaß, datum Leer lassen checkbox  auftrag storniert	f	2026-03-23 09:40:08.572041+00	\N
40	1	VPN nach hause wieder einrichten (neue IP) 178.115.243.28	f	2026-03-23 09:45:13.166559+00	\N
28	1	Backup Automat funktioniert nicht	t	2026-03-23 07:39:41.224691+00	2026-03-23 09:46:57.001+00
29	1	Fehler Backup renderTapDatensicherung is not defined	t	2026-03-23 07:40:07.960471+00	2026-03-23 09:46:59.902+00
27	1	Doppelte Anmeldung von einem User in derselben Anlage abschalten!!!!	t	2026-03-22 16:10:06.360401+00	2026-03-23 09:47:05.282+00
30	1	System offene bzw laufende Einsätze zeigt nichts an, müssen von allen Mitarbeitern aufscheinen	t	2026-03-23 07:40:41.780901+00	2026-03-23 09:47:09.223+00
31	1	Projekt kann nicht abgeschlossen werden colum fz dieselpreis does not exist	t	2026-03-23 07:41:26.793361+00	2026-03-23 09:47:17.019+00
41	8	Aufmaßapp mit Plan für zaunkonfigurator	f	2026-03-23 11:40:03.970636+00	\N
42	8	Anruf aus der App ermöglichen	f	2026-03-23 11:40:29.590904+00	\N
39	8	Offene Aufträge in Karte anzeigen farbig nach Aufgabe (Aufmaß/Montage/service)	f	2026-03-23 09:42:41.130538+00	\N
43	8	Feld Telefon/Email zu nahe am handy, überlagern sich die felder	f	2026-03-23 19:13:48.13128+00	\N
\.


--
-- Data for Name: zeiterfassung; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.zeiterfassung (id, mitarbeiter_id, mitarbeiter_name, typ, zeitpunkt, datum, notiz, geaendert_von_id, geaendert_von_name, geaendert_am, original_zeitpunkt) FROM stdin;
62	3	Stefano	kommen	2026-03-18 06:33:14.045+00	2026-03-18	\N	\N	\N	\N	\N
70	8	Michi	gehen	2026-03-18 16:17:16.214+00	2026-03-18	\N	\N	\N	\N	\N
71	3	Stefano	gehen	2026-03-18 16:17:20.839+00	2026-03-18	\N	\N	\N	\N	\N
72	8	Michi	kommen	2026-03-19 04:22:38.407+00	2026-03-19	\N	\N	\N	\N	\N
73	3	Stefano	kommen	2026-03-19 07:00:55.139+00	2026-03-19	\N	\N	\N	\N	\N
90	3	Stefano	gehen	2026-03-19 17:17:07.32+00	2026-03-19	\N	\N	\N	\N	\N
114	8	Michi	kommen	2026-03-23 04:51:00+00	2026-03-23	Vergessen zu stempeln	8	Michi	2026-03-23 05:36:15.185623+00	\N
115	3	Stefano	kommen	2026-03-23 06:57:08.236+00	2026-03-23	\N	\N	\N	\N	\N
79	9	Chiara	kommen	2026-03-05 07:00:00+00	2026-03-05	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:34:29.983077+00	2026-03-05 07:00:00+00
81	9	Chiara	pause_start	2026-03-05 11:00:00+00	2026-03-05	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:34:30.081+00	2026-03-05 11:00:00+00
82	9	Chiara	pause_ende	2026-03-05 12:00:00+00	2026-03-05	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:34:30.178935+00	2026-03-05 12:00:00+00
80	9	Chiara	gehen	2026-03-05 12:30:00+00	2026-03-05	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:34:30.344355+00	2026-03-05 12:30:00+00
92	10	Ferdi	kommen	2026-03-19 07:00:00+00	2026-03-19	\N	8	Michi	2026-03-19 17:35:21.204241+00	\N
93	10	Ferdi	gehen	2026-03-19 11:00:00+00	2026-03-19	\N	8	Michi	2026-03-19 17:35:21.297548+00	\N
85	10	Ferdi	kommen	2026-03-05 07:00:00+00	2026-03-05	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:35:45.858964+00	2026-03-05 07:00:00+00
94	10	Ferdi	pause_start	2026-03-05 11:00:00+00	2026-03-05	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:35:45.958688+00	\N
95	10	Ferdi	pause_ende	2026-03-05 12:00:00+00	2026-03-05	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:35:46.054124+00	\N
96	10	Ferdi	gehen	2026-03-05 12:30:00+00	2026-03-05	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:35:46.149123+00	\N
116	6	Roman Dall	kommen	2026-03-23 10:43:09.028+00	2026-03-23	\N	\N	\N	\N	\N
117	6	Roman Dall	gehen	2026-03-23 10:49:26.382+00	2026-03-23	\N	\N	\N	\N	\N
74	9	Chiara	kommen	2026-03-19 07:00:00+00	2026-03-19		8	Michi	2026-03-19 17:36:07.516888+00	2026-03-19 07:10:02.956+00
47	8	Michi	kommen	2026-03-17 04:13:59.549+00	2026-03-17	\N	\N	\N	\N	\N
48	3	Stefano	kommen	2026-03-17 06:53:16.656+00	2026-03-17	\N	\N	\N	\N	\N
78	9	Chiara	gehen	2026-03-19 11:00:00+00	2026-03-19		8	Michi	2026-03-19 17:36:07.608827+00	2026-03-19 10:49:59.988+00
97	10	Ferdi	kommen	2026-03-12 07:00:00+00	2026-03-12	Zeitefassung noch nicht aktiv!	8	Michi	2026-03-19 17:36:38.790249+00	\N
98	10	Ferdi	gehen	2026-03-12 09:30:00+00	2026-03-12	Zeitefassung noch nicht aktiv!	8	Michi	2026-03-19 17:36:38.881989+00	\N
83	9	Chiara	kommen	2026-03-12 07:00:00+00	2026-03-12	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:37:08.151049+00	2026-03-12 07:00:00+00
91	9	Chiara	gehen	2026-03-12 09:30:00+00	2026-03-12	Zeiterfassung noch nicht aktiv!	8	Michi	2026-03-19 17:37:08.249977+00	2026-03-12 09:00:00+00
56	3	Stefano	gehen	2026-03-17 16:00:00+00	2026-03-17	\N	8	Michi	2026-03-17 16:08:36.214903+00	\N
58	8	Michi	gehen	2026-03-17 16:29:57.792+00	2026-03-17	\N	\N	\N	\N	\N
99	8	Michi	gehen	2026-03-19 17:41:00+00	2026-03-19	Admin-Ausstempelung	\N	\N	\N	\N
61	8	Michi	kommen	2026-03-18 04:15:00+00	2026-03-18	\N	8	Michi	2026-03-18 04:54:33.596563+00	2026-03-18 04:54:15.187+00
102	8	Michi	kommen	2026-03-20 05:00:00+00	2026-03-20	\N	8	Michi	2026-03-20 05:30:15.272325+00	\N
103	3	Stefano	kommen	2026-03-20 06:55:23.456+00	2026-03-20	\N	\N	\N	\N	\N
104	3	Stefano	gehen	2026-03-20 18:17:36.736+00	2026-03-20	\N	\N	\N	\N	\N
105	8	Michi	gehen	2026-03-20 18:44:29.475+00	2026-03-20	\N	\N	\N	\N	\N
106	8	Michi	kommen	2026-03-21 06:18:54.264+00	2026-03-21	\N	\N	\N	\N	\N
107	8	Michi	gehen	2026-03-21 09:51:56.948+00	2026-03-21	\N	\N	\N	\N	\N
110	8	Michi	kommen	2026-03-21 15:07:00+00	2026-03-21	\N	8	Michi	2026-03-21 18:46:08.951334+00	\N
111	8	Michi	gehen	2026-03-21 18:46:00+00	2026-03-21	\N	8	Michi	2026-03-21 18:46:09.935352+00	\N
112	8	Michi	kommen	2026-03-22 06:47:18.548+00	2026-03-22	\N	\N	\N	\N	\N
113	8	Michi	gehen	2026-03-22 15:31:54.043+00	2026-03-22	\N	\N	\N	\N	\N
118	8	Michi	gehen	2026-03-23 14:57:26.279+00	2026-03-23	\N	\N	\N	\N	\N
119	3	Stefano	gehen	2026-03-23 14:59:50.075+00	2026-03-23	\N	\N	\N	\N	\N
120	8	Michi	kommen	2026-03-23 19:06:34.62+00	2026-03-23	\N	\N	\N	\N	\N
121	8	Michi	kommen	2026-03-24 04:16:50.015+00	2026-03-24	\N	\N	\N	\N	\N
\.


--
-- Data for Name: zeiterfassung_freigabe; Type: TABLE DATA; Schema: public; Owner: solano
--

COPY public.zeiterfassung_freigabe (id, mitarbeiter_id, mitarbeiter_name, monat, freigegeben_von_id, freigegeben_von_name, freigegeben_am, notiz) FROM stdin;
\.


--
-- Name: alarm_bestaetigung_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.alarm_bestaetigung_id_seq', 14, true);


--
-- Name: alarm_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.alarm_log_id_seq', 17, true);


--
-- Name: anlagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.anlagen_id_seq', 21, true);


--
-- Name: aufgaben_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.aufgaben_id_seq', 87, true);


--
-- Name: auftraggeber_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auftraggeber_id_seq', 5, true);


--
-- Name: backup_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.backup_schedule_id_seq', 1, true);


--
-- Name: bestelllisten_artikel_kategorien_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.bestelllisten_artikel_kategorien_id_seq', 7, true);


--
-- Name: bestelllisten_eintraege_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.bestelllisten_eintraege_id_seq', 14, true);


--
-- Name: bestelllisten_kategorien_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.bestelllisten_kategorien_id_seq', 4, true);


--
-- Name: bestelllisten_stammdaten_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.bestelllisten_stammdaten_id_seq', 6, true);


--
-- Name: einsaetze_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.einsaetze_id_seq', 21, true);


--
-- Name: einsatz_fotos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.einsatz_fotos_id_seq', 20, true);


--
-- Name: erledigte_aufgaben_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.erledigte_aufgaben_id_seq', 195, true);


--
-- Name: fahrzeuge_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fahrzeuge_id_seq', 2, true);


--
-- Name: gps_tracks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.gps_tracks_id_seq', 2899, true);


--
-- Name: mitarbeiter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.mitarbeiter_id_seq', 10, true);


--
-- Name: nachrichten_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.nachrichten_id_seq', 24, true);


--
-- Name: projekt_auftraege_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projekt_auftraege_id_seq', 31, true);


--
-- Name: push_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.push_log_id_seq', 1, true);


--
-- Name: push_subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.push_subscriptions_id_seq', 82, true);


--
-- Name: system_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.system_logs_id_seq', 130, true);


--
-- Name: todos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.todos_id_seq', 27, true);


--
-- Name: todos_privat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.todos_privat_id_seq', 43, true);


--
-- Name: zeiterfassung_freigabe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.zeiterfassung_freigabe_id_seq', 1, false);


--
-- Name: zeiterfassung_id_seq; Type: SEQUENCE SET; Schema: public; Owner: solano
--

SELECT pg_catalog.setval('public.zeiterfassung_id_seq', 121, true);


--
-- Name: alarm_bestaetigung alarm_bestaetigung_alarm_id_mitarbeiter_id_key; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.alarm_bestaetigung
    ADD CONSTRAINT alarm_bestaetigung_alarm_id_mitarbeiter_id_key UNIQUE (alarm_id, mitarbeiter_id);


--
-- Name: alarm_bestaetigung alarm_bestaetigung_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.alarm_bestaetigung
    ADD CONSTRAINT alarm_bestaetigung_pkey PRIMARY KEY (id);


--
-- Name: alarm_log alarm_log_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.alarm_log
    ADD CONSTRAINT alarm_log_pkey PRIMARY KEY (id);


--
-- Name: anlagen anlagen_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.anlagen
    ADD CONSTRAINT anlagen_pkey PRIMARY KEY (id);


--
-- Name: aufgaben aufgaben_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.aufgaben
    ADD CONSTRAINT aufgaben_pkey PRIMARY KEY (id);


--
-- Name: auftraggeber auftraggeber_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auftraggeber
    ADD CONSTRAINT auftraggeber_pkey PRIMARY KEY (id);


--
-- Name: backup_schedule backup_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.backup_schedule
    ADD CONSTRAINT backup_schedule_pkey PRIMARY KEY (id);


--
-- Name: benutzer_anlage_reihenfolge benutzer_anlage_reihenfolge_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.benutzer_anlage_reihenfolge
    ADD CONSTRAINT benutzer_anlage_reihenfolge_pkey PRIMARY KEY (mitarbeiter_id, anlage_id, sparte);


--
-- Name: bestelllisten_artikel_kategorien bestelllisten_artikel_kategorien_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_artikel_kategorien
    ADD CONSTRAINT bestelllisten_artikel_kategorien_pkey PRIMARY KEY (id);


--
-- Name: bestelllisten_eintraege bestelllisten_eintraege_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_eintraege
    ADD CONSTRAINT bestelllisten_eintraege_pkey PRIMARY KEY (id);


--
-- Name: bestelllisten_kategorien bestelllisten_kategorien_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_kategorien
    ADD CONSTRAINT bestelllisten_kategorien_pkey PRIMARY KEY (id);


--
-- Name: bestelllisten_stammdaten bestelllisten_stammdaten_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_stammdaten
    ADD CONSTRAINT bestelllisten_stammdaten_pkey PRIMARY KEY (id);


--
-- Name: einsaetze einsaetze_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.einsaetze
    ADD CONSTRAINT einsaetze_pkey PRIMARY KEY (id);


--
-- Name: einsatz_fotos einsatz_fotos_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.einsatz_fotos
    ADD CONSTRAINT einsatz_fotos_pkey PRIMARY KEY (id);


--
-- Name: erledigte_aufgaben erledigte_aufgaben_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.erledigte_aufgaben
    ADD CONSTRAINT erledigte_aufgaben_pkey PRIMARY KEY (id);


--
-- Name: fahrzeug_einstellungen fahrzeug_einstellungen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fahrzeug_einstellungen
    ADD CONSTRAINT fahrzeug_einstellungen_pkey PRIMARY KEY (id);


--
-- Name: fahrzeuge fahrzeuge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fahrzeuge
    ADD CONSTRAINT fahrzeuge_pkey PRIMARY KEY (id);


--
-- Name: feiertage feiertage_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.feiertage
    ADD CONSTRAINT feiertage_pkey PRIMARY KEY (datum);


--
-- Name: firma_einstellungen firma_einstellungen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firma_einstellungen
    ADD CONSTRAINT firma_einstellungen_pkey PRIMARY KEY (id);


--
-- Name: gps_tracks gps_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.gps_tracks
    ADD CONSTRAINT gps_tracks_pkey PRIMARY KEY (id);


--
-- Name: kalender_events kalender_events_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.kalender_events
    ADD CONSTRAINT kalender_events_pkey PRIMARY KEY (id);


--
-- Name: kalender_settings kalender_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.kalender_settings
    ADD CONSTRAINT kalender_settings_pkey PRIMARY KEY (id);


--
-- Name: ma_kosten_einstellungen ma_kosten_einstellungen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ma_kosten_einstellungen
    ADD CONSTRAINT ma_kosten_einstellungen_pkey PRIMARY KEY (id);


--
-- Name: mitarbeiter mitarbeiter_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.mitarbeiter
    ADD CONSTRAINT mitarbeiter_pkey PRIMARY KEY (id);


--
-- Name: nachrichten nachrichten_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.nachrichten
    ADD CONSTRAINT nachrichten_pkey PRIMARY KEY (id);


--
-- Name: projekt_auftraege projekt_auftraege_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projekt_auftraege
    ADD CONSTRAINT projekt_auftraege_pkey PRIMARY KEY (id);


--
-- Name: push_log push_log_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.push_log
    ADD CONSTRAINT push_log_pkey PRIMARY KEY (id);


--
-- Name: push_subscriptions push_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT push_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: system_logs system_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.system_logs
    ADD CONSTRAINT system_logs_pkey PRIMARY KEY (id);


--
-- Name: todo_zuweisungen todo_zuweisungen_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.todo_zuweisungen
    ADD CONSTRAINT todo_zuweisungen_pkey PRIMARY KEY (todo_id, mitarbeiter_id);


--
-- Name: todos todos_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_pkey PRIMARY KEY (id);


--
-- Name: todos_privat todos_privat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todos_privat
    ADD CONSTRAINT todos_privat_pkey PRIMARY KEY (id);


--
-- Name: zeiterfassung_freigabe zeiterfassung_freigabe_mitarbeiter_id_monat_key; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.zeiterfassung_freigabe
    ADD CONSTRAINT zeiterfassung_freigabe_mitarbeiter_id_monat_key UNIQUE (mitarbeiter_id, monat);


--
-- Name: zeiterfassung_freigabe zeiterfassung_freigabe_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.zeiterfassung_freigabe
    ADD CONSTRAINT zeiterfassung_freigabe_pkey PRIMARY KEY (id);


--
-- Name: zeiterfassung zeiterfassung_pkey; Type: CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.zeiterfassung
    ADD CONSTRAINT zeiterfassung_pkey PRIMARY KEY (id);


--
-- Name: idx_einsaetze_no_dup; Type: INDEX; Schema: public; Owner: solano
--

CREATE UNIQUE INDEX idx_einsaetze_no_dup ON public.einsaetze USING btree (mitarbeiter_id, anlage_id, datum, COALESCE(sparte, 'winterdienst'::character varying)) WHERE (end_zeit IS NULL);


--
-- Name: idx_projekt_ag; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projekt_ag ON public.projekt_auftraege USING btree (auftraggeber_id);


--
-- Name: idx_projekt_datum; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projekt_datum ON public.projekt_auftraege USING btree (erstellt_am);


--
-- Name: idx_projekt_ma; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projekt_ma ON public.projekt_auftraege USING btree (mitarbeiter_id);


--
-- Name: idx_push_endpoint; Type: INDEX; Schema: public; Owner: solano
--

CREATE UNIQUE INDEX idx_push_endpoint ON public.push_subscriptions USING btree ((((subscription_json)::json ->> 'endpoint'::text)));


--
-- Name: idx_system_logs_created; Type: INDEX; Schema: public; Owner: solano
--

CREATE INDEX idx_system_logs_created ON public.system_logs USING btree (created_at DESC);


--
-- Name: alarm_bestaetigung alarm_bestaetigung_alarm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.alarm_bestaetigung
    ADD CONSTRAINT alarm_bestaetigung_alarm_id_fkey FOREIGN KEY (alarm_id) REFERENCES public.alarm_log(id) ON DELETE CASCADE;


--
-- Name: alarm_bestaetigung alarm_bestaetigung_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.alarm_bestaetigung
    ADD CONSTRAINT alarm_bestaetigung_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id) ON DELETE CASCADE;


--
-- Name: aufgaben aufgaben_anlage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.aufgaben
    ADD CONSTRAINT aufgaben_anlage_id_fkey FOREIGN KEY (anlage_id) REFERENCES public.anlagen(id) ON DELETE CASCADE;


--
-- Name: benutzer_anlage_reihenfolge benutzer_anlage_reihenfolge_anlage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.benutzer_anlage_reihenfolge
    ADD CONSTRAINT benutzer_anlage_reihenfolge_anlage_id_fkey FOREIGN KEY (anlage_id) REFERENCES public.anlagen(id) ON DELETE CASCADE;


--
-- Name: benutzer_anlage_reihenfolge benutzer_anlage_reihenfolge_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.benutzer_anlage_reihenfolge
    ADD CONSTRAINT benutzer_anlage_reihenfolge_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id) ON DELETE CASCADE;


--
-- Name: bestelllisten_eintraege bestelllisten_eintraege_bestellt_von_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_eintraege
    ADD CONSTRAINT bestelllisten_eintraege_bestellt_von_fkey FOREIGN KEY (bestellt_von) REFERENCES public.mitarbeiter(id) ON DELETE SET NULL;


--
-- Name: bestelllisten_eintraege bestelllisten_eintraege_erstellt_von_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_eintraege
    ADD CONSTRAINT bestelllisten_eintraege_erstellt_von_fkey FOREIGN KEY (erstellt_von) REFERENCES public.mitarbeiter(id) ON DELETE SET NULL;


--
-- Name: bestelllisten_eintraege bestelllisten_eintraege_kategorie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_eintraege
    ADD CONSTRAINT bestelllisten_eintraege_kategorie_id_fkey FOREIGN KEY (kategorie_id) REFERENCES public.bestelllisten_kategorien(id) ON DELETE SET NULL;


--
-- Name: bestelllisten_eintraege bestelllisten_eintraege_stammdaten_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_eintraege
    ADD CONSTRAINT bestelllisten_eintraege_stammdaten_id_fkey FOREIGN KEY (stammdaten_id) REFERENCES public.bestelllisten_stammdaten(id) ON DELETE SET NULL;


--
-- Name: bestelllisten_stammdaten bestelllisten_stammdaten_artikel_kategorie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_stammdaten
    ADD CONSTRAINT bestelllisten_stammdaten_artikel_kategorie_id_fkey FOREIGN KEY (artikel_kategorie_id) REFERENCES public.bestelllisten_artikel_kategorien(id) ON DELETE SET NULL;


--
-- Name: bestelllisten_stammdaten bestelllisten_stammdaten_erstellt_von_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_stammdaten
    ADD CONSTRAINT bestelllisten_stammdaten_erstellt_von_fkey FOREIGN KEY (erstellt_von) REFERENCES public.mitarbeiter(id);


--
-- Name: bestelllisten_stammdaten bestelllisten_stammdaten_kategorie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.bestelllisten_stammdaten
    ADD CONSTRAINT bestelllisten_stammdaten_kategorie_id_fkey FOREIGN KEY (kategorie_id) REFERENCES public.bestelllisten_kategorien(id) ON DELETE SET NULL;


--
-- Name: einsaetze einsaetze_anlage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.einsaetze
    ADD CONSTRAINT einsaetze_anlage_id_fkey FOREIGN KEY (anlage_id) REFERENCES public.anlagen(id);


--
-- Name: einsaetze einsaetze_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.einsaetze
    ADD CONSTRAINT einsaetze_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id);


--
-- Name: einsatz_fotos einsatz_fotos_einsatz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.einsatz_fotos
    ADD CONSTRAINT einsatz_fotos_einsatz_id_fkey FOREIGN KEY (einsatz_id) REFERENCES public.einsaetze(id) ON DELETE CASCADE;


--
-- Name: erledigte_aufgaben erledigte_aufgaben_aufgabe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.erledigte_aufgaben
    ADD CONSTRAINT erledigte_aufgaben_aufgabe_id_fkey FOREIGN KEY (aufgabe_id) REFERENCES public.aufgaben(id) ON DELETE CASCADE;


--
-- Name: erledigte_aufgaben erledigte_aufgaben_einsatz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.erledigte_aufgaben
    ADD CONSTRAINT erledigte_aufgaben_einsatz_id_fkey FOREIGN KEY (einsatz_id) REFERENCES public.einsaetze(id) ON DELETE CASCADE;


--
-- Name: gps_tracks gps_tracks_einsatz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.gps_tracks
    ADD CONSTRAINT gps_tracks_einsatz_id_fkey FOREIGN KEY (einsatz_id) REFERENCES public.einsaetze(id) ON DELETE CASCADE;


--
-- Name: nachrichten nachrichten_an_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.nachrichten
    ADD CONSTRAINT nachrichten_an_id_fkey FOREIGN KEY (an_id) REFERENCES public.mitarbeiter(id) ON DELETE CASCADE;


--
-- Name: nachrichten nachrichten_von_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.nachrichten
    ADD CONSTRAINT nachrichten_von_id_fkey FOREIGN KEY (von_id) REFERENCES public.mitarbeiter(id) ON DELETE SET NULL;


--
-- Name: projekt_auftraege projekt_auftraege_auftraggeber_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projekt_auftraege
    ADD CONSTRAINT projekt_auftraege_auftraggeber_id_fkey FOREIGN KEY (auftraggeber_id) REFERENCES public.auftraggeber(id) ON DELETE SET NULL;


--
-- Name: projekt_auftraege projekt_auftraege_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projekt_auftraege
    ADD CONSTRAINT projekt_auftraege_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id) ON DELETE SET NULL;


--
-- Name: push_subscriptions push_subscriptions_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT push_subscriptions_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id) ON DELETE CASCADE;


--
-- Name: todo_zuweisungen todo_zuweisungen_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.todo_zuweisungen
    ADD CONSTRAINT todo_zuweisungen_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id) ON DELETE CASCADE;


--
-- Name: todo_zuweisungen todo_zuweisungen_todo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.todo_zuweisungen
    ADD CONSTRAINT todo_zuweisungen_todo_id_fkey FOREIGN KEY (todo_id) REFERENCES public.todos(id) ON DELETE CASCADE;


--
-- Name: todos todos_anlage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_anlage_id_fkey FOREIGN KEY (anlage_id) REFERENCES public.anlagen(id);


--
-- Name: todos todos_einsatz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_einsatz_id_fkey FOREIGN KEY (einsatz_id) REFERENCES public.einsaetze(id);


--
-- Name: todos_privat todos_privat_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todos_privat
    ADD CONSTRAINT todos_privat_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id) ON DELETE CASCADE;


--
-- Name: todos todos_zugewiesen_an_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_zugewiesen_an_id_fkey FOREIGN KEY (zugewiesen_an_id) REFERENCES public.mitarbeiter(id) ON DELETE SET NULL;


--
-- Name: zeiterfassung_freigabe zeiterfassung_freigabe_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.zeiterfassung_freigabe
    ADD CONSTRAINT zeiterfassung_freigabe_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id) ON DELETE CASCADE;


--
-- Name: zeiterfassung zeiterfassung_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: solano
--

ALTER TABLE ONLY public.zeiterfassung
    ADD CONSTRAINT zeiterfassung_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(id) ON DELETE CASCADE;


--
-- Name: TABLE auftraggeber; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auftraggeber TO solano;


--
-- Name: SEQUENCE auftraggeber_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auftraggeber_id_seq TO solano;


--
-- Name: TABLE fahrzeug_einstellungen; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.fahrzeug_einstellungen TO solano;


--
-- Name: TABLE fahrzeuge; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.fahrzeuge TO solano;


--
-- Name: SEQUENCE fahrzeuge_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.fahrzeuge_id_seq TO solano;


--
-- Name: TABLE firma_einstellungen; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.firma_einstellungen TO solano;


--
-- Name: TABLE ma_kosten_einstellungen; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ma_kosten_einstellungen TO solano;


--
-- Name: TABLE projekt_auftraege; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.projekt_auftraege TO solano;


--
-- Name: SEQUENCE projekt_auftraege_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.projekt_auftraege_id_seq TO solano;


--
-- Name: TABLE todos_privat; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.todos_privat TO solano;


--
-- Name: SEQUENCE todos_privat_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.todos_privat_id_seq TO solano;


--
-- PostgreSQL database dump complete
--

\unrestrict tVgF0g8ZGs7go9IoEDj9k9khuQ7xA7iD5Sm4JCaTCmyP3dA0UwpgauvMIQENlNi

