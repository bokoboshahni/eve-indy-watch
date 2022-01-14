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


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: market_type_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_type_stats (
    market_id bigint NOT NULL,
    type_id bigint NOT NULL,
    "time" timestamp without time zone NOT NULL,
    buy_five_pct_price_avg numeric,
    buy_five_pct_price_max numeric,
    buy_five_pct_price_med numeric,
    buy_five_pct_price_min numeric,
    buy_five_pct_price_sum numeric,
    buy_five_pct_order_count integer,
    buy_price_avg numeric,
    buy_price_max numeric,
    buy_price_med numeric,
    buy_price_min numeric,
    buy_price_sum numeric,
    buy_outlier_count integer,
    buy_outlier_threshold numeric,
    buy_order_count integer,
    buy_trade_count integer,
    buy_volume_avg numeric,
    buy_volume_max bigint,
    buy_volume_med bigint,
    buy_volume_min bigint,
    buy_volume_sum bigint,
    buy_volume_traded_avg numeric,
    buy_volume_traded_max bigint,
    buy_volume_traded_med bigint,
    buy_volume_traded_min bigint,
    buy_volume_traded_sum bigint,
    sell_five_pct_price_avg numeric,
    sell_five_pct_price_max numeric,
    sell_five_pct_price_med numeric,
    sell_five_pct_price_min numeric,
    sell_five_pct_price_sum numeric,
    sell_five_pct_order_count integer,
    sell_price_avg numeric,
    sell_price_max numeric,
    sell_price_med numeric,
    sell_price_min numeric,
    sell_price_sum numeric,
    sell_outlier_count integer,
    sell_outlier_threshold numeric,
    sell_order_count integer,
    sell_trade_count integer,
    sell_volume_avg numeric,
    sell_volume_max bigint,
    sell_volume_med bigint,
    sell_volume_min bigint,
    sell_volume_sum bigint,
    sell_volume_traded_avg numeric,
    sell_volume_traded_max bigint,
    sell_volume_traded_med bigint,
    sell_volume_traded_min bigint,
    sell_volume_traded_sum bigint,
    buy_sell_spread numeric,
    mid_price numeric,
    depth jsonb,
    flow jsonb
);


