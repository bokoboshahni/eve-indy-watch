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

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: market_type_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_type_stats (
    market_id bigint NOT NULL,
    type_id bigint NOT NULL,
    buy_order_count bigint,
    buy_price_avg numeric,
    buy_price_max numeric,
    buy_price_min numeric,
    buy_price_sum numeric,
    buy_volume_avg numeric,
    buy_volume_max bigint,
    buy_volume_min bigint,
    buy_volume_sum bigint,
    sell_order_count bigint,
    sell_price_avg numeric,
    sell_price_max numeric,
    sell_price_min numeric,
    sell_price_sum numeric,
    sell_volume_avg numeric,
    sell_volume_max bigint,
    sell_volume_min bigint,
    sell_volume_sum bigint,
    "time" timestamp without time zone NOT NULL
);


--
-- Name: _hyper_1_1_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1_chunk (
    CONSTRAINT constraint_1 CHECK ((("time" >= '2021-12-09 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: alliances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alliances (
    id bigint NOT NULL,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL,
    icon_url_128 text,
    icon_url_64 text,
    name text NOT NULL,
    ticker text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    api_corporation_id bigint,
    appraisal_market_id bigint,
    main_market_id bigint,
    zkb_fetched_at timestamp without time zone,
    zkb_sync_enabled boolean
);


--
-- Name: alliances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alliances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alliances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alliances_id_seq OWNED BY public.alliances.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name text NOT NULL,
    published boolean NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.characters (
    id bigint NOT NULL,
    alliance_id bigint,
    corporation_id bigint NOT NULL,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL,
    name text NOT NULL,
    portrait_url_128 text,
    portrait_url_256 text,
    portrait_url_512 text,
    portrait_url_64 text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;


--
-- Name: constellations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.constellations (
    id bigint NOT NULL,
    region_id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: constellations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.constellations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: constellations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.constellations_id_seq OWNED BY public.constellations.id;


--
-- Name: contract_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contract_events (
    id bigint NOT NULL,
    alliance_id bigint,
    contract_id bigint NOT NULL,
    corporation_id bigint NOT NULL,
    collateral numeric,
    event text NOT NULL,
    price numeric,
    reward numeric,
    "time" timestamp without time zone NOT NULL
);


--
-- Name: contract_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contract_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contract_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contract_events_id_seq OWNED BY public.contract_events.id;


--
-- Name: contract_fittings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contract_fittings (
    contract_id bigint NOT NULL,
    fitting_id bigint NOT NULL,
    quantity integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    items jsonb,
    similarity numeric
);


--
-- Name: contract_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contract_items (
    id bigint NOT NULL,
    contract_id bigint NOT NULL,
    type_id bigint NOT NULL,
    is_included boolean NOT NULL,
    is_singleton boolean NOT NULL,
    quantity integer NOT NULL,
    raw_quantity integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: contract_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contract_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contract_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contract_items_id_seq OWNED BY public.contract_items.id;


--
-- Name: contract_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contract_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    event text NOT NULL,
    whodunnit text,
    object jsonb,
    object_changes jsonb
);


--
-- Name: contract_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contract_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contract_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contract_versions_id_seq OWNED BY public.contract_versions.id;


--
-- Name: contracts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contracts (
    id bigint NOT NULL,
    acceptor_type character varying,
    acceptor_id bigint,
    assignee_type character varying NOT NULL,
    assignee_id bigint NOT NULL,
    end_location_type character varying,
    end_location_id bigint,
    issuer_id bigint NOT NULL,
    issuer_corporation_id bigint NOT NULL,
    start_location_type character varying,
    start_location_id bigint,
    accepted_at timestamp without time zone,
    availability text NOT NULL,
    buyout numeric,
    collateral numeric,
    completed_at timestamp without time zone,
    days_to_complete integer,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_items_exception jsonb,
    esi_items_expires_at timestamp without time zone,
    esi_items_last_modified_at timestamp without time zone,
    esi_last_modified_at timestamp without time zone NOT NULL,
    expired_at timestamp without time zone NOT NULL,
    for_corporation boolean,
    issued_at timestamp without time zone NOT NULL,
    price numeric,
    reward numeric,
    status text NOT NULL,
    title text,
    type text NOT NULL,
    volume numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contracts_id_seq OWNED BY public.contracts.id;


--
-- Name: corporations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.corporations (
    id bigint NOT NULL,
    alliance_id bigint,
    esi_expires_at timestamp without time zone,
    esi_last_modified_at timestamp without time zone,
    icon_url_128 text,
    icon_url_256 text,
    icon_url_64 text,
    name text NOT NULL,
    ticker text NOT NULL,
    url text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    esi_authorization_id integer,
    esi_contracts_expires_at timestamp without time zone,
    esi_contracts_last_modified_at timestamp without time zone,
    contract_sync_enabled boolean,
    npc boolean
);


--
-- Name: corporations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.corporations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: corporations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.corporations_id_seq OWNED BY public.corporations.id;


--
-- Name: esi_authorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.esi_authorizations (
    id bigint NOT NULL,
    character_id bigint NOT NULL,
    user_id bigint NOT NULL,
    access_token_ciphertext text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    refresh_token_ciphertext text NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: esi_authorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.esi_authorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: esi_authorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.esi_authorizations_id_seq OWNED BY public.esi_authorizations.id;


--
-- Name: fitting_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fitting_items (
    id bigint NOT NULL,
    fitting_id bigint NOT NULL,
    type_id bigint NOT NULL,
    quantity integer NOT NULL,
    offline boolean
);


--
-- Name: fitting_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fitting_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fitting_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fitting_items_id_seq OWNED BY public.fitting_items.id;


--
-- Name: fittings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fittings (
    id bigint NOT NULL,
    owner_type character varying NOT NULL,
    owner_id bigint NOT NULL,
    type_id bigint NOT NULL,
    discarded_at timestamp without time zone,
    name text NOT NULL,
    original text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    pinned boolean,
    desired_count integer
);


--
-- Name: fittings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fittings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fittings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fittings_id_seq OWNED BY public.fittings.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    name text NOT NULL,
    published boolean NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: industry_index_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industry_index_snapshots (
    id bigint NOT NULL,
    solar_system_id bigint NOT NULL,
    copying numeric,
    duplicating numeric,
    invention numeric,
    manufacturing numeric,
    "none" numeric,
    reaction numeric,
    researching_material_efficiency numeric,
    researching_technology numeric,
    researching_time_efficiency numeric,
    reverse_engineering numeric,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL
);


--
-- Name: industry_index_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industry_index_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industry_index_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industry_index_snapshots_id_seq OWNED BY public.industry_index_snapshots.id;


--
-- Name: inventory_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_flags (
    id bigint NOT NULL,
    name text NOT NULL,
    text text NOT NULL,
    "order" integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: inventory_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_flags_id_seq OWNED BY public.inventory_flags.id;


--
-- Name: killmail_attackers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.killmail_attackers (
    id bigint NOT NULL,
    alliance_id bigint,
    character_id bigint,
    corporation_id bigint,
    killmail_id bigint NOT NULL,
    ship_type_id bigint,
    weapon_type_id bigint,
    damage_done integer NOT NULL,
    faction_id bigint,
    final_blow boolean NOT NULL,
    security_status numeric NOT NULL
);


--
-- Name: killmail_attackers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.killmail_attackers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: killmail_attackers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.killmail_attackers_id_seq OWNED BY public.killmail_attackers.id;


--
-- Name: killmail_fittings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.killmail_fittings (
    fitting_id bigint NOT NULL,
    killmail_id bigint NOT NULL,
    items jsonb,
    similarity numeric NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: killmail_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.killmail_items (
    id bigint NOT NULL,
    killmail_id bigint NOT NULL,
    type_id bigint,
    ancestry text,
    ancestry_depth integer,
    quantity_destroyed bigint,
    quantity_dropped bigint,
    singleton integer NOT NULL,
    flag_id bigint
);


--
-- Name: killmail_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.killmail_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: killmail_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.killmail_items_id_seq OWNED BY public.killmail_items.id;


--
-- Name: killmails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.killmails (
    id bigint NOT NULL,
    alliance_id bigint,
    character_id bigint,
    corporation_id bigint,
    ship_type_id bigint NOT NULL,
    solar_system_id bigint,
    awox boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    damage_taken integer NOT NULL,
    faction_id bigint,
    killmail_hash text NOT NULL,
    moon_id bigint,
    npc boolean NOT NULL,
    points integer NOT NULL,
    position_x numeric NOT NULL,
    position_y numeric NOT NULL,
    position_z numeric NOT NULL,
    solo boolean NOT NULL,
    "time" timestamp without time zone NOT NULL,
    war_id bigint,
    zkb_dropped_value numeric NOT NULL,
    zkb_destroyed_value numeric NOT NULL,
    zkb_total_value numeric NOT NULL
);


--
-- Name: killmails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.killmails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: killmails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.killmails_id_seq OWNED BY public.killmails.id;


--
-- Name: market_fitting_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_fitting_snapshots (
    market_id bigint NOT NULL,
    fitting_id bigint NOT NULL,
    quantity integer NOT NULL,
    items jsonb NOT NULL,
    price_buy numeric,
    price_sell numeric,
    price_split numeric,
    "time" timestamp without time zone NOT NULL
);


--
-- Name: market_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_groups (
    id bigint NOT NULL,
    ancestry text,
    ancestry_depth integer,
    description text NOT NULL,
    name text NOT NULL,
    parent_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: market_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.market_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: market_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.market_groups_id_seq OWNED BY public.market_groups.id;


--
-- Name: market_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_locations (
    market_id bigint NOT NULL,
    location_type character varying NOT NULL,
    location_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: market_order_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_order_snapshots (
    location_type character varying NOT NULL,
    location_id bigint NOT NULL,
    solar_system_id bigint NOT NULL,
    type_id bigint NOT NULL,
    duration integer NOT NULL,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    kind text NOT NULL,
    min_volume integer NOT NULL,
    order_id bigint NOT NULL,
    price numeric NOT NULL,
    range text NOT NULL,
    volume_remain integer NOT NULL,
    volume_total integer NOT NULL
);


--
-- Name: market_price_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_price_snapshots (
    id bigint NOT NULL,
    type_id bigint NOT NULL,
    adjusted_price numeric,
    average_price numeric,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL
);


--
-- Name: market_price_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.market_price_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: market_price_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.market_price_snapshots_id_seq OWNED BY public.market_price_snapshots.id;


--
-- Name: markets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.markets (
    id bigint NOT NULL,
    owner_type character varying,
    owner_id bigint,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: markets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.markets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: markets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.markets_id_seq OWNED BY public.markets.id;


--
-- Name: pghero_query_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pghero_query_stats (
    id bigint NOT NULL,
    database text,
    "user" text,
    query text,
    query_hash bigint,
    total_time double precision,
    calls bigint,
    captured_at timestamp without time zone
);


--
-- Name: pghero_query_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pghero_query_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pghero_query_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pghero_query_stats_id_seq OWNED BY public.pghero_query_stats.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    esi_authorization_id bigint,
    esi_market_orders_expires_at timestamp without time zone,
    esi_market_orders_last_modified_at timestamp without time zone,
    market_order_sync_enabled boolean
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: rollups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rollups (
    id bigint NOT NULL,
    name text NOT NULL,
    "interval" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    dimensions jsonb DEFAULT '{}'::jsonb NOT NULL,
    value numeric
);


--
-- Name: rollups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rollups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rollups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rollups_id_seq OWNED BY public.rollups.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: solar_systems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solar_systems (
    id bigint NOT NULL,
    constellation_id bigint NOT NULL,
    name text NOT NULL,
    security numeric NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solar_systems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solar_systems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solar_systems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solar_systems_id_seq OWNED BY public.solar_systems.id;


--
-- Name: stations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stations (
    id bigint NOT NULL,
    owner_id bigint NOT NULL,
    solar_system_id bigint NOT NULL,
    type_id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: stations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stations_id_seq OWNED BY public.stations.id;


--
-- Name: structures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.structures (
    id bigint NOT NULL,
    owner_id bigint,
    solar_system_id bigint,
    type_id bigint,
    esi_expires_at timestamp without time zone,
    esi_last_modified_at timestamp without time zone,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    esi_authorization_id bigint,
    esi_market_orders_expires_at timestamp without time zone,
    esi_market_orders_last_modified_at timestamp without time zone,
    market_order_sync_enabled boolean
);


--
-- Name: structures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.structures_id_seq OWNED BY public.structures.id;


--
-- Name: types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.types (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    market_group_id bigint,
    description text,
    name text NOT NULL,
    packaged_volume numeric,
    portion_size integer,
    published boolean,
    volume numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    character_id bigint NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    roles text[] DEFAULT '{}'::text[]
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id bigint NOT NULL,
    created_at timestamp without time zone,
    event text NOT NULL,
    whodunnit text,
    object jsonb,
    object_changes jsonb
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: alliances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alliances ALTER COLUMN id SET DEFAULT nextval('public.alliances_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);


--
-- Name: constellations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.constellations ALTER COLUMN id SET DEFAULT nextval('public.constellations_id_seq'::regclass);


--
-- Name: contract_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_events ALTER COLUMN id SET DEFAULT nextval('public.contract_events_id_seq'::regclass);


--
-- Name: contract_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_items ALTER COLUMN id SET DEFAULT nextval('public.contract_items_id_seq'::regclass);


--
-- Name: contract_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_versions ALTER COLUMN id SET DEFAULT nextval('public.contract_versions_id_seq'::regclass);


--
-- Name: contracts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contracts ALTER COLUMN id SET DEFAULT nextval('public.contracts_id_seq'::regclass);


--
-- Name: corporations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporations ALTER COLUMN id SET DEFAULT nextval('public.corporations_id_seq'::regclass);


--
-- Name: esi_authorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.esi_authorizations ALTER COLUMN id SET DEFAULT nextval('public.esi_authorizations_id_seq'::regclass);


--
-- Name: fitting_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitting_items ALTER COLUMN id SET DEFAULT nextval('public.fitting_items_id_seq'::regclass);


--
-- Name: fittings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fittings ALTER COLUMN id SET DEFAULT nextval('public.fittings_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: industry_index_snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industry_index_snapshots ALTER COLUMN id SET DEFAULT nextval('public.industry_index_snapshots_id_seq'::regclass);


--
-- Name: inventory_flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_flags ALTER COLUMN id SET DEFAULT nextval('public.inventory_flags_id_seq'::regclass);


--
-- Name: killmail_attackers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_attackers ALTER COLUMN id SET DEFAULT nextval('public.killmail_attackers_id_seq'::regclass);


--
-- Name: killmail_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_items ALTER COLUMN id SET DEFAULT nextval('public.killmail_items_id_seq'::regclass);


--
-- Name: killmails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmails ALTER COLUMN id SET DEFAULT nextval('public.killmails_id_seq'::regclass);


--
-- Name: market_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_groups ALTER COLUMN id SET DEFAULT nextval('public.market_groups_id_seq'::regclass);


--
-- Name: market_price_snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_price_snapshots ALTER COLUMN id SET DEFAULT nextval('public.market_price_snapshots_id_seq'::regclass);


--
-- Name: markets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.markets ALTER COLUMN id SET DEFAULT nextval('public.markets_id_seq'::regclass);


--
-- Name: pghero_query_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pghero_query_stats ALTER COLUMN id SET DEFAULT nextval('public.pghero_query_stats_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: rollups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rollups ALTER COLUMN id SET DEFAULT nextval('public.rollups_id_seq'::regclass);


--
-- Name: solar_systems id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solar_systems ALTER COLUMN id SET DEFAULT nextval('public.solar_systems_id_seq'::regclass);


--
-- Name: stations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations ALTER COLUMN id SET DEFAULT nextval('public.stations_id_seq'::regclass);


--
-- Name: structures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures ALTER COLUMN id SET DEFAULT nextval('public.structures_id_seq'::regclass);


--
-- Name: types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: alliances alliances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alliances
    ADD CONSTRAINT alliances_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: constellations constellations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.constellations
    ADD CONSTRAINT constellations_pkey PRIMARY KEY (id);


--
-- Name: contract_events contract_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_events
    ADD CONSTRAINT contract_events_pkey PRIMARY KEY (id);


--
-- Name: contract_items contract_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_items
    ADD CONSTRAINT contract_items_pkey PRIMARY KEY (id);


--
-- Name: contract_versions contract_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_versions
    ADD CONSTRAINT contract_versions_pkey PRIMARY KEY (id);


--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);


--
-- Name: corporations corporations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporations
    ADD CONSTRAINT corporations_pkey PRIMARY KEY (id);


--
-- Name: esi_authorizations esi_authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.esi_authorizations
    ADD CONSTRAINT esi_authorizations_pkey PRIMARY KEY (id);


--
-- Name: fitting_items fitting_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitting_items
    ADD CONSTRAINT fitting_items_pkey PRIMARY KEY (id);


--
-- Name: fittings fittings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fittings
    ADD CONSTRAINT fittings_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: industry_index_snapshots industry_index_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industry_index_snapshots
    ADD CONSTRAINT industry_index_snapshots_pkey PRIMARY KEY (id);


--
-- Name: inventory_flags inventory_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_flags
    ADD CONSTRAINT inventory_flags_pkey PRIMARY KEY (id);


--
-- Name: killmail_attackers killmail_attackers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_attackers
    ADD CONSTRAINT killmail_attackers_pkey PRIMARY KEY (id);


--
-- Name: killmail_items killmail_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_items
    ADD CONSTRAINT killmail_items_pkey PRIMARY KEY (id);


--
-- Name: killmails killmails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmails
    ADD CONSTRAINT killmails_pkey PRIMARY KEY (id);


--
-- Name: market_groups market_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_groups
    ADD CONSTRAINT market_groups_pkey PRIMARY KEY (id);


--
-- Name: market_price_snapshots market_price_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_price_snapshots
    ADD CONSTRAINT market_price_snapshots_pkey PRIMARY KEY (id);


--
-- Name: markets markets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pkey PRIMARY KEY (id);


--
-- Name: pghero_query_stats pghero_query_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pghero_query_stats
    ADD CONSTRAINT pghero_query_stats_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: rollups rollups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rollups
    ADD CONSTRAINT rollups_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: solar_systems solar_systems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solar_systems
    ADD CONSTRAINT solar_systems_pkey PRIMARY KEY (id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: structures structures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT structures_pkey PRIMARY KEY (id);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: _hyper_1_1_chunk_index_market_type_stats_on_market_id; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_index_market_type_stats_on_market_id ON _timescaledb_internal._hyper_1_1_chunk USING btree (market_id);


--
-- Name: _hyper_1_1_chunk_index_market_type_stats_on_type_id; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_index_market_type_stats_on_type_id ON _timescaledb_internal._hyper_1_1_chunk USING btree (type_id);


--
-- Name: _hyper_1_1_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_1_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_1_1_chunk USING btree (market_id, type_id, "time");


--
-- Name: _hyper_1_1_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_1_1_chunk USING btree ("time" DESC);


--
-- Name: index_alliances_on_appraisal_market_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alliances_on_appraisal_market_id ON public.alliances USING btree (appraisal_market_id);


--
-- Name: index_alliances_on_main_market_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alliances_on_main_market_id ON public.alliances USING btree (main_market_id);


--
-- Name: index_characters_on_alliance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_characters_on_alliance_id ON public.characters USING btree (alliance_id);


--
-- Name: index_characters_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_characters_on_corporation_id ON public.characters USING btree (corporation_id);


--
-- Name: index_constellations_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_constellations_on_region_id ON public.constellations USING btree (region_id);


--
-- Name: index_contract_events_on_alliance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contract_events_on_alliance_id ON public.contract_events USING btree (alliance_id);


--
-- Name: index_contract_events_on_contract_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contract_events_on_contract_id ON public.contract_events USING btree (contract_id);


--
-- Name: index_contract_events_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contract_events_on_corporation_id ON public.contract_events USING btree (corporation_id);


--
-- Name: index_contract_fittings_on_contract_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contract_fittings_on_contract_id ON public.contract_fittings USING btree (contract_id);


--
-- Name: index_contract_fittings_on_fitting_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contract_fittings_on_fitting_id ON public.contract_fittings USING btree (fitting_id);


--
-- Name: index_contract_items_on_contract_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contract_items_on_contract_id ON public.contract_items USING btree (contract_id);


--
-- Name: index_contract_items_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contract_items_on_type_id ON public.contract_items USING btree (type_id);


--
-- Name: index_contract_versions_on_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contract_versions_on_item ON public.contract_versions USING btree (item_type, item_id);


--
-- Name: index_contracts_on_acceptor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_acceptor ON public.contracts USING btree (acceptor_type, acceptor_id);


--
-- Name: index_contracts_on_assignee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_assignee ON public.contracts USING btree (assignee_type, assignee_id);


--
-- Name: index_contracts_on_end_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_end_location ON public.contracts USING btree (end_location_type, end_location_id);


--
-- Name: index_contracts_on_issuer_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_issuer_corporation_id ON public.contracts USING btree (issuer_corporation_id);


--
-- Name: index_contracts_on_issuer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_issuer_id ON public.contracts USING btree (issuer_id);


--
-- Name: index_contracts_on_start_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_start_location ON public.contracts USING btree (start_location_type, start_location_id);


--
-- Name: index_contracts_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_status ON public.contracts USING btree (status);


--
-- Name: index_contracts_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_title ON public.contracts USING btree (title);


--
-- Name: index_contracts_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contracts_on_type ON public.contracts USING btree (type);


--
-- Name: index_corporations_on_alliance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_alliance_id ON public.corporations USING btree (alliance_id);


--
-- Name: index_corporations_on_esi_authorization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_esi_authorization_id ON public.corporations USING btree (esi_authorization_id);


--
-- Name: index_esi_authorizations_on_character_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_esi_authorizations_on_character_id ON public.esi_authorizations USING btree (character_id);


--
-- Name: index_esi_authorizations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_esi_authorizations_on_user_id ON public.esi_authorizations USING btree (user_id);


--
-- Name: index_fitting_items_on_fitting_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fitting_items_on_fitting_id ON public.fitting_items USING btree (fitting_id);


--
-- Name: index_fitting_items_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fitting_items_on_type_id ON public.fitting_items USING btree (type_id);


--
-- Name: index_fittings_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fittings_on_discarded_at ON public.fittings USING btree (discarded_at);


--
-- Name: index_fittings_on_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fittings_on_owner ON public.fittings USING btree (owner_type, owner_id);


--
-- Name: index_fittings_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fittings_on_type_id ON public.fittings USING btree (type_id);


--
-- Name: index_groups_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_groups_on_category_id ON public.groups USING btree (category_id);


--
-- Name: index_industry_index_snapshots_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industry_index_snapshots_on_solar_system_id ON public.industry_index_snapshots USING btree (solar_system_id);


--
-- Name: index_inventory_flags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_flags_on_name ON public.inventory_flags USING btree (name);


--
-- Name: index_killmail_attackers_on_alliance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_attackers_on_alliance_id ON public.killmail_attackers USING btree (alliance_id);


--
-- Name: index_killmail_attackers_on_character_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_attackers_on_character_id ON public.killmail_attackers USING btree (character_id);


--
-- Name: index_killmail_attackers_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_attackers_on_corporation_id ON public.killmail_attackers USING btree (corporation_id);


--
-- Name: index_killmail_attackers_on_killmail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_attackers_on_killmail_id ON public.killmail_attackers USING btree (killmail_id);


--
-- Name: index_killmail_attackers_on_ship_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_attackers_on_ship_type_id ON public.killmail_attackers USING btree (ship_type_id);


--
-- Name: index_killmail_attackers_on_weapon_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_attackers_on_weapon_type_id ON public.killmail_attackers USING btree (weapon_type_id);


--
-- Name: index_killmail_fittings_on_fitting_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_fittings_on_fitting_id ON public.killmail_fittings USING btree (fitting_id);


--
-- Name: index_killmail_fittings_on_killmail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_fittings_on_killmail_id ON public.killmail_fittings USING btree (killmail_id);


--
-- Name: index_killmail_items_on_ancestry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_items_on_ancestry ON public.killmail_items USING btree (ancestry text_pattern_ops);


--
-- Name: index_killmail_items_on_flag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_items_on_flag_id ON public.killmail_items USING btree (flag_id);


--
-- Name: index_killmail_items_on_killmail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_items_on_killmail_id ON public.killmail_items USING btree (killmail_id);


--
-- Name: index_killmail_items_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmail_items_on_type_id ON public.killmail_items USING btree (type_id);


--
-- Name: index_killmails_on_alliance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmails_on_alliance_id ON public.killmails USING btree (alliance_id);


--
-- Name: index_killmails_on_character_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmails_on_character_id ON public.killmails USING btree (character_id);


--
-- Name: index_killmails_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmails_on_corporation_id ON public.killmails USING btree (corporation_id);


--
-- Name: index_killmails_on_ship_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmails_on_ship_type_id ON public.killmails USING btree (ship_type_id);


--
-- Name: index_killmails_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_killmails_on_solar_system_id ON public.killmails USING btree (solar_system_id);


--
-- Name: index_market_fitting_snapshots_on_fitting_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_fitting_snapshots_on_fitting_id ON public.market_fitting_snapshots USING btree (fitting_id);


--
-- Name: index_market_fitting_snapshots_on_market_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_fitting_snapshots_on_market_id ON public.market_fitting_snapshots USING btree (market_id);


--
-- Name: index_market_groups_on_ancestry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_groups_on_ancestry ON public.market_groups USING btree (ancestry text_pattern_ops);


--
-- Name: index_market_locations_on_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_locations_on_location ON public.market_locations USING btree (location_type, location_id);


--
-- Name: index_market_locations_on_market_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_locations_on_market_id ON public.market_locations USING btree (market_id);


--
-- Name: index_market_order_snapshots_on_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_order_snapshots_on_location ON public.market_order_snapshots USING btree (location_type, location_id);


--
-- Name: index_market_order_snapshots_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_order_snapshots_on_solar_system_id ON public.market_order_snapshots USING btree (solar_system_id);


--
-- Name: index_market_order_snapshots_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_order_snapshots_on_type_id ON public.market_order_snapshots USING btree (type_id);


--
-- Name: index_market_price_snapshots_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_price_snapshots_on_type_id ON public.market_price_snapshots USING btree (type_id);


--
-- Name: index_market_type_stats_on_market_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_type_stats_on_market_id ON public.market_type_stats USING btree (market_id);


--
-- Name: index_market_type_stats_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_type_stats_on_type_id ON public.market_type_stats USING btree (type_id);


--
-- Name: index_markets_on_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_markets_on_owner ON public.markets USING btree (owner_type, owner_id);


--
-- Name: index_pghero_query_stats_on_database_and_captured_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pghero_query_stats_on_database_and_captured_at ON public.pghero_query_stats USING btree (database, captured_at);


--
-- Name: index_regions_on_esi_authorization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regions_on_esi_authorization_id ON public.regions USING btree (esi_authorization_id);


--
-- Name: index_solar_systems_on_constellation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solar_systems_on_constellation_id ON public.solar_systems USING btree (constellation_id);


--
-- Name: index_stations_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_owner_id ON public.stations USING btree (owner_id);


--
-- Name: index_stations_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_solar_system_id ON public.stations USING btree (solar_system_id);


--
-- Name: index_stations_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_type_id ON public.stations USING btree (type_id);


--
-- Name: index_structures_on_esi_authorization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_structures_on_esi_authorization_id ON public.structures USING btree (esi_authorization_id);


--
-- Name: index_structures_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_structures_on_owner_id ON public.structures USING btree (owner_id);


--
-- Name: index_structures_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_structures_on_solar_system_id ON public.structures USING btree (solar_system_id);


--
-- Name: index_structures_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_structures_on_type_id ON public.structures USING btree (type_id);


--
-- Name: index_types_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_group_id ON public.types USING btree (group_id);


--
-- Name: index_types_on_market_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_market_group_id ON public.types USING btree (market_group_id);


--
-- Name: index_unique_contract_fittings; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_contract_fittings ON public.contract_fittings USING btree (contract_id, fitting_id);


--
-- Name: index_unique_industry_index_snapshots; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_industry_index_snapshots ON public.industry_index_snapshots USING btree (solar_system_id, esi_last_modified_at);


--
-- Name: index_unique_market_fitting_snapshots; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_fitting_snapshots ON public.market_fitting_snapshots USING btree (market_id, fitting_id, "time");


--
-- Name: index_unique_market_order_snapshots; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_order_snapshots ON public.market_order_snapshots USING btree (location_id, order_id, esi_last_modified_at);


--
-- Name: index_unique_market_price_snapshots; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_price_snapshots ON public.market_price_snapshots USING btree (type_id, esi_last_modified_at);


--
-- Name: index_unique_market_type_stats; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_type_stats ON public.market_type_stats USING btree (market_id, type_id, "time");


--
-- Name: index_unique_rollups; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_rollups ON public.rollups USING btree (name, "interval", "time", dimensions);


--
-- Name: index_users_on_character_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_character_id ON public.users USING btree (character_id);


--
-- Name: index_versions_on_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item ON public.versions USING btree (item_type, item_id);


--
-- Name: market_type_stats_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX market_type_stats_time_idx ON public.market_type_stats USING btree ("time" DESC);


--
-- Name: market_type_stats ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.market_type_stats FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: _hyper_1_1_chunk 1_1_fk_rails_8ae0916104; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1_chunk
    ADD CONSTRAINT "1_1_fk_rails_8ae0916104" FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- Name: _hyper_1_1_chunk 1_2_fk_rails_ab10873f6b; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1_chunk
    ADD CONSTRAINT "1_2_fk_rails_ab10873f6b" FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: corporations fk_rails_0551373140; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporations
    ADD CONSTRAINT fk_rails_0551373140 FOREIGN KEY (alliance_id) REFERENCES public.alliances(id);


--
-- Name: contract_events fk_rails_125b5a94e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_events
    ADD CONSTRAINT fk_rails_125b5a94e8 FOREIGN KEY (alliance_id) REFERENCES public.alliances(id);


--
-- Name: corporations fk_rails_25cac28994; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporations
    ADD CONSTRAINT fk_rails_25cac28994 FOREIGN KEY (esi_authorization_id) REFERENCES public.esi_authorizations(id);


--
-- Name: alliances fk_rails_29023e5cc0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alliances
    ADD CONSTRAINT fk_rails_29023e5cc0 FOREIGN KEY (main_market_id) REFERENCES public.markets(id);


--
-- Name: market_locations fk_rails_2c79e89ad9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_locations
    ADD CONSTRAINT fk_rails_2c79e89ad9 FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- Name: killmail_fittings fk_rails_2dd8f83885; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_fittings
    ADD CONSTRAINT fk_rails_2dd8f83885 FOREIGN KEY (fitting_id) REFERENCES public.fittings(id);


--
-- Name: contract_items fk_rails_34a4a66de8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_items
    ADD CONSTRAINT fk_rails_34a4a66de8 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: fitting_items fk_rails_39bd8308da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitting_items
    ADD CONSTRAINT fk_rails_39bd8308da FOREIGN KEY (fitting_id) REFERENCES public.fittings(id);


--
-- Name: killmails fk_rails_3d9efa89e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmails
    ADD CONSTRAINT fk_rails_3d9efa89e3 FOREIGN KEY (solar_system_id) REFERENCES public.solar_systems(id);


--
-- Name: killmail_items fk_rails_4726c84c13; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_items
    ADD CONSTRAINT fk_rails_4726c84c13 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: killmails fk_rails_473a7434be; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmails
    ADD CONSTRAINT fk_rails_473a7434be FOREIGN KEY (ship_type_id) REFERENCES public.types(id);


--
-- Name: killmail_attackers fk_rails_5387666c4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_attackers
    ADD CONSTRAINT fk_rails_5387666c4c FOREIGN KEY (weapon_type_id) REFERENCES public.types(id);


--
-- Name: stations fk_rails_579e8e9070; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT fk_rails_579e8e9070 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: characters fk_rails_5ed7aa5594; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT fk_rails_5ed7aa5594 FOREIGN KEY (corporation_id) REFERENCES public.corporations(id);


--
-- Name: killmail_attackers fk_rails_611319d6fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_attackers
    ADD CONSTRAINT fk_rails_611319d6fe FOREIGN KEY (killmail_id) REFERENCES public.killmails(id);


--
-- Name: structures fk_rails_625050ce6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT fk_rails_625050ce6a FOREIGN KEY (solar_system_id) REFERENCES public.solar_systems(id);


--
-- Name: industry_index_snapshots fk_rails_63155c1e83; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industry_index_snapshots
    ADD CONSTRAINT fk_rails_63155c1e83 FOREIGN KEY (solar_system_id) REFERENCES public.solar_systems(id);


--
-- Name: contract_events fk_rails_6766670cd1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_events
    ADD CONSTRAINT fk_rails_6766670cd1 FOREIGN KEY (contract_id) REFERENCES public.contracts(id);


--
-- Name: stations fk_rails_6ea166210e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT fk_rails_6ea166210e FOREIGN KEY (owner_id) REFERENCES public.corporations(id);


--
-- Name: alliances fk_rails_6f7443e553; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alliances
    ADD CONSTRAINT fk_rails_6f7443e553 FOREIGN KEY (appraisal_market_id) REFERENCES public.markets(id);


--
-- Name: market_fitting_snapshots fk_rails_72488bcbd3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_fitting_snapshots
    ADD CONSTRAINT fk_rails_72488bcbd3 FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- Name: regions fk_rails_8739326a99; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT fk_rails_8739326a99 FOREIGN KEY (esi_authorization_id) REFERENCES public.esi_authorizations(id);


--
-- Name: types fk_rails_8937e46b8b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT fk_rails_8937e46b8b FOREIGN KEY (market_group_id) REFERENCES public.market_groups(id);


--
-- Name: market_type_stats fk_rails_8ae0916104; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_type_stats
    ADD CONSTRAINT fk_rails_8ae0916104 FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- Name: fittings fk_rails_8f60a789b9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fittings
    ADD CONSTRAINT fk_rails_8f60a789b9 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: characters fk_rails_9603b90279; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT fk_rails_9603b90279 FOREIGN KEY (alliance_id) REFERENCES public.alliances(id);


--
-- Name: contract_fittings fk_rails_9bf253a179; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_fittings
    ADD CONSTRAINT fk_rails_9bf253a179 FOREIGN KEY (contract_id) REFERENCES public.contracts(id);


--
-- Name: constellations fk_rails_a5ca49dbf7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.constellations
    ADD CONSTRAINT fk_rails_a5ca49dbf7 FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: groups fk_rails_a61500b09c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT fk_rails_a61500b09c FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: solar_systems fk_rails_a8b206bb7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solar_systems
    ADD CONSTRAINT fk_rails_a8b206bb7b FOREIGN KEY (constellation_id) REFERENCES public.constellations(id);


--
-- Name: market_type_stats fk_rails_ab10873f6b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_type_stats
    ADD CONSTRAINT fk_rails_ab10873f6b FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: structures fk_rails_afe2496c94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT fk_rails_afe2496c94 FOREIGN KEY (owner_id) REFERENCES public.corporations(id);


--
-- Name: killmail_fittings fk_rails_b15e60a0f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_fittings
    ADD CONSTRAINT fk_rails_b15e60a0f8 FOREIGN KEY (killmail_id) REFERENCES public.killmails(id);


--
-- Name: contract_fittings fk_rails_b5056d2fe0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_fittings
    ADD CONSTRAINT fk_rails_b5056d2fe0 FOREIGN KEY (fitting_id) REFERENCES public.fittings(id);


--
-- Name: stations fk_rails_b996120a6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT fk_rails_b996120a6f FOREIGN KEY (solar_system_id) REFERENCES public.solar_systems(id);


--
-- Name: killmail_items fk_rails_ba99391406; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_items
    ADD CONSTRAINT fk_rails_ba99391406 FOREIGN KEY (killmail_id) REFERENCES public.killmails(id);


--
-- Name: market_price_snapshots fk_rails_bf2e47c3f4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_price_snapshots
    ADD CONSTRAINT fk_rails_bf2e47c3f4 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: contract_events fk_rails_bfffa663f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_events
    ADD CONSTRAINT fk_rails_bfffa663f5 FOREIGN KEY (corporation_id) REFERENCES public.corporations(id);


--
-- Name: fitting_items fk_rails_c3a47fab2b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitting_items
    ADD CONSTRAINT fk_rails_c3a47fab2b FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: market_fitting_snapshots fk_rails_ccd9e028ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_fitting_snapshots
    ADD CONSTRAINT fk_rails_ccd9e028ca FOREIGN KEY (fitting_id) REFERENCES public.fittings(id);


--
-- Name: esi_authorizations fk_rails_cd77e5d142; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.esi_authorizations
    ADD CONSTRAINT fk_rails_cd77e5d142 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: structures fk_rails_ce74d43aa1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT fk_rails_ce74d43aa1 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: esi_authorizations fk_rails_d62a030c54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.esi_authorizations
    ADD CONSTRAINT fk_rails_d62a030c54 FOREIGN KEY (character_id) REFERENCES public.characters(id);


--
-- Name: killmail_attackers fk_rails_dcd40cdd2d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.killmail_attackers
    ADD CONSTRAINT fk_rails_dcd40cdd2d FOREIGN KEY (ship_type_id) REFERENCES public.types(id);


--
-- Name: contract_items fk_rails_dfd3a85c11; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_items
    ADD CONSTRAINT fk_rails_dfd3a85c11 FOREIGN KEY (contract_id) REFERENCES public.contracts(id);


--
-- Name: types fk_rails_f2443b6d92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT fk_rails_f2443b6d92 FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: users fk_rails_f98257a15c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_f98257a15c FOREIGN KEY (character_id) REFERENCES public.characters(id);


--
-- Name: structures fk_rails_ff1c5f7f41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT fk_rails_ff1c5f7f41 FOREIGN KEY (esi_authorization_id) REFERENCES public.esi_authorizations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20211127220010'),
('20211202031023'),
('20211202031207'),
('20211204013505'),
('20211204021705'),
('20211204021942'),
('20211205013222'),
('20211205224232'),
('20211206161823'),
('20211206162335'),
('20211206164300'),
('20211206171053'),
('20211206183208'),
('20211208211830'),
('20211208232318'),
('20211209144910'),
('20211210142245'),
('20211210181844'),
('20211210214817'),
('20211211022126'),
('20211211200628'),
('20211211201222'),
('20211212020439'),
('20211212153301'),
('20211212165403'),
('20211212191721'),
('20211212191909'),
('20211213021729'),
('20211213165724'),
('20211213204305'),
('20211213204858'),
('20211213205324'),
('20211213213206'),
('20211213221851'),
('20211213222209');


