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
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


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


--
-- Name: truncate_tables(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION truncate_tables() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    statements CURSOR FOR
    SELECT tablename FROM pg_tables
    WHERE schemaname = 'public';
BEGIN
  FOR stmt IN statements LOOP
    EXECUTE 'DELETE FROM ' || quote_ident(stmt.tablename) || ' CASCADE;';
  END LOOP;
END;
$$;


--
-- Name: truncate_tables(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION truncate_tables(username character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    statements CURSOR FOR
    SELECT tablename FROM pg_tables
    WHERE schemaname = 'public';
BEGIN
  FOR stmt IN statements LOOP
    EXECUTE 'DELETE FROM ' || quote_ident(stmt.tablename) || ' CASCADE;';
  END LOOP;
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
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    question_id integer NOT NULL,
    text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


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
    transaction_id integer,
    fee_in_cents integer,
    total_with_fee_in_cents integer,
    running_balance_in_cents integer,
    specialist_amount_in_cents integer DEFAULT 0 NOT NULL
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
-- Name: documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE documents (
    id integer NOT NULL,
    owner_id integer,
    owner_type character varying,
    project_id integer NOT NULL,
    file_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


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
    calculated_budget numeric,
    lat numeric(9,5),
    lng numeric(9,5),
    point geography,
    specialist_id integer,
    job_applications_count integer DEFAULT 0 NOT NULL,
    published_at timestamp without time zone,
    completed_at timestamp without time zone,
    hired_at timestamp without time zone,
    extended_at timestamp without time zone
);


--
-- Name: financials_actual; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW financials_actual AS
 WITH completed AS (
         SELECT projects.completed_at
           FROM projects
          WHERE (projects.completed_at IS NOT NULL)
        ), all_value AS (
         SELECT projects.completed_at,
            projects.type,
            charges.project_id,
            ((charges.amount_in_cents)::numeric / 100.0) AS value,
            ((charges.fee_in_cents)::numeric / 100.0) AS revenue,
            ((charges.total_with_fee_in_cents)::numeric / 100.0) AS total
           FROM (charges
             JOIN projects ON ((projects.id = charges.project_id)))
        ), job_revenue AS (
         SELECT all_value.project_id,
            all_value.completed_at,
            all_value.revenue
           FROM all_value
          WHERE ((all_value.type)::text = 'full_time'::text)
        ), project_revenue AS (
         SELECT all_value.completed_at,
            all_value.type,
            all_value.project_id,
            all_value.value,
            all_value.revenue,
            all_value.total
           FROM all_value
          WHERE ((all_value.type)::text = 'one_off'::text)
        )
 SELECT 'actual_completed'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM completed) AS itd
UNION
 SELECT 'actual_value'::character varying AS metric,
    ( SELECT sum(all_value.total) AS sum
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT sum(all_value.total) AS sum
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT sum(all_value.total) AS sum
           FROM all_value) AS itd
UNION
 SELECT 'actual_revenue'::character varying AS metric,
    ( SELECT sum(all_value.revenue) AS sum
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT sum(all_value.revenue) AS sum
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT sum(all_value.revenue) AS sum
           FROM all_value) AS itd
UNION
 SELECT 'actual_revenue_per_job'::character varying AS metric,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(job_revenue.revenue) AS revenue
                   FROM job_revenue
                  WHERE (job_revenue.completed_at >= date_trunc('month'::text, now()))
                  GROUP BY job_revenue.project_id) rev) AS mtd,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(job_revenue.revenue) AS revenue
                   FROM job_revenue
                  WHERE (job_revenue.completed_at >= date_trunc('year'::text, now()))
                  GROUP BY job_revenue.project_id) rev) AS fytd,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(job_revenue.revenue) AS revenue
                   FROM job_revenue
                  GROUP BY job_revenue.project_id) rev) AS itd
UNION
 SELECT 'actual_revenue_per_project'::character varying AS metric,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(project_revenue.revenue) AS revenue
                   FROM project_revenue
                  WHERE (project_revenue.completed_at >= date_trunc('month'::text, now()))
                  GROUP BY project_revenue.project_id) rev) AS mtd,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(project_revenue.revenue) AS revenue
                   FROM project_revenue
                  WHERE (project_revenue.completed_at >= date_trunc('year'::text, now()))
                  GROUP BY project_revenue.project_id) rev) AS fytd,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(project_revenue.revenue) AS revenue
                   FROM project_revenue
                  GROUP BY project_revenue.project_id) rev) AS itd
UNION
 SELECT 'actual_job_share'::character varying AS metric,
    (((mtd.revenue)::double precision / (t_mtd.revenue)::double precision) * (100)::double precision) AS mtd,
    (((fytd.revenue)::double precision / (t_fytd.revenue)::double precision) * (100)::double precision) AS fytd,
    (((itd.revenue)::double precision / (t_itd.revenue)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (((all_value.type)::text = 'full_time'::text) AND (all_value.completed_at >= date_trunc('month'::text, now())))) mtd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (((all_value.type)::text = 'full_time'::text) AND (all_value.completed_at >= date_trunc('year'::text, now())))) fytd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE ((all_value.type)::text = 'full_time'::text)) itd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('month'::text, now()))) t_mtd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('year'::text, now()))) t_fytd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value) t_itd
