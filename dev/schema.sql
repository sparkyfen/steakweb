-- =====================================================================
-- dev/schema.sql  --  production schema (DEV ONLY copy)
-- =====================================================================
-- Definitive schema provided by supersat in PR #2. Loaded into the
-- throwaway dev Postgres on first boot; see dev/README.md.
-- =====================================================================

CREATE TYPE public.switch_address_type AS ENUM (
    'AAR',
    'ENP',
    'sipv4',
    'sipv6',
    'other'
);

CREATE TYPE public.switch_type AS ENUM (
    'tdm',
    'isr',
    'sip'
);

CREATE TABLE public.registered_extensions (
    extn integer NOT NULL,
    name text,
    userid integer,
    switch integer,
    port text,
    auth_code text,
    reservation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_updated timestamp without time zone,
    expires_at timestamp without time zone,
    publish boolean DEFAULT true NOT NULL,
    provisioned boolean DEFAULT true NOT NULL
);

CREATE TABLE public.switches (
    id integer NOT NULL,
    type public.switch_type NOT NULL,
    address text,
    address_type public.switch_address_type NOT NULL,
    name text,
    description text,
    sip_gateway text
);

CREATE SEQUENCE public.switches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ONLY public.switches ALTER COLUMN id SET DEFAULT nextval('public.switches_id_seq'::regclass);

-- Not in the schema supersat posted, but create_extn relies on a unique
-- violation on extn to report "already taken", so dev needs the constraint.
ALTER TABLE ONLY public.registered_extensions
    ADD CONSTRAINT registered_extensions_pkey PRIMARY KEY (extn);
