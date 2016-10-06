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


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: projects_calculate_budget(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION projects_calculate_budget() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        IF NEW.type = 'full_time' THEN
          NEW.calculated_budget := NEW.annual_salary;
        ELSE
          IF NEW.pricing_type = 'hourly' AND NEW.hourly_rate IS NOT NULL AND NEW.estimated_hours IS NOT NULL THEN
            NEW.calculated_budget := NEW.hourly_rate * NEW.estimated_hours;
          ELSIF NEW.pricing_type = 'fixed' THEN
            NEW.calculated_budget := NEW.fixed_budget;
          END IF;
        END IF;
        RETURN NEW;
      END;
      $$;


--
-- Name: set_point_from_lat_lng(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION set_point_from_lat_lng() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        NEW.point := ST_SetSRID(ST_Point(NEW.lng, NEW.lat), 4326);
        RETURN NEW;
      END;
      $$;


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
    updated_at timestamp without time zone NOT NULL,
    super_admin boolean DEFAULT false,
    suspended boolean DEFAULT false
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
    logo_data jsonb,
    time_zone character varying,
    ratings_count integer DEFAULT 0 NOT NULL,
    ratings_total integer DEFAULT 0 NOT NULL,
    ratings_average double precision
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
-- Name: charges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE charges (
    id integer NOT NULL,
    project_id integer NOT NULL,
    amount_in_cents integer NOT NULL,
    process_after timestamp without time zone NOT NULL,
    status character varying DEFAULT 'scheduled'::character varying NOT NULL,
    status_detail character varying,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date timestamp without time zone NOT NULL,
    transaction_id integer
);


--
-- Name: charges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE charges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: charges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE charges_id_seq OWNED BY charges.id;


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
-- Name: email_threads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_threads (
    id integer NOT NULL,
    business_id integer,
    specialist_id integer,
    thread_key character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE email_threads_id_seq OWNED BY email_threads.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE favorites (
    id integer NOT NULL,
    owner_id integer,
    owner_type character varying,
    favorited_id integer,
    favorited_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favorites_id_seq OWNED BY favorites.id;


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
-- Name: job_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE job_applications (
    id integer NOT NULL,
    specialist_id integer,
    project_id integer,
    message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    visibility character varying
);


--
-- Name: job_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE job_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE job_applications_id_seq OWNED BY job_applications.id;


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
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages (
    id integer NOT NULL,
    thread_id integer,
    thread_type character varying,
    sender_id integer,
    sender_type character varying,
    recipient_id integer,
    recipient_type character varying,
    message character varying,
    file_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


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
    fee_type character varying DEFAULT 'upfront_fee'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tsv tsvector,
    lat numeric(9,5),
    lng numeric(9,5),
    point geography,
    calculated_budget numeric,
    specialist_id integer,
    job_applications_count integer DEFAULT 0 NOT NULL
);


--
-- Name: metrics_jobs_installment_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_installment_pay AS
 SELECT 'jobs_installment_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'full_time'::text) AND ((projects.fee_type)::text = 'monthly_fee'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'full_time'::text) AND ((projects.fee_type)::text = 'monthly_fee'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.fee_type)::text = 'monthly_fee'::text))) itd;


--
-- Name: metrics_jobs_posted; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_posted AS
 SELECT 'jobs_posted'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((projects.type)::text = 'full_time'::text)) itd;


--
-- Name: metrics_jobs_share; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_share AS
 SELECT 'jobs_share'::character varying AS metric,
    mtd.pct AS mtd,
    fytd.pct AS fytd,
    itd.pct AS itd
   FROM ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE (projects_1.created_at >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date)))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE ((projects_1.created_at)::date >= (
                        CASE
                            WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                            ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                        END)::date)))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE ((projects.type)::text = 'full_time'::text)) itd;


--
-- Name: metrics_jobs_upfront_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_upfront_pay AS
 SELECT 'jobs_upfront_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'full_time'::text) AND ((projects.fee_type)::text = 'upfront_fee'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'full_time'::text) AND ((projects.fee_type)::text = 'upfront_fee'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.fee_type)::text = 'upfront_fee'::text))) itd;


--
-- Name: metrics_jobs_value; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_value AS
 SELECT 'jobs_value'::character varying AS metric,
    mtd.avg AS mtd,
    fytd.avg AS fytd,
    itd.avg AS itd
   FROM ( SELECT avg(projects.annual_salary) AS avg
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT avg(projects.annual_salary) AS avg
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT avg(projects.annual_salary) AS avg
           FROM projects
          WHERE ((projects.type)::text = 'full_time'::text)) itd;