UNION
 SELECT 'actual_project_share'::character varying AS metric,
    (((mtd.revenue)::double precision / (t_mtd.revenue)::double precision) * (100)::double precision) AS mtd,
    (((fytd.revenue)::double precision / (t_fytd.revenue)::double precision) * (100)::double precision) AS fytd,
    (((itd.revenue)::double precision / (t_itd.revenue)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (((all_value.type)::text = 'one_off'::text) AND (all_value.completed_at >= date_trunc('month'::text, now())))) mtd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (((all_value.type)::text = 'one_off'::text) AND (all_value.completed_at >= date_trunc('year'::text, now())))) fytd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE ((all_value.type)::text = 'one_off'::text)) itd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('month'::text, now()))) t_mtd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('year'::text, now()))) t_fytd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value) t_itd;


--
-- Name: financials_forecasted; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW financials_forecasted AS
 WITH active AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((projects.status)::text = 'published'::text)
        ), all_value AS (
         SELECT projects.created_at,
            projects.type,
            charges.project_id,
            ((charges.amount_in_cents)::double precision / (100)::double precision) AS value,
            ((charges.fee_in_cents)::double precision / (100)::double precision) AS revenue
           FROM (charges
             JOIN projects ON ((projects.id = charges.project_id)))
          WHERE ((charges.status)::text = 'estimated'::text)
        ), job_revenue AS (
         SELECT all_value.project_id,
            all_value.created_at,
            all_value.revenue
           FROM all_value
          WHERE ((all_value.type)::text = 'full_time'::text)
        ), project_revenue AS (
         SELECT all_value.created_at,
            all_value.type,
            all_value.project_id,
            all_value.value,
            all_value.revenue
           FROM all_value
          WHERE ((all_value.type)::text = 'one_off'::text)
        )
 SELECT 'forecasted_completed'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM active
          WHERE (active.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM active
          WHERE (active.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM active) AS itd
UNION
 SELECT 'forecasted_value'::character varying AS metric,
    ( SELECT sum(all_value.value) AS sum
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT sum(all_value.value) AS sum
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT sum(all_value.value) AS sum
           FROM all_value) AS itd
UNION
 SELECT 'forecasted_revenue'::character varying AS metric,
    ( SELECT sum(all_value.revenue) AS sum
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT sum(all_value.revenue) AS sum
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT sum(all_value.revenue) AS sum
           FROM all_value) AS itd
UNION
 SELECT 'forecasted_revenue_per_job'::character varying AS metric,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(job_revenue.revenue) AS revenue
                   FROM job_revenue
                  WHERE (job_revenue.created_at >= date_trunc('month'::text, now()))
                  GROUP BY job_revenue.project_id) rev) AS mtd,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(job_revenue.revenue) AS revenue
                   FROM job_revenue
                  WHERE (job_revenue.created_at >= date_trunc('year'::text, now()))
                  GROUP BY job_revenue.project_id) rev) AS fytd,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(job_revenue.revenue) AS revenue
                   FROM job_revenue
                  GROUP BY job_revenue.project_id) rev) AS itd
UNION
 SELECT 'forecasted_revenue_per_project'::character varying AS metric,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(project_revenue.revenue) AS revenue
                   FROM project_revenue
                  WHERE (project_revenue.created_at >= date_trunc('month'::text, now()))
                  GROUP BY project_revenue.project_id) rev) AS mtd,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(project_revenue.revenue) AS revenue
                   FROM project_revenue
                  WHERE (project_revenue.created_at >= date_trunc('year'::text, now()))
                  GROUP BY project_revenue.project_id) rev) AS fytd,
    ( SELECT avg(rev.revenue) AS avg
           FROM ( SELECT avg(project_revenue.revenue) AS revenue
                   FROM project_revenue
                  GROUP BY project_revenue.project_id) rev) AS itd
UNION
 SELECT 'forecasted_job_share'::character varying AS metric,
    ((mtd.revenue / t_mtd.revenue) * (100)::double precision) AS mtd,
    ((fytd.revenue / t_fytd.revenue) * (100)::double precision) AS fytd,
    ((itd.revenue / t_itd.revenue) * (100)::double precision) AS itd
   FROM ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (((all_value.type)::text = 'full_time'::text) AND (all_value.created_at >= date_trunc('month'::text, now())))) mtd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (((all_value.type)::text = 'full_time'::text) AND (all_value.created_at >= date_trunc('year'::text, now())))) fytd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE ((all_value.type)::text = 'full_time'::text)) itd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('month'::text, now()))) t_mtd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('year'::text, now()))) t_fytd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value) t_itd
UNION
 SELECT 'forecasted_project_share'::character varying AS metric,
    ((mtd.revenue / t_mtd.revenue) * (100)::double precision) AS mtd,
    ((fytd.revenue / t_fytd.revenue) * (100)::double precision) AS fytd,
    ((itd.revenue / t_itd.revenue) * (100)::double precision) AS itd
   FROM ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (((all_value.type)::text = 'one_off'::text) AND (all_value.created_at >= date_trunc('month'::text, now())))) mtd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (((all_value.type)::text = 'one_off'::text) AND (all_value.created_at >= date_trunc('year'::text, now())))) fytd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE ((all_value.type)::text = 'one_off'::text)) itd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('month'::text, now()))) t_mtd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('year'::text, now()))) t_fytd,
    ( SELECT sum(all_value.revenue) AS revenue
           FROM all_value) t_itd;


