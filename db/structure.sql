--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: businesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE businesses (
    id integer NOT NULL,
    user_id integer,
    contact_first_name character varying,
    contact_last_name character varying,
    contact_email character varying,
    contact_job_title character varying,
    contact_phone character varying,
    business_name character varying,
    employees character varying,
    website character varying,
    linkedin_link character varying,
    description character varying,
    address_1 character varying,
    address_2 character varying,
    country character varying,
    city character varying,
    state character varying,
    zipcode character varying,
    anonymous boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    logo_data jsonb
);


--
-- Name: businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE businesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE businesses_id_seq OWNED BY businesses.id;


--
-- Name: businesses_industries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE businesses_industries (
    business_id integer NOT NULL,
    industry_id integer NOT NULL
);


--
-- Name: businesses_jurisdictions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE businesses_jurisdictions (
    business_id integer NOT NULL,
    jurisdiction_id integer NOT NULL
);


--
-- Name: education_histories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE education_histories (
    id integer NOT NULL,
    specialist_id integer,
    institution character varying,
    degree character varying,
    year integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: education_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE education_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: education_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE education_histories_id_seq OWNED BY education_histories.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE industries (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE industries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE industries_id_seq OWNED BY industries.id;


--
-- Name: industries_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE industries_projects (
    industry_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: industries_specialists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE industries_specialists (
    industry_id integer NOT NULL,
    specialist_id integer NOT NULL
);


--
-- Name: jurisdictions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jurisdictions (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: jurisdictions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jurisdictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jurisdictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jurisdictions_id_seq OWNED BY jurisdictions.id;


--
-- Name: jurisdictions_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jurisdictions_projects (
    jurisdiction_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: jurisdictions_specialists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jurisdictions_specialists (
    jurisdiction_id integer NOT NULL,
    specialist_id integer NOT NULL
);


--
-- Name: payment_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payment_profiles (
    id integer NOT NULL,
    business_id integer,
    stripe_customer_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payment_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payment_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payment_profiles_id_seq OWNED BY payment_profiles.id;


--
-- Name: payment_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payment_sources (
    id integer NOT NULL,
    payment_profile_id integer,
    stripe_card_id character varying NOT NULL,
    brand character varying NOT NULL,
    exp_month integer NOT NULL,
    exp_year integer NOT NULL,
    last4 character varying NOT NULL,
    "primary" boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payment_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payment_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payment_sources_id_seq OWNED BY payment_sources.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    business_id integer NOT NULL,
    type character varying DEFAULT 'one_off'::character varying NOT NULL,
    status character varying DEFAULT 'draft'::character varying NOT NULL,
    title character varying NOT NULL,
    location_type character varying,
    location character varying,
    description character varying NOT NULL,
    key_deliverables character varying,
    starts_on date NOT NULL,
    ends_on date,
    pricing_type character varying DEFAULT 'hourly'::character varying,
    payment_schedule character varying,
    fixed_budget numeric,
    hourly_rate numeric,
    estimated_hours integer,
    minimum_experience character varying,
    only_regulators boolean,
    annual_salary integer,
    fee_type character varying DEFAULT 'upfront'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: projects_skills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_skills (
    project_id integer NOT NULL,
    skill_id integer NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skills_id_seq OWNED BY skills.id;


--
-- Name: skills_specialists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills_specialists (
    skill_id integer NOT NULL,
    specialist_id integer NOT NULL
);


--
-- Name: specialists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE specialists (
    id integer NOT NULL,
    user_id integer,
    first_name character varying,
    last_name character varying,
    country character varying,
    state character varying,
    city character varying,
    zipcode character varying,
    phone character varying,
    linkedin_link character varying,
    former_regulator boolean DEFAULT false NOT NULL,
    photo_data jsonb,
    resume_data jsonb,
    certifications character varying,
    visibility character varying DEFAULT 'public'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: specialists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE specialists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: specialists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE specialists_id_seq OWNED BY specialists.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: work_experiences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE work_experiences (
    id integer NOT NULL,
    specialist_id integer,
    company character varying,
    job_title character varying,
    location character varying,
    "from" date,
    "to" date,
    current boolean DEFAULT false NOT NULL,
    compliance boolean DEFAULT false NOT NULL,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: work_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE work_experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE work_experiences_id_seq OWNED BY work_experiences.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses ALTER COLUMN id SET DEFAULT nextval('businesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY education_histories ALTER COLUMN id SET DEFAULT nextval('education_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY industries ALTER COLUMN id SET DEFAULT nextval('industries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jurisdictions ALTER COLUMN id SET DEFAULT nextval('jurisdictions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_profiles ALTER COLUMN id SET DEFAULT nextval('payment_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_sources ALTER COLUMN id SET DEFAULT nextval('payment_sources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skills ALTER COLUMN id SET DEFAULT nextval('skills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY specialists ALTER COLUMN id SET DEFAULT nextval('specialists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY work_experiences ALTER COLUMN id SET DEFAULT nextval('work_experiences_id_seq'::regclass);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: education_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY education_histories
    ADD CONSTRAINT education_histories_pkey PRIMARY KEY (id);


--
-- Name: industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: jurisdictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jurisdictions
    ADD CONSTRAINT jurisdictions_pkey PRIMARY KEY (id);


--
-- Name: payment_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payment_profiles
    ADD CONSTRAINT payment_profiles_pkey PRIMARY KEY (id);


--
-- Name: payment_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payment_sources
    ADD CONSTRAINT payment_sources_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: specialists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY specialists
    ADD CONSTRAINT specialists_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: work_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY work_experiences
    ADD CONSTRAINT work_experiences_pkey PRIMARY KEY (id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_businesses_industries_on_business_id_and_industry_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_businesses_industries_on_business_id_and_industry_id ON businesses_industries USING btree (business_id, industry_id);


--
-- Name: index_businesses_on_anonymous; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_businesses_on_anonymous ON businesses USING btree (anonymous);


--
-- Name: index_businesses_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_businesses_on_user_id ON businesses USING btree (user_id);


--
-- Name: index_education_histories_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_education_histories_on_specialist_id ON education_histories USING btree (specialist_id);


--
-- Name: index_industries_projects_on_industry_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_industries_projects_on_industry_id_and_project_id ON industries_projects USING btree (industry_id, project_id);


--
-- Name: index_jurisdictions_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_jurisdictions_on_name ON jurisdictions USING btree (name);


--
-- Name: index_jurisdictions_projects_on_jurisdiction_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_jurisdictions_projects_on_jurisdiction_id_and_project_id ON jurisdictions_projects USING btree (jurisdiction_id, project_id);


--
-- Name: index_payment_profiles_on_business_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_profiles_on_business_id ON payment_profiles USING btree (business_id);


--
-- Name: index_payment_sources_on_payment_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_sources_on_payment_profile_id ON payment_sources USING btree (payment_profile_id);


--
-- Name: index_payment_sources_on_stripe_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_payment_sources_on_stripe_card_id ON payment_sources USING btree (stripe_card_id);


--
-- Name: index_projects_on_business_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_business_id ON projects USING btree (business_id);


--
-- Name: index_projects_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_status ON projects USING btree (status);


--
-- Name: index_projects_skills_on_project_id_and_skill_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_projects_skills_on_project_id_and_skill_id ON projects_skills USING btree (project_id, skill_id);


--
-- Name: index_skills_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_skills_on_name ON skills USING btree (name);


--
-- Name: index_skills_specialists_on_skill_id_and_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_skills_specialists_on_skill_id_and_specialist_id ON skills_specialists USING btree (skill_id, specialist_id);


--
-- Name: index_specialists_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_specialists_on_user_id ON specialists USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_work_experiences_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_work_experiences_on_specialist_id ON work_experiences USING btree (specialist_id);


--
-- Name: industries_specialists_unique; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX industries_specialists_unique ON industries_specialists USING btree (industry_id, specialist_id);


--
-- Name: jurisdictions_specialists_unique; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX jurisdictions_specialists_unique ON jurisdictions_specialists USING btree (jurisdiction_id, specialist_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20160603200743');

INSERT INTO schema_migrations (version) VALUES ('20160606215415');

INSERT INTO schema_migrations (version) VALUES ('20160606230043');

INSERT INTO schema_migrations (version) VALUES ('20160607025107');

INSERT INTO schema_migrations (version) VALUES ('20160607205707');

INSERT INTO schema_migrations (version) VALUES ('20160611004308');

INSERT INTO schema_migrations (version) VALUES ('20160614211137');

INSERT INTO schema_migrations (version) VALUES ('20160616013430');

INSERT INTO schema_migrations (version) VALUES ('20160616155048');

INSERT INTO schema_migrations (version) VALUES ('20160616211257');

INSERT INTO schema_migrations (version) VALUES ('20160620220131');

INSERT INTO schema_migrations (version) VALUES ('20160621014832');

INSERT INTO schema_migrations (version) VALUES ('20160621181454');

INSERT INTO schema_migrations (version) VALUES ('20160623211024');

INSERT INTO schema_migrations (version) VALUES ('20160721011122');

INSERT INTO schema_migrations (version) VALUES ('20160722233234');