--
-- Name: metrics_projects_fixed_50_50_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_50_50_pay AS
 SELECT 'projects_fixed_50_50_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'fifty_fifty'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'fifty_fifty'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'fifty_fifty'::text))) itd;


--
-- Name: metrics_projects_fixed_bi_weekly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_bi_weekly_pay AS
 SELECT 'projects_fixed_bi_weekly_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'bi_weekly'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'bi_weekly'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'bi_weekly'::text))) itd;


--
-- Name: metrics_projects_fixed_monthly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_monthly_pay AS
 SELECT 'projects_fixed_monthly_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'monthly'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'monthly'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'monthly'::text))) itd;


--
-- Name: metrics_projects_fixed_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_pay AS
 SELECT 'projects_fixed_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text))) itd;


--
-- Name: metrics_projects_fixed_share; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_share AS
 SELECT 'projects_fixed_share'::character varying AS metric,
    mtd.pct AS mtd,
    fytd.pct AS fytd,
    itd.pct AS itd
   FROM ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE (((projects_1.type)::text = 'one_off'::text) AND (projects_1.created_at >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE (((projects_1.type)::text = 'one_off'::text) AND ((projects_1.created_at)::date >= (
                        CASE
                            WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                            ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                        END)::date))))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE ((projects_1.type)::text = 'one_off'::text)))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text))) itd;


--
-- Name: metrics_projects_fixed_upon_completion_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_upon_completion_pay AS
 SELECT 'projects_fixed_upon_completion_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'upon_completion'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'upon_completion'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'upon_completion'::text))) itd;


--
-- Name: metrics_projects_hourly_bi_weekly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_bi_weekly_pay AS
 SELECT 'projects_hourly_bi_weekly_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'bi_weekly'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'bi_weekly'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'bi_weekly'::text))) itd;


--
-- Name: metrics_projects_hourly_monthly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_monthly_pay AS
 SELECT 'projects_hourly_monthly_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'monthly'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'monthly'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'monthly'::text))) itd;


--
-- Name: metrics_projects_hourly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_pay AS
 SELECT 'projects_hourly_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text))) itd;


--
-- Name: metrics_projects_hourly_share; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_share AS
 SELECT 'projects_hourly_share'::character varying AS metric,
    mtd.pct AS mtd,
    fytd.pct AS fytd,
    itd.pct AS itd
   FROM ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE (((projects_1.type)::text = 'one_off'::text) AND (projects_1.created_at >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE (((projects_1.type)::text = 'one_off'::text) AND ((projects_1.created_at)::date >= (
                        CASE
                            WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                            ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                        END)::date))))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE ((projects_1.type)::text = 'one_off'::text)))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text))) itd;


--
-- Name: metrics_projects_hourly_upon_completion_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_upon_completion_pay AS
 SELECT 'projects_hourly_upon_completion_pay'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'upon_completion'::text)) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'upon_completion'::text)) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'upon_completion'::text))) itd;


--
-- Name: metrics_projects_posted; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_posted AS
 SELECT 'projects_posted'::character varying AS metric,
    mtd.cnt AS mtd,
    fytd.cnt AS fytd,
    itd.cnt AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)) itd;


--
-- Name: metrics_projects_share; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_share AS
 SELECT 'projects_share'::character varying AS metric,
    mtd.pct AS mtd,
    fytd.pct AS fytd,
    itd.pct AS itd
   FROM ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE (projects_1.created_at >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date)))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1
                  WHERE ((projects_1.created_at)::date >= (
                        CASE
                            WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                            ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                        END)::date)))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT (((count(*))::double precision / (( SELECT count(*) AS count
                   FROM projects projects_1))::double precision) * (100)::double precision) AS pct
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)) itd;


--
-- Name: metrics_projects_value; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_value AS
 SELECT 'projects_value'::character varying AS metric,
    mtd.avg AS mtd,
    fytd.avg AS fytd,
    itd.avg AS itd
   FROM ( SELECT avg(COALESCE(projects.fixed_budget, (projects.hourly_rate * (projects.estimated_hours)::numeric))) AS avg
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.created_at)::date >= ((((date_part('year'::text, ('now'::text)::date) || '-'::text) || date_part('month'::text, ('now'::text)::date)) || '-01'::text))::date))) mtd,
    ( SELECT avg(COALESCE(projects.fixed_budget, (projects.hourly_rate * (projects.estimated_hours)::numeric))) AS avg
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.created_at)::date >= (
                CASE
                    WHEN (('now'::text)::date >= ((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date) THEN (((date_part('year'::text, ('now'::text)::date) || '/10/01'::text))::date)::text
                    ELSE ((((date_part('year'::text, ('now'::text)::date) - (1)::double precision) || '/10/01'::text))::date)::text
                END)::date))) fytd,
    ( SELECT avg(COALESCE(projects.fixed_budget, (projects.hourly_rate * (projects.estimated_hours)::numeric))) AS avg
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)) itd;