--
-- Name: _hyper_12_10_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_10_chunk (
    CONSTRAINT constraint_10 CHECK ((("time" >= '2022-01-10 19:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 20:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_11_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_11_chunk (
    CONSTRAINT constraint_11 CHECK ((("time" >= '2022-01-10 20:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 21:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_12_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_12_chunk (
    CONSTRAINT constraint_12 CHECK ((("time" >= '2022-01-10 21:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 22:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_13_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_13_chunk (
    CONSTRAINT constraint_13 CHECK ((("time" >= '2022-01-10 22:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 23:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_14_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_14_chunk (
    CONSTRAINT constraint_14 CHECK ((("time" >= '2022-01-10 23:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_15_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_15_chunk (
    CONSTRAINT constraint_15 CHECK ((("time" >= '2022-01-11 00:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 01:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_16_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_16_chunk (
    CONSTRAINT constraint_16 CHECK ((("time" >= '2022-01-11 01:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 02:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_17_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_17_chunk (
    CONSTRAINT constraint_17 CHECK ((("time" >= '2022-01-11 13:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 14:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_18_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_18_chunk (
    CONSTRAINT constraint_18 CHECK ((("time" >= '2022-01-11 14:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 15:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_19_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_19_chunk (
    CONSTRAINT constraint_19 CHECK ((("time" >= '2022-01-11 15:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 16:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_20_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_20_chunk (
    CONSTRAINT constraint_20 CHECK ((("time" >= '2022-01-11 16:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 17:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_21_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_21_chunk (
    CONSTRAINT constraint_21 CHECK ((("time" >= '2022-01-11 17:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 18:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_22_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_22_chunk (
    CONSTRAINT constraint_22 CHECK ((("time" >= '2022-01-11 18:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 19:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_23_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_23_chunk (
    CONSTRAINT constraint_23 CHECK ((("time" >= '2022-01-11 19:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 20:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_24_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_24_chunk (
    CONSTRAINT constraint_24 CHECK ((("time" >= '2022-01-11 20:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 21:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_25_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_25_chunk (
    CONSTRAINT constraint_25 CHECK ((("time" >= '2022-01-11 21:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 22:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_26_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_26_chunk (
    CONSTRAINT constraint_26 CHECK ((("time" >= '2022-01-11 22:00:00'::timestamp without time zone) AND ("time" < '2022-01-11 23:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_27_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_27_chunk (
    CONSTRAINT constraint_27 CHECK ((("time" >= '2022-01-11 23:00:00'::timestamp without time zone) AND ("time" < '2022-01-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_28_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_28_chunk (
    CONSTRAINT constraint_28 CHECK ((("time" >= '2022-01-12 00:00:00'::timestamp without time zone) AND ("time" < '2022-01-12 01:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_29_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_29_chunk (
    CONSTRAINT constraint_29 CHECK ((("time" >= '2022-01-12 14:00:00'::timestamp without time zone) AND ("time" < '2022-01-12 15:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_30_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_30_chunk (
    CONSTRAINT constraint_30 CHECK ((("time" >= '2022-01-12 13:00:00'::timestamp without time zone) AND ("time" < '2022-01-12 14:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_31_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_31_chunk (
    CONSTRAINT constraint_31 CHECK ((("time" >= '2022-01-12 15:00:00'::timestamp without time zone) AND ("time" < '2022-01-12 16:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_32_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_32_chunk (
    CONSTRAINT constraint_32 CHECK ((("time" >= '2022-01-12 16:00:00'::timestamp without time zone) AND ("time" < '2022-01-12 17:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_33_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_33_chunk (
    CONSTRAINT constraint_33 CHECK ((("time" >= '2022-01-12 17:00:00'::timestamp without time zone) AND ("time" < '2022-01-12 18:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_34_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_34_chunk (
    CONSTRAINT constraint_34 CHECK ((("time" >= '2022-01-13 14:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 15:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_35_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_35_chunk (
    CONSTRAINT constraint_35 CHECK ((("time" >= '2022-01-13 15:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 16:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_36_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_36_chunk (
    CONSTRAINT constraint_36 CHECK ((("time" >= '2022-01-13 16:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 17:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_37_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_37_chunk (
    CONSTRAINT constraint_37 CHECK ((("time" >= '2022-01-13 17:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 18:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_38_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_38_chunk (
    CONSTRAINT constraint_38 CHECK ((("time" >= '2022-01-13 18:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 19:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_39_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_39_chunk (
    CONSTRAINT constraint_39 CHECK ((("time" >= '2022-01-13 19:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 20:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_40_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_40_chunk (
    CONSTRAINT constraint_40 CHECK ((("time" >= '2022-01-13 20:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 21:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_41_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_41_chunk (
    CONSTRAINT constraint_41 CHECK ((("time" >= '2022-01-13 21:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 22:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_42_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_42_chunk (
    CONSTRAINT constraint_42 CHECK ((("time" >= '2022-01-13 22:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 23:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_4_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_4_chunk (
    CONSTRAINT constraint_4 CHECK ((("time" >= '2022-01-10 13:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 14:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_5_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_5_chunk (
    CONSTRAINT constraint_5 CHECK ((("time" >= '2022-01-10 14:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 15:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_6_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_6_chunk (
    CONSTRAINT constraint_6 CHECK ((("time" >= '2022-01-10 15:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 16:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_7_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_7_chunk (
    CONSTRAINT constraint_7 CHECK ((("time" >= '2022-01-10 16:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 17:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_8_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_8_chunk (
    CONSTRAINT constraint_8 CHECK ((("time" >= '2022-01-10 17:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 18:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: _hyper_12_9_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_12_9_chunk (
    CONSTRAINT constraint_9 CHECK ((("time" >= '2022-01-10 18:00:00'::timestamp without time zone) AND ("time" < '2022-01-10 19:00:00'::timestamp without time zone)))
)
INHERITS (public.market_type_stats);


--
-- Name: ahoy_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ahoy_events (
    id bigint NOT NULL,
    visit_id bigint,
    name character varying,
    properties jsonb,
    "time" timestamp without time zone
);


--
-- Name: ahoy_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ahoy_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_events_id_seq OWNED BY public.ahoy_events.id;


--
-- Name: ahoy_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ahoy_visits (
    id bigint NOT NULL,
    visit_token character varying,
    visitor_token character varying,
    ip character varying,
    user_agent text,
    referrer text,
    referring_domain character varying,
    landing_page text,
    browser character varying,
    os character varying,
    device_type character varying,
    started_at timestamp without time zone
);


--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_visits_id_seq OWNED BY public.ahoy_visits.id;


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
-- Name: fitting_stock_level_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fitting_stock_level_items (
    fitting_id bigint NOT NULL,
    market_id bigint NOT NULL,
    type_id bigint NOT NULL,
    "time" timestamp without time zone NOT NULL,
    fitting_quantity integer NOT NULL,
    market_buy_price numeric,
    market_sell_price numeric,
    market_sell_volume integer NOT NULL
);


--
-- Name: fitting_stock_level_summaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fitting_stock_level_summaries (
    fitting_id bigint NOT NULL,
    market_id bigint NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "interval" text NOT NULL,
    contract_price_avg numeric,
    contract_price_med numeric,
    contract_price_min numeric,
    contract_price_max numeric,
    contract_price_sum numeric,
    contract_match_quantity integer,
    contract_match_threshold numeric,
    contract_total_quantity integer,
    contract_similarity_avg numeric,
    contract_similarity_med numeric,
    contract_similarity_min numeric,
    contract_similarity_max numeric,
    market_buy_price numeric,
    market_sell_price numeric,
    market_quantity integer,
    market_time timestamp without time zone
);


--
-- Name: fitting_stock_level_summary_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fitting_stock_level_summary_items (
    fitting_id bigint NOT NULL,
    market_id bigint NOT NULL,
    type_id bigint NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "interval" text NOT NULL,
    fitting_quantity integer NOT NULL,
    market_buy_price numeric,
    market_sell_price numeric,
    market_sell_volume integer NOT NULL
);


--
-- Name: fitting_stock_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fitting_stock_levels (
    fitting_id bigint NOT NULL,
    market_id bigint NOT NULL,
    "time" timestamp without time zone NOT NULL,
    contract_price_avg numeric,
    contract_price_med numeric,
    contract_price_min numeric,
    contract_price_max numeric,
    contract_price_sum numeric,
    contract_match_quantity integer,
    contract_match_threshold numeric,
    contract_total_quantity integer,
    contract_similarity_avg numeric,
    contract_similarity_med numeric,
    contract_similarity_min numeric,
    contract_similarity_max numeric,
    market_buy_price numeric,
    market_sell_price numeric,
    market_quantity integer,
    market_time timestamp without time zone
);


--
-- Name: region_type_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.region_type_histories (
    region_id bigint NOT NULL,
    type_id bigint NOT NULL,
    date date NOT NULL,
    average numeric NOT NULL,
    highest numeric NOT NULL,
    lowest numeric NOT NULL,
    order_count bigint NOT NULL,
    volume bigint NOT NULL
);


--
-- Name: report_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_runs (
    id bigint NOT NULL,
    report text NOT NULL,
    user_id bigint,
    duration interval NOT NULL,
    status text NOT NULL,
    exception jsonb,
    started_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: report_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.report_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: report_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.report_runs_id_seq OWNED BY public.report_runs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ahoy_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_events ALTER COLUMN id SET DEFAULT nextval('public.ahoy_events_id_seq'::regclass);


--
-- Name: ahoy_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_visits ALTER COLUMN id SET DEFAULT nextval('public.ahoy_visits_id_seq'::regclass);


--
-- Name: report_runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_runs ALTER COLUMN id SET DEFAULT nextval('public.report_runs_id_seq'::regclass);


--
-- Name: _hyper_12_10_chunk 10_7_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_10_chunk
    ADD CONSTRAINT "10_7_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_11_chunk 11_8_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_11_chunk
    ADD CONSTRAINT "11_8_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_12_chunk 12_9_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_12_chunk
    ADD CONSTRAINT "12_9_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_13_chunk 13_10_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_13_chunk
    ADD CONSTRAINT "13_10_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_14_chunk 14_11_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_14_chunk
    ADD CONSTRAINT "14_11_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_15_chunk 15_12_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_15_chunk
    ADD CONSTRAINT "15_12_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_16_chunk 16_13_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_16_chunk
    ADD CONSTRAINT "16_13_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_17_chunk 17_14_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_17_chunk
    ADD CONSTRAINT "17_14_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_18_chunk 18_15_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_18_chunk
    ADD CONSTRAINT "18_15_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_19_chunk 19_16_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_19_chunk
    ADD CONSTRAINT "19_16_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_20_chunk 20_17_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_20_chunk
    ADD CONSTRAINT "20_17_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_21_chunk 21_18_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_21_chunk
    ADD CONSTRAINT "21_18_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_22_chunk 22_19_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_22_chunk
    ADD CONSTRAINT "22_19_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_23_chunk 23_20_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_23_chunk
    ADD CONSTRAINT "23_20_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_24_chunk 24_21_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_24_chunk
    ADD CONSTRAINT "24_21_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_25_chunk 25_22_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_25_chunk
    ADD CONSTRAINT "25_22_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_26_chunk 26_23_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_26_chunk
    ADD CONSTRAINT "26_23_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_27_chunk 27_24_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_27_chunk
    ADD CONSTRAINT "27_24_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_28_chunk 28_25_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_28_chunk
    ADD CONSTRAINT "28_25_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_29_chunk 29_26_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_29_chunk
    ADD CONSTRAINT "29_26_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_30_chunk 30_27_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_30_chunk
    ADD CONSTRAINT "30_27_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_31_chunk 31_28_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_31_chunk
    ADD CONSTRAINT "31_28_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_32_chunk 32_29_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_32_chunk
    ADD CONSTRAINT "32_29_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_33_chunk 33_30_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_33_chunk
    ADD CONSTRAINT "33_30_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_34_chunk 34_31_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_34_chunk
    ADD CONSTRAINT "34_31_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_35_chunk 35_32_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_35_chunk
    ADD CONSTRAINT "35_32_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_36_chunk 36_33_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_36_chunk
    ADD CONSTRAINT "36_33_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_37_chunk 37_34_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_37_chunk
    ADD CONSTRAINT "37_34_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_38_chunk 38_35_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_38_chunk
    ADD CONSTRAINT "38_35_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_39_chunk 39_36_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_39_chunk
    ADD CONSTRAINT "39_36_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_40_chunk 40_37_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_40_chunk
    ADD CONSTRAINT "40_37_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_41_chunk 41_38_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_41_chunk
    ADD CONSTRAINT "41_38_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_42_chunk 42_39_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_42_chunk
    ADD CONSTRAINT "42_39_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_4_chunk 4_1_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_4_chunk
    ADD CONSTRAINT "4_1_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_5_chunk 5_2_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_5_chunk
    ADD CONSTRAINT "5_2_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_6_chunk 6_3_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_6_chunk
    ADD CONSTRAINT "6_3_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_7_chunk 7_4_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_7_chunk
    ADD CONSTRAINT "7_4_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_8_chunk 8_5_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_8_chunk
    ADD CONSTRAINT "8_5_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: _hyper_12_9_chunk 9_6_market_type_stats_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_12_9_chunk
    ADD CONSTRAINT "9_6_market_type_stats_pkey" PRIMARY KEY (market_id, type_id, "time");


--
-- Name: ahoy_events ahoy_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_events
    ADD CONSTRAINT ahoy_events_pkey PRIMARY KEY (id);


--
-- Name: ahoy_visits ahoy_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_visits
    ADD CONSTRAINT ahoy_visits_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: market_type_stats market_type_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_type_stats
    ADD CONSTRAINT market_type_stats_pkey PRIMARY KEY (market_id, type_id, "time");


--
-- Name: report_runs report_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_runs
    ADD CONSTRAINT report_runs_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: _hyper_12_10_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_10_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_10_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_10_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_10_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_10_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_11_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_11_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_11_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_11_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_11_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_11_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_12_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_12_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_12_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_12_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_12_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_12_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_13_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_13_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_13_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_13_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_13_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_13_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_14_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_14_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_14_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_14_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_14_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_14_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_15_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_15_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_15_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_15_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_15_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_15_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_16_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_16_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_16_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_16_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_16_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_16_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_17_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_17_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_17_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_17_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_17_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_17_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_18_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_18_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_18_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_18_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_18_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_18_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_19_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_19_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_19_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_19_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_19_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_19_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_20_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_20_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_20_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_20_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_20_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_20_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_21_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_21_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_21_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_21_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_21_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_21_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_22_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_22_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_22_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_22_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_22_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_22_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_23_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_23_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_23_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_23_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_23_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_23_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_24_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_24_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_24_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_24_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_24_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_24_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_25_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_25_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_25_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_25_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_25_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_25_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_26_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_26_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_26_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_26_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_26_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_26_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_27_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_27_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_27_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_27_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_27_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_27_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_28_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_28_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_28_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_28_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_28_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_28_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_29_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_29_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_29_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_29_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_29_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_29_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_30_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_30_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_30_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_30_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_30_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_30_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_31_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_31_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_31_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_31_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_31_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_31_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_32_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_32_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_32_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_32_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_32_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_32_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_33_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_33_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_33_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_33_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_33_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_33_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_34_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_34_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_34_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_34_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_34_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_34_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_35_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_35_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_35_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_35_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_35_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_35_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_36_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_36_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_36_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_36_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_36_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_36_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_37_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_37_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_37_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_37_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_37_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_37_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_38_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_38_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_38_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_38_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_38_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_38_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_39_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_39_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_39_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_39_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_39_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_39_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_40_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_40_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_40_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_40_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_40_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_40_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_41_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_41_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_41_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_41_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_41_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_41_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_42_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_42_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_42_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_42_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_42_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_42_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_4_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_4_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_4_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_4_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_4_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_4_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_5_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_5_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_5_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_5_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_5_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_5_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_6_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_6_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_6_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_6_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_6_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_6_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_7_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_7_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_7_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_7_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_7_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_7_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_8_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_8_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_8_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_8_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_8_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_8_chunk USING btree ("time" DESC);


--
-- Name: _hyper_12_9_chunk_index_unique_market_type_stats; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_12_9_chunk_index_unique_market_type_stats ON _timescaledb_internal._hyper_12_9_chunk USING btree (market_id, type_id, "time" DESC);


--
-- Name: _hyper_12_9_chunk_market_type_stats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_12_9_chunk_market_type_stats_time_idx ON _timescaledb_internal._hyper_12_9_chunk USING btree ("time" DESC);


--
-- Name: fitting_stock_level_items_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fitting_stock_level_items_time_idx ON public.fitting_stock_level_items USING btree ("time" DESC);


--
-- Name: fitting_stock_level_summaries_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fitting_stock_level_summaries_time_idx ON public.fitting_stock_level_summaries USING btree ("time" DESC);


--
-- Name: fitting_stock_level_summary_items_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fitting_stock_level_summary_items_time_idx ON public.fitting_stock_level_summary_items USING btree ("time" DESC);


--
-- Name: fitting_stock_levels_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fitting_stock_levels_time_idx ON public.fitting_stock_levels USING btree ("time" DESC);


--
-- Name: index_ahoy_events_on_name_and_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_name_and_time ON public.ahoy_events USING btree (name, "time");


--
-- Name: index_ahoy_events_on_properties; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_properties ON public.ahoy_events USING gin (properties jsonb_path_ops);


--
-- Name: index_ahoy_events_on_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_visit_id ON public.ahoy_events USING btree (visit_id);


--
-- Name: index_ahoy_visits_on_visit_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ahoy_visits_on_visit_token ON public.ahoy_visits USING btree (visit_token);


--
-- Name: index_report_runs_on_report; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_report_runs_on_report ON public.report_runs USING btree (report);


--
-- Name: index_report_runs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_report_runs_on_user_id ON public.report_runs USING btree (user_id);


--
-- Name: index_unique_fitting_stock_level_items; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_fitting_stock_level_items ON public.fitting_stock_level_items USING btree (fitting_id, market_id, type_id, "time" DESC);


--
-- Name: index_unique_fitting_stock_level_summaries; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_fitting_stock_level_summaries ON public.fitting_stock_level_summaries USING btree (fitting_id, market_id, "time" DESC, "interval");


--
-- Name: index_unique_fitting_stock_level_summary_items; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_fitting_stock_level_summary_items ON public.fitting_stock_level_summary_items USING btree (fitting_id, market_id, type_id, "time" DESC, "interval");


--
-- Name: index_unique_fitting_stock_levels; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_fitting_stock_levels ON public.fitting_stock_levels USING btree (fitting_id, market_id, "time" DESC);


--
-- Name: index_unique_market_type_stats; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_type_stats ON public.market_type_stats USING btree (market_id, type_id, "time" DESC);


--
-- Name: index_unique_region_type_histories; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_region_type_histories ON public.region_type_histories USING btree (region_id, type_id, date);


--
-- Name: market_type_stats_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX market_type_stats_time_idx ON public.market_type_stats USING btree ("time" DESC);


--
-- Name: region_type_histories_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX region_type_histories_date_idx ON public.region_type_histories USING btree (date DESC);


--
-- Name: fitting_stock_level_items ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.fitting_stock_level_items FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: fitting_stock_level_summaries ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.fitting_stock_level_summaries FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: fitting_stock_level_summary_items ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.fitting_stock_level_summary_items FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: fitting_stock_levels ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.fitting_stock_levels FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: market_type_stats ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.market_type_stats FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: region_type_histories ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.region_type_histories FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20211214202014'),
('20211216005530'),
('20211217180622'),
('20211219172354'),
('20211221032120'),
('20211222174239'),
('20211223201100'),
('20211224172611'),
('20211226153817'),
('20211227032819'),
('20211227044656'),
('20220109184606'),
('20220109204446');