--
-- Name: financials; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW financials AS
 SELECT financials_actual.metric,
    financials_actual.mtd,
    financials_actual.fytd,
    financials_actual.itd
   FROM financials_actual
UNION
 SELECT financials_forecasted.metric,
    financials_forecasted.mtd,
    financials_forecasted.fytd,
    financials_forecasted.itd
   FROM financials_forecasted;


--
-- Name: financials_postings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW financials_postings AS
 WITH active AS (
         SELECT projects.created_at
           FROM projects
          WHERE (projects.completed_at IS NULL)
        ), all_projects AS (
         SELECT projects.created_at,
            projects.type,
            projects.pricing_type,
            projects.calculated_budget,
            projects.annual_salary,
            projects.fee_type
           FROM projects
        ), job_value AS (
         SELECT (all_projects.calculated_budget *
                CASE
                    WHEN ((all_projects.fee_type)::text = 'upfront_fee'::text) THEN 1.15
                    ELSE 1.18
                END) AS value
           FROM all_projects
          WHERE ((all_projects.type)::text = 'full_time'::text)
        ), job_revenue AS (
         SELECT (all_projects.calculated_budget *
                CASE
                    WHEN ((all_projects.fee_type)::text = 'upfront_fee'::text) THEN 0.15
                    ELSE 0.18
                END) AS revenue
           FROM all_projects
          WHERE ((all_projects.type)::text = 'full_time'::text)
        ), project_value AS (
         SELECT all_projects.created_at,
            (all_projects.calculated_budget * 1.20) AS value
           FROM all_projects
          WHERE ((all_projects.type)::text = 'one_off'::text)
        ), project_revenue AS (
         SELECT (all_projects.calculated_budget * 0.2) AS revenue
           FROM all_projects
          WHERE ((all_projects.type)::text = 'one_off'::text)
        ), all_value AS (
         SELECT (COALESCE(a.value, (0)::numeric) + COALESCE(b.value, (0)::numeric)) AS value
           FROM ( SELECT sum(job_value.value) AS value
                   FROM job_value) a,
            ( SELECT sum(project_value.value) AS value
                   FROM project_value) b
        ), all_revenue AS (
         SELECT (COALESCE(a.revenue, (0)::numeric) + COALESCE(b.revenue, (0)::numeric)) AS revenue
           FROM ( SELECT sum(job_revenue.revenue) AS revenue
                   FROM job_revenue) a,
            ( SELECT sum(project_revenue.revenue) AS revenue
                   FROM project_revenue) b
        )
 SELECT 'postings_value'::character varying AS metric,
    ( SELECT sum(all_value.value) AS sum
           FROM all_value) AS value
UNION
 SELECT 'postings_revenue'::character varying AS metric,
    ( SELECT sum(all_revenue.revenue) AS sum
           FROM all_revenue) AS value
UNION
 SELECT 'postings_revenue_per_job'::character varying AS metric,
    ( SELECT avg(job_revenue.revenue) AS avg
           FROM job_revenue) AS value
UNION
 SELECT 'postings_revenue_per_project'::character varying AS metric,
    ( SELECT avg(project_revenue.revenue) AS avg
           FROM project_revenue) AS value
UNION
 SELECT 'postings_job_share'::character varying AS metric,
    ((j.revenue / a.revenue) * (100)::numeric) AS value
   FROM ( SELECT COALESCE(sum(all_revenue.revenue), (0)::numeric) AS revenue
           FROM all_revenue) a,
    ( SELECT COALESCE(sum(job_revenue.revenue), (0)::numeric) AS revenue
           FROM job_revenue) j
UNION
 SELECT 'postings_project_share'::character varying AS metric,
    ((p.revenue / a.revenue) * (100)::numeric) AS value
   FROM ( SELECT COALESCE(sum(all_revenue.revenue), (0)::numeric) AS revenue
           FROM all_revenue) a,
    ( SELECT COALESCE(sum(project_revenue.revenue), (0)::numeric) AS revenue
           FROM project_revenue) p;


--
-- Name: flags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE flags (
    id integer NOT NULL,
    flagged_content_id integer,
    flagged_content_type character varying,
    flagger_id integer,
    flagger_type character varying,
    reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE flags_id_seq OWNED BY flags.id;


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
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    tos_acceptance_date timestamp without time zone,
    tos_acceptance_ip character varying
);