--
-- Name: metrics; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics AS
 SELECT metrics_projects_posted.metric,
    metrics_projects_posted.mtd,
    metrics_projects_posted.fytd,
    metrics_projects_posted.itd
   FROM metrics_projects_posted
UNION
 SELECT metrics_projects_value.metric,
    metrics_projects_value.mtd,
    metrics_projects_value.fytd,
    metrics_projects_value.itd
   FROM metrics_projects_value
UNION
 SELECT metrics_projects_share.metric,
    metrics_projects_share.mtd,
    metrics_projects_share.fytd,
    metrics_projects_share.itd
   FROM metrics_projects_share
UNION
 SELECT metrics_projects_hourly_share.metric,
    metrics_projects_hourly_share.mtd,
    metrics_projects_hourly_share.fytd,
    metrics_projects_hourly_share.itd
   FROM metrics_projects_hourly_share
UNION
 SELECT metrics_projects_fixed_share.metric,
    metrics_projects_fixed_share.mtd,
    metrics_projects_fixed_share.fytd,
    metrics_projects_fixed_share.itd
   FROM metrics_projects_fixed_share
UNION
 SELECT metrics_projects_hourly_pay.metric,
    metrics_projects_hourly_pay.mtd,
    metrics_projects_hourly_pay.fytd,
    metrics_projects_hourly_pay.itd
   FROM metrics_projects_hourly_pay
UNION
 SELECT metrics_projects_hourly_upon_completion_pay.metric,
    metrics_projects_hourly_upon_completion_pay.mtd,
    metrics_projects_hourly_upon_completion_pay.fytd,
    metrics_projects_hourly_upon_completion_pay.itd
   FROM metrics_projects_hourly_upon_completion_pay
UNION
 SELECT metrics_projects_hourly_bi_weekly_pay.metric,
    metrics_projects_hourly_bi_weekly_pay.mtd,
    metrics_projects_hourly_bi_weekly_pay.fytd,
    metrics_projects_hourly_bi_weekly_pay.itd
   FROM metrics_projects_hourly_bi_weekly_pay
UNION
 SELECT metrics_projects_hourly_monthly_pay.metric,
    metrics_projects_hourly_monthly_pay.mtd,
    metrics_projects_hourly_monthly_pay.fytd,
    metrics_projects_hourly_monthly_pay.itd
   FROM metrics_projects_hourly_monthly_pay
UNION
 SELECT metrics_projects_fixed_pay.metric,
    metrics_projects_fixed_pay.mtd,
    metrics_projects_fixed_pay.fytd,
    metrics_projects_fixed_pay.itd
   FROM metrics_projects_fixed_pay
UNION
 SELECT metrics_projects_fixed_50_50_pay.metric,
    metrics_projects_fixed_50_50_pay.mtd,
    metrics_projects_fixed_50_50_pay.fytd,
    metrics_projects_fixed_50_50_pay.itd
   FROM metrics_projects_fixed_50_50_pay
UNION
 SELECT metrics_projects_fixed_upon_completion_pay.metric,
    metrics_projects_fixed_upon_completion_pay.mtd,
    metrics_projects_fixed_upon_completion_pay.fytd,
    metrics_projects_fixed_upon_completion_pay.itd
   FROM metrics_projects_fixed_upon_completion_pay
UNION
 SELECT metrics_projects_fixed_bi_weekly_pay.metric,
    metrics_projects_fixed_bi_weekly_pay.mtd,
    metrics_projects_fixed_bi_weekly_pay.fytd,
    metrics_projects_fixed_bi_weekly_pay.itd
   FROM metrics_projects_fixed_bi_weekly_pay
UNION
 SELECT metrics_projects_fixed_monthly_pay.metric,
    metrics_projects_fixed_monthly_pay.mtd,
    metrics_projects_fixed_monthly_pay.fytd,
    metrics_projects_fixed_monthly_pay.itd
   FROM metrics_projects_fixed_monthly_pay
