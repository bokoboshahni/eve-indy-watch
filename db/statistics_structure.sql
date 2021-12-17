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
-- Name: market_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_types (
    market_id bigint NOT NULL,
    type_id bigint NOT NULL,
    "time" timestamp without time zone NOT NULL,
    buy_five_pct_price_avg numeric,
    buy_five_pct_price_med numeric,
    buy_five_pct_order_count bigint,
    buy_price_avg numeric,
    buy_price_min numeric,
    buy_price_med numeric,
    buy_price_max numeric,
    buy_price_sum numeric,
    buy_volume_avg numeric,
    buy_volume_min bigint,
    buy_volume_med bigint,
    buy_volume_max bigint,
    buy_volume_sum bigint,
    buy_total_order_count bigint,
    buy_trimmed_order_count bigint,
    sell_five_pct_price_avg numeric,
    sell_five_pct_price_med numeric,
    sell_five_pct_order_count numeric,
    sell_price_avg numeric,
    sell_price_min numeric,
    sell_price_med numeric,
    sell_price_max numeric,
    sell_price_sum numeric,
    sell_volume_avg numeric,
    sell_volume_min bigint,
    sell_volume_med bigint,
    sell_volume_max bigint,
    sell_volume_sum bigint,
    sell_total_order_count bigint,
    sell_trimmed_order_count bigint,
    buy_sell_price_spread numeric
);


--
-- Name: _hyper_5_2_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_2_chunk (
    CONSTRAINT constraint_2 CHECK ((("time" >= '2021-12-16 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.market_types);


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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: _hyper_5_2_chunk_market_types_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_2_chunk_market_types_time_idx ON _timescaledb_internal._hyper_5_2_chunk USING btree ("time" DESC);


--
-- Name: market_types_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX market_types_time_idx ON public.market_types USING btree ("time" DESC);


--
-- Name: market_types ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.market_types FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20211214202014'),
('20211216005530');