--
-- Name: metrics_account_deletions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_account_deletions AS
 WITH deleted_users AS (
         SELECT users.id,
            users.deleted_at
           FROM users
          WHERE (users.deleted_at IS NOT NULL)
        ), deleted_businesses AS (
         SELECT deleted_users.deleted_at
           FROM (deleted_users
             JOIN businesses ON ((businesses.user_id = deleted_users.id)))
        ), deleted_specialists AS (
         SELECT deleted_users.deleted_at
           FROM (deleted_users
             JOIN specialists ON ((specialists.user_id = deleted_users.id)))
        )
 SELECT 'all_account_deletions'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM deleted_users
          WHERE (deleted_users.deleted_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM deleted_users
          WHERE (deleted_users.deleted_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM deleted_users) AS itd
UNION
 SELECT 'business_account_deletions'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM deleted_businesses
          WHERE (deleted_businesses.deleted_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM deleted_businesses
          WHERE (deleted_businesses.deleted_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM deleted_businesses) AS itd
UNION
 SELECT 'specialist_account_deletions'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM deleted_specialists
          WHERE (deleted_specialists.deleted_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM deleted_specialists
          WHERE (deleted_specialists.deleted_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM deleted_specialists) AS itd;


--
-- Name: metrics_avg_staffing_times; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_avg_staffing_times AS
 WITH one_off AS (
         SELECT projects.published_at,
            projects.hired_at
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)
        ), full_time AS (
         SELECT projects.published_at,
            projects.hired_at
           FROM projects
          WHERE ((projects.type)::text = 'full_time'::text)
        )
 SELECT 'avg_staffing_time'::character varying AS metric,
    ( SELECT avg(date_part('days'::text, (projects.hired_at - projects.published_at))) AS avg
           FROM projects
          WHERE (projects.hired_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT avg(date_part('days'::text, (projects.hired_at - projects.published_at))) AS avg
           FROM projects
          WHERE (projects.hired_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT avg(date_part('days'::text, (projects.hired_at - projects.published_at))) AS avg
           FROM projects) AS itd
UNION
 SELECT 'avg_project_staffing_time'::character varying AS metric,
    ( SELECT avg(date_part('days'::text, (one_off.hired_at - one_off.published_at))) AS avg
           FROM one_off
          WHERE (one_off.hired_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT avg(date_part('days'::text, (one_off.hired_at - one_off.published_at))) AS avg
           FROM one_off
          WHERE (one_off.hired_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT avg(date_part('days'::text, (one_off.hired_at - one_off.published_at))) AS avg
           FROM one_off) AS itd
UNION
 SELECT 'avg_job_staffing_time'::character varying AS metric,
    ( SELECT avg(date_part('days'::text, (full_time.hired_at - full_time.published_at))) AS avg
           FROM full_time
          WHERE (full_time.hired_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT avg(date_part('days'::text, (full_time.hired_at - full_time.published_at))) AS avg
           FROM full_time
          WHERE (full_time.hired_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT avg(date_part('days'::text, (full_time.hired_at - full_time.published_at))) AS avg
           FROM full_time) AS itd;


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
-- Name: metrics_escalated_projects; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_escalated_projects AS
 WITH escalated_projects AS (
         SELECT project_issues.created_at AS escalated_at
           FROM project_issues
        )
 SELECT 'escalated_projects'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM escalated_projects
          WHERE (escalated_projects.escalated_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM escalated_projects
          WHERE (escalated_projects.escalated_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM escalated_projects) AS itd;


--
-- Name: metrics_extended_projects; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_extended_projects AS
 SELECT 'extended_projects'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM projects
          WHERE (projects.extended_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM projects
          WHERE (projects.extended_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM projects) AS itd;


--
-- Name: metrics_job_completions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_job_completions AS
 WITH full_time AS (
         SELECT projects.completed_at,
            projects.published_at,
            projects.pricing_type,
            projects.fee_type
           FROM projects
          WHERE ((projects.type)::text = 'full_time'::text)
        ), completed AS (
         SELECT full_time.completed_at,
            full_time.published_at,
            full_time.pricing_type,
            full_time.fee_type
           FROM full_time
          WHERE (full_time.completed_at IS NOT NULL)
        ), upfront_fee AS (
         SELECT completed.completed_at,
            completed.published_at,
            completed.pricing_type,
            completed.fee_type
           FROM completed
          WHERE ((completed.fee_type)::text = 'upfront_fee'::text)
        ), monthly_fee AS (
         SELECT completed.completed_at,
            completed.published_at,
            completed.pricing_type,
            completed.fee_type
           FROM completed
          WHERE ((completed.fee_type)::text = 'monthly_fee'::text)
        )
 SELECT 'completed_jobs'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM completed) AS itd
UNION
 SELECT 'completed_jobs_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM full_time) total,
    ( SELECT count(*) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM completed) itd
UNION
 SELECT 'completed_jobs_all_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects) total,
    ( SELECT count(*) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM completed) itd
UNION
 SELECT 'completed_jobs_upfront_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM upfront_fee
          WHERE (upfront_fee.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM upfront_fee
          WHERE (upfront_fee.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM upfront_fee) AS itd
UNION
 SELECT 'completed_jobs_monthly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM monthly_fee
          WHERE (monthly_fee.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM monthly_fee
          WHERE (monthly_fee.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM monthly_fee) AS itd;


--
-- Name: metrics_jobs_installment_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_installment_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.fee_type)::text = 'monthly_fee'::text))
        )
 SELECT 'jobs_installment_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_jobs_posted; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_posted AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((projects.type)::text = 'full_time'::text)
        )
 SELECT 'jobs_posted'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_jobs_share; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_share AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((projects.type)::text = 'full_time'::text)
        )
 SELECT 'jobs_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (projects.created_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (projects.created_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT count(*) AS cnt
           FROM projects) total_itd,
    ( SELECT count(*) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM base) itd;


--
-- Name: metrics_jobs_upfront_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_upfront_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.fee_type)::text = 'upfront_fee'::text))
        )
 SELECT 'jobs_upfront_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_jobs_value; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_jobs_value AS
 WITH base AS (
         SELECT projects.created_at,
            projects.annual_salary
           FROM projects
          WHERE ((projects.type)::text = 'full_time'::text)
        )
 SELECT 'jobs_value'::character varying AS metric,
    ( SELECT avg(base.annual_salary) AS avg
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT avg(base.annual_salary) AS avg
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT avg(base.annual_salary) AS avg
           FROM base) AS itd;


