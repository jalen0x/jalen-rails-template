SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: application_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_locks (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    pin_digest text NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: TABLE application_locks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.application_locks IS 'User-owned application lock PIN digests';


--
-- Name: COLUMN application_locks.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.application_locks.user_id IS 'Owner of this application lock';


--
-- Name: COLUMN application_locks.pin_digest; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.application_locks.pin_digest IS 'BCrypt digest of the application lock PIN';


--
-- Name: application_locks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.application_locks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.application_locks_id_seq OWNED BY public.application_locks.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: two_factor_authentications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.two_factor_authentications (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    otp_secret text NOT NULL,
    enabled_at timestamp(6) with time zone NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    last_otp_at timestamp(6) with time zone
);


--
-- Name: TABLE two_factor_authentications; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.two_factor_authentications IS 'User-owned TOTP two-factor settings';


--
-- Name: COLUMN two_factor_authentications.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.two_factor_authentications.user_id IS 'Owner of this two-factor setting';


--
-- Name: COLUMN two_factor_authentications.otp_secret; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.two_factor_authentications.otp_secret IS 'Base32 TOTP secret for authenticator apps';


--
-- Name: COLUMN two_factor_authentications.enabled_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.two_factor_authentications.enabled_at IS 'Time two-factor authentication was enabled';


--
-- Name: COLUMN two_factor_authentications.last_otp_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.two_factor_authentications.last_otp_at IS 'Most recent successful OTP timestep; used to prevent replay within the drift window';


--
-- Name: two_factor_authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.two_factor_authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: two_factor_authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.two_factor_authentications_id_seq OWNED BY public.two_factor_authentications.id;


--
-- Name: two_factor_recovery_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.two_factor_recovery_codes (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    code_digest text NOT NULL,
    used_at timestamp(6) with time zone,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: TABLE two_factor_recovery_codes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.two_factor_recovery_codes IS 'User-owned one-time 2FA recovery code digests';


--
-- Name: COLUMN two_factor_recovery_codes.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.two_factor_recovery_codes.user_id IS 'Owner of this recovery code';


--
-- Name: COLUMN two_factor_recovery_codes.code_digest; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.two_factor_recovery_codes.code_digest IS 'BCrypt digest of the raw recovery code';


--
-- Name: COLUMN two_factor_recovery_codes.used_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.two_factor_recovery_codes.used_at IS 'Time this recovery code was consumed';


--
-- Name: two_factor_recovery_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.two_factor_recovery_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: two_factor_recovery_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.two_factor_recovery_codes_id_seq OWNED BY public.two_factor_recovery_codes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    first_name character varying,
    last_name character varying,
    provider character varying,
    uid character varying,
    discarded_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: application_locks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_locks ALTER COLUMN id SET DEFAULT nextval('public.application_locks_id_seq'::regclass);


--
-- Name: two_factor_authentications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.two_factor_authentications ALTER COLUMN id SET DEFAULT nextval('public.two_factor_authentications_id_seq'::regclass);


--
-- Name: two_factor_recovery_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.two_factor_recovery_codes ALTER COLUMN id SET DEFAULT nextval('public.two_factor_recovery_codes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: application_locks application_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_locks
    ADD CONSTRAINT application_locks_pkey PRIMARY KEY (id);


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
-- Name: two_factor_authentications two_factor_authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.two_factor_authentications
    ADD CONSTRAINT two_factor_authentications_pkey PRIMARY KEY (id);


--
-- Name: two_factor_recovery_codes two_factor_recovery_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.two_factor_recovery_codes
    ADD CONSTRAINT two_factor_recovery_codes_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_application_locks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_application_locks_on_user_id ON public.application_locks USING btree (user_id);


--
-- Name: index_two_factor_authentications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_two_factor_authentications_on_user_id ON public.two_factor_authentications USING btree (user_id);


--
-- Name: index_two_factor_recovery_codes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_two_factor_recovery_codes_on_user_id ON public.two_factor_recovery_codes USING btree (user_id);


--
-- Name: index_two_factor_recovery_codes_on_user_id_and_used_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_two_factor_recovery_codes_on_user_id_and_used_at ON public.two_factor_recovery_codes USING btree (user_id, used_at);


--
-- Name: index_users_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_discarded_at ON public.users USING btree (discarded_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_provider_and_uid ON public.users USING btree (provider, uid);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: two_factor_authentications fk_rails_110abb6ee6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.two_factor_authentications
    ADD CONSTRAINT fk_rails_110abb6ee6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: two_factor_recovery_codes fk_rails_1b41033e31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.two_factor_recovery_codes
    ADD CONSTRAINT fk_rails_1b41033e31 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: application_locks fk_rails_3e7754d4df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_locks
    ADD CONSTRAINT fk_rails_3e7754d4df FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260509070004'),
('20260509070003'),
('20260509070002'),
('20260509070001'),
('20260509070000'),
('20260507211732'),
('20260411171621'),
('0');