UNION
 SELECT metrics_jobs_posted.metric,
    metrics_jobs_posted.mtd,
    metrics_jobs_posted.fytd,
    metrics_jobs_posted.itd
   FROM metrics_jobs_posted
UNION
 SELECT metrics_jobs_value.metric,
    metrics_jobs_value.mtd,
    metrics_jobs_value.fytd,
    metrics_jobs_value.itd
   FROM metrics_jobs_value
UNION
 SELECT metrics_jobs_share.metric,
    metrics_jobs_share.mtd,
    metrics_jobs_share.fytd,
    metrics_jobs_share.itd
   FROM metrics_jobs_share
UNION
 SELECT metrics_jobs_upfront_pay.metric,
    metrics_jobs_upfront_pay.mtd,
    metrics_jobs_upfront_pay.fytd,
    metrics_jobs_upfront_pay.itd
   FROM metrics_jobs_upfront_pay
UNION
 SELECT metrics_jobs_installment_pay.metric,
    metrics_jobs_installment_pay.mtd,
    metrics_jobs_installment_pay.fytd,
    metrics_jobs_installment_pay.itd
   FROM metrics_jobs_installment_pay;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer,
    message character varying,
    path character varying,
    read_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


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
    stripe_id character varying NOT NULL,
    brand character varying NOT NULL,
    exp_month integer,
    exp_year integer,
    last4 character varying NOT NULL,
    "primary" boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying,
    country character varying,
    currency character varying,
    account_holder_name character varying,
    account_holder_type character varying,
    validated boolean DEFAULT false NOT NULL
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
-- Name: project_ends; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_ends (
    id integer NOT NULL,
    project_id integer,
    status character varying,
    expires_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_ends_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_ends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_ends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_ends_id_seq OWNED BY project_ends.id;


--
-- Name: project_extensions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_extensions (
    id integer NOT NULL,
    project_id integer,
    new_end_date date,
    expires_at timestamp without time zone,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_extensions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_extensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_extensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_extensions_id_seq OWNED BY project_extensions.id;


--
-- Name: project_invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_invites (
    id integer NOT NULL,
    business_id integer NOT NULL,
    project_id integer,
    specialist_id integer NOT NULL,
    message character varying,
    status character varying DEFAULT 'not_sent'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_invites_id_seq OWNED BY project_invites.id;


--
-- Name: project_issues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_issues (
    id integer NOT NULL,
    project_id integer,
    user_id integer,
    issue text,
    desired_resolution text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying DEFAULT 'open'::character varying NOT NULL,
    admin_user_id integer
);


--
-- Name: project_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_issues_id_seq OWNED BY project_issues.id;


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
-- Name: ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ratings (
    id integer NOT NULL,
    project_id integer,
    rater_id integer,
    rater_type character varying,
    value integer,
    review character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE settings (
    id integer NOT NULL,
    var character varying NOT NULL,
    value text,
    target_id integer NOT NULL,
    target_type character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settings_id_seq OWNED BY settings.id;


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
    updated_at timestamp without time zone NOT NULL,
    lat numeric(9,5),
    lng numeric(9,5),
    point geography,
    ratings_count integer DEFAULT 0 NOT NULL,
    ratings_total integer DEFAULT 0 NOT NULL,
    ratings_average double precision,
    deleted boolean DEFAULT false NOT NULL,
    time_zone character varying,
    address_1 character varying,
    address_2 character varying
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
-- Name: stripe_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stripe_accounts (
    id integer NOT NULL,
    specialist_id integer,
    status character varying DEFAULT 'Pending'::character varying NOT NULL,
    account_country character varying,
    account_currency character varying,
    account_routing_number character varying,
    account_number character varying,
    city character varying,
    address1 character varying,
    postal_code character varying,
    state character varying,
    country character varying,
    dob date,
    first_name character varying,
    last_name character varying,
    ssn_last_4 character varying,
    tos_acceptance_date date,
    tos_acceptance_ip character varying,
    personal_id_number character varying,
    verification_document_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_type character varying DEFAULT 'individual'::character varying NOT NULL,
    stripe_id character varying,
    business_name character varying,
    business_tax_id character varying
);


--
-- Name: stripe_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stripe_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stripe_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stripe_accounts_id_seq OWNED BY stripe_accounts.id;


--
-- Name: time_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE time_logs (
    id integer NOT NULL,
    timesheet_id integer,
    description character varying,
    hours numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: time_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE time_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE time_logs_id_seq OWNED BY time_logs.id;


--
-- Name: timesheets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timesheets (
    id integer NOT NULL,
    project_id integer,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: timesheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timesheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timesheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE timesheets_id_seq OWNED BY timesheets.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transactions (
    id integer NOT NULL,
    stripe_id character varying,
    type character varying,
    amount_in_cents integer,
    processed_at timestamp without time zone,
    status character varying,
    charge_source_id integer,
    payment_target_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    project_id integer,
    parent_transaction_id integer,
    status_detail character varying
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


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
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL
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

ALTER TABLE ONLY charges ALTER COLUMN id SET DEFAULT nextval('charges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY education_histories ALTER COLUMN id SET DEFAULT nextval('education_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_threads ALTER COLUMN id SET DEFAULT nextval('email_threads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorites ALTER COLUMN id SET DEFAULT nextval('favorites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY industries ALTER COLUMN id SET DEFAULT nextval('industries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY job_applications ALTER COLUMN id SET DEFAULT nextval('job_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jurisdictions ALTER COLUMN id SET DEFAULT nextval('jurisdictions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


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

ALTER TABLE ONLY project_ends ALTER COLUMN id SET DEFAULT nextval('project_ends_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_extensions ALTER COLUMN id SET DEFAULT nextval('project_extensions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_invites ALTER COLUMN id SET DEFAULT nextval('project_invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_issues ALTER COLUMN id SET DEFAULT nextval('project_issues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);


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

ALTER TABLE ONLY stripe_accounts ALTER COLUMN id SET DEFAULT nextval('stripe_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY time_logs ALTER COLUMN id SET DEFAULT nextval('time_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY timesheets ALTER COLUMN id SET DEFAULT nextval('timesheets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


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
-- Name: charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY charges
    ADD CONSTRAINT charges_pkey PRIMARY KEY (id);


--
-- Name: education_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY education_histories
    ADD CONSTRAINT education_histories_pkey PRIMARY KEY (id);


--
-- Name: email_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_threads
    ADD CONSTRAINT email_threads_pkey PRIMARY KEY (id);


--
-- Name: favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: job_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY job_applications
    ADD CONSTRAINT job_applications_pkey PRIMARY KEY (id);


--
-- Name: jurisdictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jurisdictions
    ADD CONSTRAINT jurisdictions_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


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
-- Name: project_ends_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_ends
    ADD CONSTRAINT project_ends_pkey PRIMARY KEY (id);


--
-- Name: project_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_extensions
    ADD CONSTRAINT project_extensions_pkey PRIMARY KEY (id);


--
-- Name: project_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_invites
    ADD CONSTRAINT project_invites_pkey PRIMARY KEY (id);


--
-- Name: project_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_issues
    ADD CONSTRAINT project_issues_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


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
-- Name: stripe_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stripe_accounts
    ADD CONSTRAINT stripe_accounts_pkey PRIMARY KEY (id);


--
-- Name: time_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY time_logs
    ADD CONSTRAINT time_logs_pkey PRIMARY KEY (id);


--
-- Name: timesheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timesheets
    ADD CONSTRAINT timesheets_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


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
-- Name: favorites_unique; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX favorites_unique ON favorites USING btree (owner_id, owner_type, favorited_id, favorited_type);


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
-- Name: index_businesses_on_ratings_average; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_businesses_on_ratings_average ON businesses USING btree (ratings_average);


--
-- Name: index_businesses_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_businesses_on_user_id ON businesses USING btree (user_id);


--
-- Name: index_charges_on_process_after; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_charges_on_process_after ON charges USING btree (process_after);


--
-- Name: index_charges_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_charges_on_project_id ON charges USING btree (project_id);


--
-- Name: index_charges_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_charges_on_status ON charges USING btree (status);


--
-- Name: index_charges_on_transaction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_charges_on_transaction_id ON charges USING btree (transaction_id);


--
-- Name: index_education_histories_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_education_histories_on_specialist_id ON education_histories USING btree (specialist_id);


--
-- Name: index_email_threads_on_business_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_email_threads_on_business_id ON email_threads USING btree (business_id);


--
-- Name: index_email_threads_on_business_id_and_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_email_threads_on_business_id_and_specialist_id ON email_threads USING btree (business_id, specialist_id);


--
-- Name: index_email_threads_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_email_threads_on_specialist_id ON email_threads USING btree (specialist_id);


--
-- Name: index_email_threads_on_thread_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_email_threads_on_thread_key ON email_threads USING btree (thread_key);


--
-- Name: index_favorites_on_favorited_type_and_favorited_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_favorited_type_and_favorited_id ON favorites USING btree (favorited_type, favorited_id);


--
-- Name: index_favorites_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_owner_type_and_owner_id ON favorites USING btree (owner_type, owner_id);


--
-- Name: index_industries_projects_on_industry_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_industries_projects_on_industry_id_and_project_id ON industries_projects USING btree (industry_id, project_id);


--
-- Name: index_job_applications_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_job_applications_on_project_id ON job_applications USING btree (project_id);


--
-- Name: index_job_applications_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_job_applications_on_specialist_id ON job_applications USING btree (specialist_id);


--
-- Name: index_job_applications_on_specialist_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_job_applications_on_specialist_id_and_project_id ON job_applications USING btree (specialist_id, project_id);


--
-- Name: index_jurisdictions_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_jurisdictions_on_name ON jurisdictions USING btree (name);


--
-- Name: index_jurisdictions_projects_on_jurisdiction_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_jurisdictions_projects_on_jurisdiction_id_and_project_id ON jurisdictions_projects USING btree (jurisdiction_id, project_id);


--
-- Name: index_messages_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_recipient_type_and_recipient_id ON messages USING btree (recipient_type, recipient_id);


--
-- Name: index_messages_on_sender_type_and_sender_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_sender_type_and_sender_id ON messages USING btree (sender_type, sender_id);


--
-- Name: index_messages_on_thread_type_and_thread_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_thread_type_and_thread_id ON messages USING btree (thread_type, thread_id);


--
-- Name: index_notifications_on_read_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_read_at ON notifications USING btree (read_at);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_user_id ON notifications USING btree (user_id);


--
-- Name: index_payment_profiles_on_business_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_profiles_on_business_id ON payment_profiles USING btree (business_id);


--
-- Name: index_payment_sources_on_payment_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_sources_on_payment_profile_id ON payment_sources USING btree (payment_profile_id);


--
-- Name: index_payment_sources_on_stripe_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_payment_sources_on_stripe_id ON payment_sources USING btree (stripe_id);


--
-- Name: index_payment_sources_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_sources_on_type ON payment_sources USING btree (type);


--
-- Name: index_project_ends_on_expires_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_ends_on_expires_at ON project_ends USING btree (expires_at);


--
-- Name: index_project_ends_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_ends_on_project_id ON project_ends USING btree (project_id);


--
-- Name: index_project_ends_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_ends_on_status ON project_ends USING btree (status);


--
-- Name: index_project_extensions_on_expires_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_extensions_on_expires_at ON project_extensions USING btree (expires_at);


--
-- Name: index_project_extensions_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_extensions_on_project_id ON project_extensions USING btree (project_id);


--
-- Name: index_project_extensions_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_extensions_on_status ON project_extensions USING btree (status);


--
-- Name: index_project_invites_on_business_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_invites_on_business_id ON project_invites USING btree (business_id);


--
-- Name: index_project_invites_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_invites_on_project_id ON project_invites USING btree (project_id);


--
-- Name: index_project_invites_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_invites_on_specialist_id ON project_invites USING btree (specialist_id);


--
-- Name: index_project_invites_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_invites_on_status ON project_invites USING btree (status);


--
-- Name: index_project_issues_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_issues_on_admin_user_id ON project_issues USING btree (admin_user_id);


--
-- Name: index_project_issues_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_issues_on_project_id ON project_issues USING btree (project_id);


--
-- Name: index_project_issues_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_issues_on_status ON project_issues USING btree (status);


--
-- Name: index_project_issues_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_project_issues_on_user_id ON project_issues USING btree (user_id);


--
-- Name: index_projects_on_annual_salary; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_annual_salary ON projects USING btree (annual_salary);


--
-- Name: index_projects_on_business_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_business_id ON projects USING btree (business_id);


--
-- Name: index_projects_on_calculated_budget; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_calculated_budget ON projects USING btree (calculated_budget);


--
-- Name: index_projects_on_estimated_hours; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_estimated_hours ON projects USING btree (estimated_hours);


--
-- Name: index_projects_on_fee_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_fee_type ON projects USING btree (fee_type);


--
-- Name: index_projects_on_fixed_budget; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_fixed_budget ON projects USING btree (fixed_budget);


--
-- Name: index_projects_on_hourly_rate; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_hourly_rate ON projects USING btree (hourly_rate);


--
-- Name: index_projects_on_minimum_experience; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_minimum_experience ON projects USING btree (minimum_experience);


--
-- Name: index_projects_on_only_regulators; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_only_regulators ON projects USING btree (only_regulators);


--
-- Name: index_projects_on_payment_schedule; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_payment_schedule ON projects USING btree (payment_schedule);


--
-- Name: index_projects_on_point; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_point ON projects USING gist (point);


--
-- Name: index_projects_on_pricing_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_pricing_type ON projects USING btree (pricing_type);


--
-- Name: index_projects_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_specialist_id ON projects USING btree (specialist_id);


--
-- Name: index_projects_on_starts_on; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_starts_on ON projects USING btree (starts_on);


--
-- Name: index_projects_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_status ON projects USING btree (status);


--
-- Name: index_projects_on_tsv; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_tsv ON projects USING gin (tsv);


--
-- Name: index_projects_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_type ON projects USING btree (type);


--
-- Name: index_projects_skills_on_project_id_and_skill_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_projects_skills_on_project_id_and_skill_id ON projects_skills USING btree (project_id, skill_id);


--
-- Name: index_ratings_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_project_id ON ratings USING btree (project_id);


--
-- Name: index_ratings_on_rater_type_and_rater_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_rater_type_and_rater_id ON ratings USING btree (rater_type, rater_id);


--
-- Name: index_settings_on_target_type_and_target_id_and_var; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_settings_on_target_type_and_target_id_and_var ON settings USING btree (target_type, target_id, var);


--
-- Name: index_skills_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_skills_on_name ON skills USING btree (name);


--
-- Name: index_skills_specialists_on_skill_id_and_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_skills_specialists_on_skill_id_and_specialist_id ON skills_specialists USING btree (skill_id, specialist_id);


--
-- Name: index_specialists_on_first_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_specialists_on_first_name ON specialists USING btree (first_name);


--
-- Name: index_specialists_on_former_regulator; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_specialists_on_former_regulator ON specialists USING btree (former_regulator);


--
-- Name: index_specialists_on_last_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_specialists_on_last_name ON specialists USING btree (last_name);


--
-- Name: index_specialists_on_point; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_specialists_on_point ON specialists USING gist (point);


--
-- Name: index_specialists_on_ratings_average; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_specialists_on_ratings_average ON specialists USING btree (ratings_average);


--
-- Name: index_specialists_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_specialists_on_user_id ON specialists USING btree (user_id);


--
-- Name: index_stripe_accounts_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stripe_accounts_on_specialist_id ON stripe_accounts USING btree (specialist_id);


--
-- Name: index_time_logs_on_timesheet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_time_logs_on_timesheet_id ON time_logs USING btree (timesheet_id);


--
-- Name: index_timesheets_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_timesheets_on_project_id ON timesheets USING btree (project_id);


--
-- Name: index_timesheets_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_timesheets_on_status ON timesheets USING btree (status);


--
-- Name: index_transactions_on_charge_source_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_charge_source_id ON transactions USING btree (charge_source_id);


--
-- Name: index_transactions_on_parent_transaction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_parent_transaction_id ON transactions USING btree (parent_transaction_id);


--
-- Name: index_transactions_on_payment_target_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_payment_target_id ON transactions USING btree (payment_target_id);


--
-- Name: index_transactions_on_processed_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_processed_at ON transactions USING btree (processed_at);


--
-- Name: index_transactions_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_project_id ON transactions USING btree (project_id);


--
-- Name: index_transactions_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_status ON transactions USING btree (status);


--
-- Name: index_transactions_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_type ON transactions USING btree (type);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_deleted ON users USING btree (deleted);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_work_experiences_on_compliance; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_work_experiences_on_compliance ON work_experiences USING btree (compliance);


--
-- Name: index_work_experiences_on_current; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_work_experiences_on_current ON work_experiences USING btree (current);


--
-- Name: index_work_experiences_on_from; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_work_experiences_on_from ON work_experiences USING btree ("from");


--
-- Name: index_work_experiences_on_specialist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_work_experiences_on_specialist_id ON work_experiences USING btree (specialist_id);


--
-- Name: index_work_experiences_on_to; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_work_experiences_on_to ON work_experiences USING btree ("to");


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
-- Name: calculate_budget; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER calculate_budget BEFORE INSERT OR UPDATE ON projects FOR EACH ROW EXECUTE PROCEDURE projects_calculate_budget();


--
-- Name: trigger_projects_on_lat_lng; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_projects_on_lat_lng BEFORE INSERT OR UPDATE OF lat, lng ON projects FOR EACH ROW EXECUTE PROCEDURE set_point_from_lat_lng();


--
-- Name: trigger_specialists_on_lat_lng; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_specialists_on_lat_lng BEFORE INSERT OR UPDATE OF lat, lng ON specialists FOR EACH ROW EXECUTE PROCEDURE set_point_from_lat_lng();


--
-- Name: tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON projects FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv', 'pg_catalog.english', 'title', 'description');


--
-- Name: fk_rails_7988d7b477; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stripe_accounts
    ADD CONSTRAINT fk_rails_7988d7b477 FOREIGN KEY (specialist_id) REFERENCES specialists(id);


--
-- Name: fk_rails_80e6243750; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_issues
    ADD CONSTRAINT fk_rails_80e6243750 FOREIGN KEY (admin_user_id) REFERENCES admin_users(id);


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

INSERT INTO schema_migrations (version) VALUES ('20160802183502');

INSERT INTO schema_migrations (version) VALUES ('20160802190058');

INSERT INTO schema_migrations (version) VALUES ('20160802200651');

INSERT INTO schema_migrations (version) VALUES ('20160802202615');

INSERT INTO schema_migrations (version) VALUES ('20160802210000');

INSERT INTO schema_migrations (version) VALUES ('20160802213145');

INSERT INTO schema_migrations (version) VALUES ('20160806190620');

INSERT INTO schema_migrations (version) VALUES ('20160807224348');

INSERT INTO schema_migrations (version) VALUES ('20160808122359');

INSERT INTO schema_migrations (version) VALUES ('20160808161529');

INSERT INTO schema_migrations (version) VALUES ('20160808163055');

INSERT INTO schema_migrations (version) VALUES ('20160808172557');

INSERT INTO schema_migrations (version) VALUES ('20160809161615');

INSERT INTO schema_migrations (version) VALUES ('20160810005559');

INSERT INTO schema_migrations (version) VALUES ('20160810021451');

INSERT INTO schema_migrations (version) VALUES ('20160812150543');

INSERT INTO schema_migrations (version) VALUES ('20160815145734');

INSERT INTO schema_migrations (version) VALUES ('20160815191902');

INSERT INTO schema_migrations (version) VALUES ('20160816192820');

INSERT INTO schema_migrations (version) VALUES ('20160816195801');

INSERT INTO schema_migrations (version) VALUES ('20160820222822');

INSERT INTO schema_migrations (version) VALUES ('20160820222901');

INSERT INTO schema_migrations (version) VALUES ('20160824202048');

INSERT INTO schema_migrations (version) VALUES ('20160826174241');

INSERT INTO schema_migrations (version) VALUES ('20160830172251');

INSERT INTO schema_migrations (version) VALUES ('20160830180941');

INSERT INTO schema_migrations (version) VALUES ('20160830194700');

INSERT INTO schema_migrations (version) VALUES ('20160831005700');

INSERT INTO schema_migrations (version) VALUES ('20160831170413');

INSERT INTO schema_migrations (version) VALUES ('20160831202556');

INSERT INTO schema_migrations (version) VALUES ('20160901060934');

INSERT INTO schema_migrations (version) VALUES ('20160901175940');

INSERT INTO schema_migrations (version) VALUES ('20160905191421');

INSERT INTO schema_migrations (version) VALUES ('20160906170404');

INSERT INTO schema_migrations (version) VALUES ('20160907162030');

INSERT INTO schema_migrations (version) VALUES ('20160908143324');

INSERT INTO schema_migrations (version) VALUES ('20160908170540');

INSERT INTO schema_migrations (version) VALUES ('20160909053710');

INSERT INTO schema_migrations (version) VALUES ('20160909170311');

INSERT INTO schema_migrations (version) VALUES ('20160909170614');

INSERT INTO schema_migrations (version) VALUES ('20160913025529');

INSERT INTO schema_migrations (version) VALUES ('20160913030250');

INSERT INTO schema_migrations (version) VALUES ('20160914160717');

INSERT INTO schema_migrations (version) VALUES ('20160916041708');

INSERT INTO schema_migrations (version) VALUES ('20160920034425');

INSERT INTO schema_migrations (version) VALUES ('20160929002205');

INSERT INTO schema_migrations (version) VALUES ('20160929181728');

INSERT INTO schema_migrations (version) VALUES ('20161004031506');

INSERT INTO schema_migrations (version) VALUES ('20161005031450');

INSERT INTO schema_migrations (version) VALUES ('20161005041957');

INSERT INTO schema_migrations (version) VALUES ('20161005193709');

INSERT INTO schema_migrations (version) VALUES ('20161006060606');

INSERT INTO schema_migrations (version) VALUES ('20161006192238');