--
-- Name: metrics_project_completions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_project_completions AS
 WITH one_off AS (
         SELECT projects.completed_at,
            projects.pricing_type,
            projects.payment_schedule
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)
        ), completed AS (
         SELECT one_off.completed_at,
            one_off.pricing_type,
            one_off.payment_schedule
           FROM one_off
          WHERE (one_off.completed_at IS NOT NULL)
        ), hourly AS (
         SELECT completed.completed_at,
            completed.pricing_type,
            completed.payment_schedule
           FROM completed
          WHERE ((completed.pricing_type)::text = 'hourly'::text)
        ), fixed AS (
         SELECT completed.completed_at,
            completed.pricing_type,
            completed.payment_schedule
           FROM completed
          WHERE ((completed.pricing_type)::text = 'fixed'::text)
        ), hourly_upon_completion AS (
         SELECT hourly.completed_at,
            hourly.pricing_type,
            hourly.payment_schedule
           FROM hourly
          WHERE ((hourly.payment_schedule)::text = 'Upon Completion'::text)
        ), hourly_bi_weekly AS (
         SELECT hourly.completed_at,
            hourly.pricing_type,
            hourly.payment_schedule
           FROM hourly
          WHERE ((hourly.payment_schedule)::text = 'Bi-Weekly'::text)
        ), hourly_monthly AS (
         SELECT hourly.completed_at,
            hourly.pricing_type,
            hourly.payment_schedule
           FROM hourly
          WHERE ((hourly.payment_schedule)::text = 'Monthly'::text)
        ), fixed_upon_completion AS (
         SELECT fixed.completed_at,
            fixed.pricing_type,
            fixed.payment_schedule
           FROM fixed
          WHERE ((fixed.payment_schedule)::text = 'Upon Completion'::text)
        ), fixed_bi_weekly AS (
         SELECT fixed.completed_at,
            fixed.pricing_type,
            fixed.payment_schedule
           FROM fixed
          WHERE ((fixed.payment_schedule)::text = 'Bi-Weekly'::text)
        ), fixed_monthly AS (
         SELECT fixed.completed_at,
            fixed.pricing_type,
            fixed.payment_schedule
           FROM fixed
          WHERE ((fixed.payment_schedule)::text = 'Monthly'::text)
        ), fixed_50_50 AS (
         SELECT fixed.completed_at,
            fixed.pricing_type,
            fixed.payment_schedule
           FROM fixed
          WHERE ((fixed.payment_schedule)::text = '50/50'::text)
        )
 SELECT 'completed_projects'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM completed) AS itd
UNION
 SELECT 'completed_projects_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM one_off) total,
    ( SELECT count(*) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM completed) itd
UNION
 SELECT 'completed_projects_all_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects) total,
    ( SELECT count(*) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM completed) itd
UNION
 SELECT 'completed_projects_hourly_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM one_off) total,
    ( SELECT count(*) AS cnt
           FROM hourly
          WHERE (hourly.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM hourly
          WHERE (hourly.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM hourly) itd
UNION
 SELECT 'completed_projects_fixed_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM completed) total,
    ( SELECT count(*) AS cnt
           FROM fixed
          WHERE (fixed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM fixed
          WHERE (fixed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM fixed) itd
UNION
 SELECT 'completed_projects_hourly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM hourly
          WHERE (hourly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM hourly
          WHERE (hourly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM hourly) AS itd
UNION
 SELECT 'completed_projects_hourly_upon_completion_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM hourly_upon_completion
          WHERE (hourly_upon_completion.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM hourly_upon_completion
          WHERE (hourly_upon_completion.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM hourly_upon_completion) AS itd
UNION
 SELECT 'completed_projects_hourly_bi_weekly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM hourly_bi_weekly
          WHERE (hourly_bi_weekly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM hourly_bi_weekly
          WHERE (hourly_bi_weekly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM hourly_bi_weekly) AS itd
UNION
 SELECT 'completed_projects_hourly_monthly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM hourly_monthly
          WHERE (hourly_monthly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM hourly_monthly
          WHERE (hourly_monthly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM hourly_monthly) AS itd
UNION
 SELECT 'completed_projects_fixed_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM fixed
          WHERE (fixed.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM fixed
          WHERE (fixed.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM fixed) AS itd
UNION
 SELECT 'completed_projects_fixed_upon_completion_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM fixed_upon_completion
          WHERE (fixed_upon_completion.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM fixed_upon_completion
          WHERE (fixed_upon_completion.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM fixed_upon_completion) AS itd
UNION
 SELECT 'completed_projects_fixed_bi_weekly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM fixed_bi_weekly
          WHERE (fixed_bi_weekly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM fixed_bi_weekly
          WHERE (fixed_bi_weekly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM fixed_bi_weekly) AS itd
UNION
 SELECT 'completed_projects_fixed_monthly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM fixed_monthly
          WHERE (fixed_monthly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM fixed_monthly
          WHERE (fixed_monthly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM fixed_monthly) AS itd
UNION
 SELECT 'completed_projects_fixed_50_50_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM fixed_50_50
          WHERE (fixed_50_50.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM fixed_50_50
          WHERE (fixed_50_50.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM fixed_50_50) AS itd;


--
-- Name: metrics_projects_fixed_50_50_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_50_50_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = '50/50'::text))
        )
 SELECT 'projects_fixed_50_50_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_fixed_bi_weekly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_bi_weekly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'Bi-Weekly'::text))
        )
 SELECT 'projects_fixed_bi_weekly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_fixed_monthly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_monthly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'Monthly'::text))
        )
 SELECT 'projects_fixed_monthly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_fixed_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text))
        )
 SELECT 'projects_fixed_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_fixed_share; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_share AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text))
        )
 SELECT 'projects_fixed_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND (projects.created_at >= date_trunc('month'::text, now())))) total_mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND (projects.created_at >= date_trunc('year'::text, now())))) total_fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)) total_itd,
    ( SELECT count(*) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM base) itd;


--
-- Name: metrics_projects_fixed_upon_completion_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_fixed_upon_completion_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text)) AND ((projects.payment_schedule)::text = 'Upon Completion'::text))
        )
 SELECT 'projects_fixed_upon_completion_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_hourly_bi_weekly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_bi_weekly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'Bi-Weekly'::text))
        )
 SELECT 'projects_hourly_bi_weekly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_hourly_monthly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_monthly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'Monthly'::text))
        )
 SELECT 'projects_hourly_monthly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_hourly_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text))
        )
 SELECT 'projects_hourly_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_hourly_share; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_share AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text))
        )
 SELECT 'projects_hourly_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND (projects.created_at >= date_trunc('month'::text, now())))) total_mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND (projects.created_at >= date_trunc('year'::text, now())))) total_fytd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)) total_itd,
    ( SELECT count(*) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM base) itd;


