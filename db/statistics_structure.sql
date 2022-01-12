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



SELECT public.create_hypertable('public.region_type_histories', 'date');

SELECT public.add_retention_policy('public.region_type_histories', interval '5 years');

SELECT public.create_hypertable('public.fitting_stock_levels', 'time', chunk_time_interval => INTERVAL '7 days');

SELECT public.add_retention_policy('public.fitting_stock_levels', INTERVAL '7 days');

SELECT public.create_hypertable('public.fitting_stock_level_items', 'time', chunk_time_interval => INTERVAL '7 days');

SELECT public.add_retention_policy('public.fitting_stock_level_items', INTERVAL '7 days');

SELECT public.create_hypertable('public.fitting_stock_level_summaries', 'time', chunk_time_interval => INTERVAL '1 month');

SELECT public.add_retention_policy('public.fitting_stock_level_summaries', INTERVAL '5 years');

SELECT public.create_hypertable('public.fitting_stock_level_summary_items', 'time', chunk_time_interval => INTERVAL '1 month');

SELECT public.add_retention_policy('public.fitting_stock_level_summary_items', INTERVAL '5 years');

SELECT public.create_hypertable('public.market_type_stats', 'time', chunk_time_interval => INTERVAL '1 hour');

SELECT public.add_retention_policy('public.market_type_stats', INTERVAL '36 hours');



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


