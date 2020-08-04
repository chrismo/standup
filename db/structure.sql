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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_keys (
    id bigint NOT NULL,
    key character varying NOT NULL,
    issued_at timestamp without time zone NOT NULL,
    issuer_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: standup_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.standup_categories (
    id bigint NOT NULL,
    category character varying
);


--
-- Name: standup_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.standup_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: standup_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.standup_categories_id_seq OWNED BY public.standup_categories.id;


--
-- Name: standup_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.standup_items (
    id bigint NOT NULL,
    developer character varying,
    day date,
    category character varying,
    task character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: standup_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.standup_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: standup_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.standup_items_id_seq OWNED BY public.standup_items.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL
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
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: standup_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.standup_categories ALTER COLUMN id SET DEFAULT nextval('public.standup_categories_id_seq'::regclass);


--
-- Name: standup_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.standup_items ALTER COLUMN id SET DEFAULT nextval('public.standup_items_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


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
-- Name: standup_categories standup_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.standup_categories
    ADD CONSTRAINT standup_categories_pkey PRIMARY KEY (id);


--
-- Name: standup_items standup_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.standup_items
    ADD CONSTRAINT standup_items_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_api_keys_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_api_keys_on_key ON public.api_keys USING btree (key);


--
-- Name: index_standup_categories_on_category; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_standup_categories_on_category ON public.standup_categories USING btree (category);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190415200626'),
('20190415202626'),
('20191230155235'),
('20191230155245'),
('20200307160842');