--
-- Name: metrics_projects_hourly_upon_completion_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_hourly_upon_completion_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text)) AND ((projects.payment_schedule)::text = 'Upon Completion'::text))
        )
 SELECT 'projects_hourly_upon_completion_pay'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_posted; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_posted AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)
        )
 SELECT 'projects_posted'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM base) AS itd;


--
-- Name: metrics_projects_share; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_share AS
 WITH base AS (
         SELECT projects.created_at
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)
        )
 SELECT 'projects_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM projects
          WHERE (projects.created_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT count(*) AS cnt
           FROM projects
          WHERE (projects.created_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT count(*) AS cnt
           FROM projects) total_itd,
    ( SELECT count(*) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT count(*) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT count(*) AS cnt
           FROM base) itd;


--
-- Name: metrics_projects_value; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_projects_value AS
 WITH base AS (
         SELECT projects.created_at,
            projects.fixed_budget,
            projects.hourly_rate,
            projects.estimated_hours
           FROM projects
          WHERE ((projects.type)::text = 'one_off'::text)
        )
 SELECT 'projects_value'::character varying AS metric,
    mtd.avg AS mtd,
    fytd.avg AS fytd,
    itd.avg AS itd
   FROM ( SELECT avg(COALESCE(base.fixed_budget, (base.hourly_rate * (base.estimated_hours)::numeric))) AS avg
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT avg(COALESCE(base.fixed_budget, (base.hourly_rate * (base.estimated_hours)::numeric))) AS avg
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT avg(COALESCE(base.fixed_budget, (base.hourly_rate * (base.estimated_hours)::numeric))) AS avg
           FROM base) itd;


--
-- Name: metrics_signups; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_signups AS
 SELECT 'all_signups'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM users
          WHERE (users.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM users
          WHERE (users.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM users) AS itd
UNION
 SELECT 'business_signups'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM businesses
          WHERE (businesses.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM businesses
          WHERE (businesses.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM businesses) AS itd
UNION
 SELECT 'specialist_signups'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM specialists
          WHERE (specialists.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM specialists
          WHERE (specialists.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM specialists) AS itd;


--
-- Name: metrics_time_to_completion; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_time_to_completion AS
 WITH one_off AS (
         SELECT projects.hired_at,
            projects.completed_at
           FROM projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.status)::text = 'complete'::text))
        ), full_time AS (
         SELECT projects.hired_at,
            projects.completed_at
           FROM projects
          WHERE (((projects.type)::text = 'full_time'::text) AND ((projects.status)::text = 'complete'::text))
        )
 SELECT 'completed_projects_average_time'::character varying AS metric,
    ( SELECT avg(date_part('days'::text, (one_off.completed_at - one_off.hired_at))) AS avg
           FROM one_off
          WHERE (one_off.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT avg(date_part('days'::text, (one_off.completed_at - one_off.hired_at))) AS avg
           FROM one_off
          WHERE (one_off.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT avg(date_part('days'::text, (one_off.completed_at - one_off.hired_at))) AS avg
           FROM one_off) AS itd
UNION
 SELECT 'completed_jobs_average_time'::character varying AS metric,
    ( SELECT avg(date_part('days'::text, (full_time.completed_at - full_time.hired_at))) AS avg
           FROM full_time
          WHERE (full_time.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT avg(date_part('days'::text, (full_time.completed_at - full_time.hired_at))) AS avg
           FROM full_time
          WHERE (full_time.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT avg(date_part('days'::text, (full_time.completed_at - full_time.hired_at))) AS avg
           FROM full_time) AS itd;


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
   FROM metrics_jobs_installment_pay
UNION
 SELECT metrics_project_completions.metric,
    metrics_project_completions.mtd,
    metrics_project_completions.fytd,
    metrics_project_completions.itd
   FROM metrics_project_completions
UNION
 SELECT metrics_job_completions.metric,
    metrics_job_completions.mtd,
    metrics_job_completions.fytd,
    metrics_job_completions.itd
   FROM metrics_job_completions
UNION
 SELECT metrics_time_to_completion.metric,
    metrics_time_to_completion.mtd,
    metrics_time_to_completion.fytd,
    metrics_time_to_completion.itd
   FROM metrics_time_to_completion
UNION
 SELECT metrics_avg_staffing_times.metric,
    metrics_avg_staffing_times.mtd,
    metrics_avg_staffing_times.fytd,
    metrics_avg_staffing_times.itd
   FROM metrics_avg_staffing_times
UNION
 SELECT metrics_escalated_projects.metric,
    metrics_escalated_projects.mtd,
    metrics_escalated_projects.fytd,
    metrics_escalated_projects.itd
   FROM metrics_escalated_projects
UNION
 SELECT metrics_extended_projects.metric,
    metrics_extended_projects.mtd,
    metrics_extended_projects.fytd,
    metrics_extended_projects.itd
   FROM metrics_extended_projects
UNION
 SELECT metrics_account_deletions.metric,
    metrics_account_deletions.mtd,
    metrics_account_deletions.fytd,
    metrics_account_deletions.itd
   FROM metrics_account_deletions
UNION
 SELECT metrics_signups.metric,
    metrics_signups.mtd,
    metrics_signups.fytd,
    metrics_signups.itd
   FROM metrics_signups;


--
-- Name: metrics_activity; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW metrics_activity AS
 WITH dates AS (
         SELECT (now() - '30 days'::interval) AS thirty_days_ago
        ), totals AS (
         SELECT count(*) AS cnt
           FROM users
        ), all_users AS (
         SELECT users.current_sign_in_at
           FROM users
        ), businesses_count AS (
         SELECT users.current_sign_in_at
           FROM (users
             JOIN businesses ON ((businesses.user_id = users.id)))
        ), specialists_count AS (
         SELECT users.current_sign_in_at
           FROM (users
             JOIN specialists ON ((specialists.user_id = users.id)))
        )
 SELECT 'recent_activity'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM users
          WHERE (users.current_sign_in_at >= dates.thirty_days_ago)) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM users
          WHERE (users.current_sign_in_at >= dates.thirty_days_ago)) AS pct
   FROM totals,
    dates
UNION
 SELECT 'recent_activity_businesses'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM businesses_count businesses_count_1
          WHERE (businesses_count_1.current_sign_in_at >= dates.thirty_days_ago)) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM businesses_count businesses_count_1
          WHERE (businesses_count_1.current_sign_in_at >= dates.thirty_days_ago)) AS pct
   FROM totals,
    businesses_count,
    dates
UNION
 SELECT 'recent_activity_specialists'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM specialists_count specialists_count_1
          WHERE (specialists_count_1.current_sign_in_at >= dates.thirty_days_ago)) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM specialists_count specialists_count_1
          WHERE (specialists_count_1.current_sign_in_at >= dates.thirty_days_ago)) AS pct
   FROM totals,
    specialists_count,
    dates
UNION
 SELECT 'old_activity'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM users
          WHERE ((users.current_sign_in_at IS NULL) OR (users.current_sign_in_at < dates.thirty_days_ago))) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM users
          WHERE ((users.current_sign_in_at IS NULL) OR (users.current_sign_in_at < dates.thirty_days_ago))) AS pct
   FROM totals,
    dates
UNION
 SELECT 'old_activity_businesses'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM businesses_count businesses_count_1
          WHERE ((businesses_count_1.current_sign_in_at IS NULL) OR (businesses_count_1.current_sign_in_at < dates.thirty_days_ago))) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM businesses_count businesses_count_1
          WHERE ((businesses_count_1.current_sign_in_at IS NULL) OR (businesses_count_1.current_sign_in_at < dates.thirty_days_ago))) AS pct
   FROM totals,
    businesses_count,
    dates
UNION
 SELECT 'old_activity_specialists'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM specialists_count specialists_count_1
          WHERE ((specialists_count_1.current_sign_in_at IS NULL) OR (specialists_count_1.current_sign_in_at < dates.thirty_days_ago))) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM specialists_count specialists_count_1
          WHERE ((specialists_count_1.current_sign_in_at IS NULL) OR (specialists_count_1.current_sign_in_at < dates.thirty_days_ago))) AS pct
   FROM totals,
    specialists_count,
    dates
UNION
 SELECT 'all_activity_businesses'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM businesses_count) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM businesses_count) AS pct
   FROM totals,
    dates
UNION
 SELECT 'all_activity_specialists'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM specialists_count) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM specialists_count) AS pct
   FROM totals,
    dates;


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
    updated_at timestamp without time zone NOT NULL,
    key character varying,
    associated_id integer,
    associated_type character varying,
    clear_manually boolean DEFAULT false NOT NULL
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
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    project_id integer NOT NULL,
    text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    specialist_id integer
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


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
    account_currency character varying,
    account_routing_number character varying,
    account_number character varying,
    city character varying,
    address1 character varying,
    zipcode character varying,
    state character varying,
    country character varying,
    dob date,
    first_name character varying,
    last_name character varying,
    ssn_last_4 character varying,
    tos_acceptance_date timestamp without time zone,
    tos_acceptance_ip character varying,
    personal_id_number character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_type character varying DEFAULT 'individual'::character varying NOT NULL,
    stripe_id character varying,
    business_name character varying,
    business_tax_id character varying,
    additional_owners character varying,
    personal_city character varying,
    personal_address1 character varying,
    personal_zipcode character varying,
    status_detail character varying,
    verification_document text
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
    updated_at timestamp without time zone NOT NULL,
    hourly_rate numeric,
    total_amount numeric
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
    updated_at timestamp without time zone NOT NULL,
    approved_at timestamp without time zone
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
    status_detail character varying,
    fee_in_cents integer DEFAULT 0 NOT NULL,
    date timestamp without time zone
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

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


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

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


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

ALTER TABLE ONLY flags ALTER COLUMN id SET DEFAULT nextval('flags_id_seq'::regclass);


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

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


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
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


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
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


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
-- Name: flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


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
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


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
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_question_id ON answers USING btree (question_id);


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
-- Name: index_documents_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_documents_on_owner_type_and_owner_id ON documents USING btree (owner_type, owner_id);


--
-- Name: index_documents_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_documents_on_project_id ON documents USING btree (project_id);


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
-- Name: index_flags_on_flagged_content_type_and_flagged_content_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_flags_on_flagged_content_type_and_flagged_content_id ON flags USING btree (flagged_content_type, flagged_content_id);


--
-- Name: index_flags_on_flagger_type_and_flagger_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_flags_on_flagger_type_and_flagger_id ON flags USING btree (flagger_type, flagger_id);


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
-- Name: index_notifications_on_associated_type_and_associated_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_associated_type_and_associated_id ON notifications USING btree (associated_type, associated_id);


--
-- Name: index_notifications_on_clear_manually; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_clear_manually ON notifications USING btree (clear_manually);


--
-- Name: index_notifications_on_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_path ON notifications USING btree (path);


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
-- Name: index_projects_on_completed_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_completed_at ON projects USING btree (completed_at);


--
-- Name: index_projects_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_created_at ON projects USING btree (created_at);


--
-- Name: index_projects_on_estimated_hours; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_estimated_hours ON projects USING btree (estimated_hours);


--
-- Name: index_projects_on_extended_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_extended_at ON projects USING btree (extended_at);


--
-- Name: index_projects_on_fee_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_fee_type ON projects USING btree (fee_type);


--
-- Name: index_projects_on_fixed_budget; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_fixed_budget ON projects USING btree (fixed_budget);


--
-- Name: index_projects_on_hired_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_hired_at ON projects USING btree (hired_at);


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
-- Name: index_projects_on_published_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_published_at ON projects USING btree (published_at);


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
-- Name: index_questions_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_project_id ON questions USING btree (project_id);


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
-- Name: index_timesheets_on_approved_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_timesheets_on_approved_at ON timesheets USING btree (approved_at);


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
-- Name: index_transactions_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_date ON transactions USING btree (date);


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
-- Name: index_users_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_deleted_at ON users USING btree (deleted_at);


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

INSERT INTO schema_migrations (version) VALUES ('20161005195837');

INSERT INTO schema_migrations (version) VALUES ('20161006060606');

INSERT INTO schema_migrations (version) VALUES ('20161006192238');

INSERT INTO schema_migrations (version) VALUES ('20161010150831');

INSERT INTO schema_migrations (version) VALUES ('20161013042100');

INSERT INTO schema_migrations (version) VALUES ('20161013153825');

INSERT INTO schema_migrations (version) VALUES ('20161013154701');

INSERT INTO schema_migrations (version) VALUES ('20161014194840');

INSERT INTO schema_migrations (version) VALUES ('20161014195149');

INSERT INTO schema_migrations (version) VALUES ('20161014231410');

INSERT INTO schema_migrations (version) VALUES ('20161018182637');

INSERT INTO schema_migrations (version) VALUES ('20161018200158');

INSERT INTO schema_migrations (version) VALUES ('20161018231053');

INSERT INTO schema_migrations (version) VALUES ('20161019231647');

INSERT INTO schema_migrations (version) VALUES ('20161019233541');

INSERT INTO schema_migrations (version) VALUES ('20161019233916');

INSERT INTO schema_migrations (version) VALUES ('20161020003125');

INSERT INTO schema_migrations (version) VALUES ('20161020003532');

INSERT INTO schema_migrations (version) VALUES ('20161020004927');

INSERT INTO schema_migrations (version) VALUES ('20161020060113');

INSERT INTO schema_migrations (version) VALUES ('20161021013658');

INSERT INTO schema_migrations (version) VALUES ('20161021014432');

INSERT INTO schema_migrations (version) VALUES ('20161026162641');

INSERT INTO schema_migrations (version) VALUES ('20161026171857');

INSERT INTO schema_migrations (version) VALUES ('20161027163457');

INSERT INTO schema_migrations (version) VALUES ('20161104010221');

INSERT INTO schema_migrations (version) VALUES ('20161105034339');

INSERT INTO schema_migrations (version) VALUES ('20161107203304');

INSERT INTO schema_migrations (version) VALUES ('20161130201113');

INSERT INTO schema_migrations (version) VALUES ('20161204011945');

INSERT INTO schema_migrations (version) VALUES ('20161204020457');

INSERT INTO schema_migrations (version) VALUES ('20161207193307');

