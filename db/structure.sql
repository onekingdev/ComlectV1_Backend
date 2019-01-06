--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.10
-- Dumped by pg_dump version 9.6.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

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


--
-- Name: projects_calculate_budget(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.projects_calculate_budget() RETURNS trigger
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

CREATE FUNCTION public.set_point_from_lat_lng() RETURNS trigger
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
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
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

CREATE SEQUENCE public.admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.answers (
    id integer NOT NULL,
    question_id integer NOT NULL,
    text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
    id integer NOT NULL,
    src_title character varying,
    published_at date,
    title character varying,
    image_data jsonb,
    src_href character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    pdf_data jsonb,
    open_pdf boolean DEFAULT false
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: bank_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_accounts (
    id integer NOT NULL,
    stripe_account_id integer,
    stripe_id character varying,
    "primary" boolean DEFAULT false NOT NULL,
    country character varying,
    currency character varying,
    routing_number character varying,
    account_number character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bank_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bank_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bank_accounts_id_seq OWNED BY public.bank_accounts.id;


--
-- Name: businesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.businesses (
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
    ratings_average double precision,
    discourse_username character varying,
    discourse_user_id integer,
    fee_free boolean DEFAULT false,
    rewards_tier_id integer,
    rewards_tier_override_id integer,
    hubspot_company_id character varying,
    hubspot_contact_id character varying,
    credits_in_cents integer DEFAULT 0
);


--
-- Name: businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.businesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.businesses_id_seq OWNED BY public.businesses.id;


--
-- Name: businesses_industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.businesses_industries (
    business_id integer NOT NULL,
    industry_id integer NOT NULL
);


--
-- Name: businesses_jurisdictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.businesses_jurisdictions (
    business_id integer NOT NULL,
    jurisdiction_id integer NOT NULL
);


--
-- Name: charges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.charges (
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
    specialist_amount_in_cents integer DEFAULT 0 NOT NULL,
    referenceable_id integer,
    referenceable_type character varying,
    business_fee_in_cents integer,
    specialist_fee_in_cents integer
);


--
-- Name: charges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.charges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: charges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.charges_id_seq OWNED BY public.charges.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    owner_id integer,
    owner_type character varying,
    project_id integer NOT NULL,
    file_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    specialist_id integer
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: education_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.education_histories (
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

CREATE SEQUENCE public.education_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: education_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.education_histories_id_seq OWNED BY public.education_histories.id;


--
-- Name: email_threads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_threads (
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

CREATE SEQUENCE public.email_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_threads_id_seq OWNED BY public.email_threads.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorites (
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

CREATE SEQUENCE public.favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: feedback_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedback_requests (
    id integer NOT NULL,
    name character varying,
    email character varying,
    phone character varying,
    specialists character varying,
    budget character varying,
    description text,
    ip inet,
    user_agent character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: feedback_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedback_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedback_requests_id_seq OWNED BY public.feedback_requests.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    business_id integer NOT NULL,
    type character varying DEFAULT 'rfp'::character varying NOT NULL,
    status character varying DEFAULT 'draft'::character varying NOT NULL,
    title character varying NOT NULL,
    location_type character varying,
    location character varying,
    description character varying NOT NULL,
    key_deliverables character varying,
    starts_on date,
    ends_on date,
    pricing_type character varying DEFAULT 'hourly'::character varying,
    payment_schedule character varying,
    fixed_budget numeric,
    hourly_rate numeric,
    estimated_hours integer,
    only_regulators boolean,
    annual_salary integer,
    fee_type character varying DEFAULT 'upfront_fee'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tsv tsvector,
    calculated_budget numeric,
    lat numeric(9,5),
    lng numeric(9,5),
    point public.geography,
    specialist_id integer,
    job_applications_count integer DEFAULT 0 NOT NULL,
    published_at timestamp without time zone,
    completed_at timestamp without time zone,
    hired_at timestamp without time zone,
    extended_at timestamp without time zone,
    starts_in_48 boolean DEFAULT false,
    ends_in_24 boolean DEFAULT false,
    minimum_experience integer,
    expires_at timestamp without time zone,
    solicited_business_rating boolean DEFAULT false,
    solicited_specialist_rating boolean DEFAULT false,
    duration_type character varying DEFAULT 'custom'::character varying,
    estimated_days integer,
    rfp_timing character varying,
    est_budget numeric
);


--
-- Name: financials_actual; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.financials_actual AS
 WITH completed AS (
         SELECT projects.completed_at
           FROM public.projects
          WHERE (projects.completed_at IS NOT NULL)
        ), project_value AS (
         SELECT projects.completed_at,
            projects.type,
            charges.project_id,
            ((charges.amount_in_cents)::numeric / 100.0) AS value,
            (((charges.fee_in_cents)::numeric / 100.0) * (2)::numeric) AS revenue,
            ((charges.total_with_fee_in_cents)::numeric / 100.0) AS total
           FROM (public.charges
             JOIN public.projects ON ((projects.id = charges.project_id)))
          WHERE ((projects.type)::text = 'one_off'::text)
        ), job_value AS (
         SELECT projects.completed_at,
            projects.type,
            charges.project_id,
            projects.annual_salary AS value,
            ((charges.fee_in_cents)::numeric / 100.0) AS revenue,
            ((charges.total_with_fee_in_cents)::numeric / 100.0) AS total
           FROM (public.charges
             JOIN public.projects ON ((projects.id = charges.project_id)))
          WHERE ((projects.type)::text = 'full_time'::text)
        ), all_value AS (
         SELECT project_value.completed_at,
            project_value.type,
            project_value.project_id,
            project_value.value,
            project_value.revenue,
            project_value.total
           FROM project_value
        UNION
         SELECT job_value.completed_at,
            job_value.type,
            job_value.project_id,
            job_value.value,
            job_value.revenue,
            job_value.total
           FROM job_value
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
    ( SELECT sum(all_value.value) AS sum
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT sum(all_value.value) AS sum
           FROM all_value
          WHERE (all_value.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT sum(all_value.value) AS sum
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

CREATE VIEW public.financials_forecasted AS
 WITH active AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE ((projects.status)::text = 'published'::text)
        ), project_value AS (
         SELECT projects.created_at,
            projects.type,
            charges.project_id,
            ((charges.amount_in_cents)::double precision / (100)::double precision) AS value,
            (((charges.fee_in_cents)::numeric / 100.0) * (2)::numeric) AS revenue
           FROM (public.charges
             JOIN public.projects ON ((projects.id = charges.project_id)))
          WHERE (((projects.type)::text = 'one_off'::text) AND ((charges.status)::text <> 'processed'::text))
        ), job_value AS (
         SELECT projects.created_at,
            projects.type,
            charges.project_id,
            projects.annual_salary AS value,
            ((charges.fee_in_cents)::numeric / 100.0) AS revenue
           FROM (public.charges
             JOIN public.projects ON ((projects.id = charges.project_id)))
          WHERE (((projects.type)::text = 'full_time'::text) AND ((charges.status)::text <> 'processed'::text))
        ), all_value AS (
         SELECT projects.created_at,
            projects.type,
            charges.project_id,
            ((charges.amount_in_cents)::double precision / (100)::double precision) AS value,
            (((charges.fee_in_cents)::numeric / 100.0) * (
                CASE
                    WHEN ((projects.type)::text = 'one_off'::text) THEN 2
                    ELSE 1
                END)::numeric) AS revenue
           FROM (public.charges
             JOIN public.projects ON ((projects.id = charges.project_id)))
          WHERE ((charges.status)::text <> 'processed'::text)
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
    (((mtd.cnt)::double precision / (t_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (t_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (t_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE (((all_value.type)::text = 'full_time'::text) AND (all_value.created_at >= date_trunc('month'::text, now())))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE (((all_value.type)::text = 'full_time'::text) AND (all_value.created_at >= date_trunc('year'::text, now())))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE ((all_value.type)::text = 'full_time'::text)) itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('month'::text, now()))) t_mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('year'::text, now()))) t_fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value) t_itd
UNION
 SELECT 'forecasted_project_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (t_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (t_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (t_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE (((all_value.type)::text = 'one_off'::text) AND (all_value.created_at >= date_trunc('month'::text, now())))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE (((all_value.type)::text = 'one_off'::text) AND (all_value.created_at >= date_trunc('year'::text, now())))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE ((all_value.type)::text = 'one_off'::text)) itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('month'::text, now()))) t_mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value
          WHERE (all_value.created_at >= date_trunc('year'::text, now()))) t_fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_value) t_itd;


--
-- Name: financials; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.financials AS
 SELECT financials_actual.metric,
    financials_actual.mtd,
    financials_actual.fytd,
    financials_actual.itd
   FROM public.financials_actual
UNION
 SELECT financials_forecasted.metric,
    financials_forecasted.mtd,
    financials_forecasted.fytd,
    financials_forecasted.itd
   FROM public.financials_forecasted;


--
-- Name: financials_postings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.financials_postings AS
 WITH active AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (projects.completed_at IS NULL)
        ), all_projects AS (
         SELECT projects.created_at,
            projects.type,
            projects.pricing_type,
            projects.calculated_budget,
            projects.annual_salary,
            projects.fee_type
           FROM public.projects
        ), job_value AS (
         SELECT all_projects.calculated_budget AS value
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
            all_projects.calculated_budget AS value
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
    (((j.cnt)::double precision / (a.cnt)::double precision) * (100)::double precision) AS value
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_projects) a,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM job_revenue) j
UNION
 SELECT 'postings_project_share'::character varying AS metric,
    (((p.cnt)::double precision / (a.cnt)::double precision) * (100)::double precision) AS value
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_projects) a,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM project_revenue) p;


--
-- Name: flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flags (
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

CREATE SEQUENCE public.flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flags_id_seq OWNED BY public.flags.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industries_id_seq OWNED BY public.industries.id;


--
-- Name: industries_project_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries_project_templates (
    project_template_id integer NOT NULL,
    industry_id integer NOT NULL
);


--
-- Name: industries_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries_projects (
    industry_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: industries_specialists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries_specialists (
    industry_id integer NOT NULL,
    specialist_id integer NOT NULL
);


--
-- Name: job_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_applications (
    id integer NOT NULL,
    specialist_id integer,
    project_id integer,
    message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    visibility character varying,
    key_deliverables character varying,
    pricing_type character varying DEFAULT 'hourly'::character varying,
    payment_schedule character varying,
    fixed_budget numeric,
    hourly_rate numeric,
    estimated_hours integer,
    starts_on date,
    ends_on date,
    estimated_days integer,
    status character varying
);


--
-- Name: job_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_applications_id_seq OWNED BY public.job_applications.id;


--
-- Name: jurisdictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jurisdictions (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: jurisdictions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jurisdictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jurisdictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jurisdictions_id_seq OWNED BY public.jurisdictions.id;


--
-- Name: jurisdictions_project_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jurisdictions_project_templates (
    project_template_id integer NOT NULL,
    jurisdiction_id integer NOT NULL
);


--
-- Name: jurisdictions_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jurisdictions_projects (
    jurisdiction_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: jurisdictions_specialists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jurisdictions_specialists (
    jurisdiction_id integer NOT NULL,
    specialist_id integer NOT NULL
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
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

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: specialists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialists (
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
    point public.geography,
    ratings_count integer DEFAULT 0 NOT NULL,
    ratings_total integer DEFAULT 0 NOT NULL,
    ratings_average double precision,
    deleted boolean DEFAULT false NOT NULL,
    time_zone character varying,
    address_1 character varying,
    address_2 character varying,
    discourse_username character varying,
    discourse_user_id integer,
    specialist_team_id integer,
    rewards_tier_id integer,
    rewards_tier_override_id integer,
    hubspot_contact_id character varying,
    credits_in_cents integer DEFAULT 0
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
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
    suspended boolean DEFAULT false NOT NULL,
    suspended_at timestamp without time zone,
    tos_acceptance_date timestamp without time zone,
    tos_acceptance_ip character varying,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    inactive_for_period boolean DEFAULT false
);


--
-- Name: metrics_account_deletions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_account_deletions AS
 WITH deleted_users AS (
         SELECT users.id,
            users.deleted_at
           FROM public.users
          WHERE (users.deleted_at IS NOT NULL)
        ), deleted_businesses AS (
         SELECT deleted_users.deleted_at
           FROM (deleted_users
             JOIN public.businesses ON ((businesses.user_id = deleted_users.id)))
        ), deleted_specialists AS (
         SELECT deleted_users.deleted_at
           FROM (deleted_users
             JOIN public.specialists ON ((specialists.user_id = deleted_users.id)))
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

CREATE VIEW public.metrics_avg_staffing_times AS
 WITH one_off AS (
         SELECT projects.published_at,
            projects.hired_at
           FROM public.projects
          WHERE ((projects.type)::text = 'one_off'::text)
        ), full_time AS (
         SELECT projects.published_at,
            projects.hired_at
           FROM public.projects
          WHERE ((projects.type)::text = 'full_time'::text)
        )
 SELECT 'avg_staffing_time'::character varying AS metric,
    ( SELECT avg(date_part('days'::text, (projects.hired_at - projects.published_at))) AS avg
           FROM public.projects
          WHERE (projects.hired_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT avg(date_part('days'::text, (projects.hired_at - projects.published_at))) AS avg
           FROM public.projects
          WHERE (projects.hired_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT avg(date_part('days'::text, (projects.hired_at - projects.published_at))) AS avg
           FROM public.projects) AS itd
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
-- Name: project_issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_issues (
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

CREATE VIEW public.metrics_escalated_projects AS
 WITH escalated_projects AS (
         SELECT project_issues.created_at AS escalated_at
           FROM public.project_issues
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

CREATE VIEW public.metrics_extended_projects AS
 SELECT 'extended_projects'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM public.projects
          WHERE (projects.extended_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM public.projects
          WHERE (projects.extended_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM public.projects
          WHERE (projects.extended_at IS NOT NULL)) AS itd;


--
-- Name: metrics_job_completions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_job_completions AS
 WITH full_time AS (
         SELECT projects.completed_at,
            projects.published_at,
            projects.pricing_type,
            projects.fee_type
           FROM public.projects
          WHERE ((projects.type)::text = 'full_time'::text)
        ), all_completed AS (
         SELECT projects.completed_at,
            projects.pricing_type,
            projects.payment_schedule,
            projects.published_at
           FROM public.projects
          WHERE (projects.completed_at IS NOT NULL)
        ), published AS (
         SELECT full_time.completed_at,
            full_time.published_at,
            full_time.pricing_type,
            full_time.fee_type
           FROM full_time
          WHERE (full_time.published_at IS NOT NULL)
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
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM full_time) total,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM published
          WHERE (published.published_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM published
          WHERE (published.published_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed) itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM published) total_itd
UNION
 SELECT 'completed_jobs_all_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_completed
          WHERE (all_completed.completed_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_completed
          WHERE (all_completed.completed_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed) itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_completed) total_itd
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

CREATE VIEW public.metrics_jobs_installment_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
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

CREATE VIEW public.metrics_jobs_posted AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
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

CREATE VIEW public.metrics_jobs_share AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE ((projects.type)::text = 'full_time'::text)
        )
 SELECT 'jobs_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE (projects.created_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE (projects.created_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT count(*) AS cnt
           FROM public.projects) total_itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base) itd;


--
-- Name: metrics_jobs_upfront_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_jobs_upfront_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
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

CREATE VIEW public.metrics_jobs_value AS
 WITH base AS (
         SELECT projects.created_at,
            projects.annual_salary
           FROM public.projects
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

CREATE VIEW public.metrics_project_completions AS
 WITH one_off AS (
         SELECT projects.completed_at,
            projects.pricing_type,
            projects.payment_schedule,
            projects.published_at
           FROM public.projects
          WHERE ((projects.type)::text = 'one_off'::text)
        ), all_completed AS (
         SELECT projects.completed_at,
            projects.pricing_type,
            projects.payment_schedule,
            projects.published_at
           FROM public.projects
          WHERE (projects.completed_at IS NOT NULL)
        ), published AS (
         SELECT one_off.completed_at,
            one_off.pricing_type,
            one_off.payment_schedule,
            one_off.published_at
           FROM one_off
          WHERE (one_off.published_at IS NOT NULL)
        ), completed AS (
         SELECT one_off.completed_at,
            one_off.pricing_type,
            one_off.payment_schedule,
            one_off.published_at
           FROM one_off
          WHERE (one_off.completed_at IS NOT NULL)
        ), hourly AS (
         SELECT completed.completed_at,
            completed.pricing_type,
            completed.payment_schedule,
            completed.published_at
           FROM completed
          WHERE ((completed.pricing_type)::text = 'hourly'::text)
        ), fixed AS (
         SELECT completed.completed_at,
            completed.pricing_type,
            completed.payment_schedule,
            completed.published_at
           FROM completed
          WHERE ((completed.pricing_type)::text = 'fixed'::text)
        ), hourly_upon_completion AS (
         SELECT hourly.completed_at,
            hourly.pricing_type,
            hourly.payment_schedule,
            hourly.published_at
           FROM hourly
          WHERE ((hourly.payment_schedule)::text = 'Upon Completion'::text)
        ), hourly_bi_weekly AS (
         SELECT hourly.completed_at,
            hourly.pricing_type,
            hourly.payment_schedule,
            hourly.published_at
           FROM hourly
          WHERE ((hourly.payment_schedule)::text = 'Bi-Weekly'::text)
        ), hourly_monthly AS (
         SELECT hourly.completed_at,
            hourly.pricing_type,
            hourly.payment_schedule,
            hourly.published_at
           FROM hourly
          WHERE ((hourly.payment_schedule)::text = 'Monthly'::text)
        ), fixed_upon_completion AS (
         SELECT fixed.completed_at,
            fixed.pricing_type,
            fixed.payment_schedule,
            fixed.published_at
           FROM fixed
          WHERE ((fixed.payment_schedule)::text = 'Upon Completion'::text)
        ), fixed_bi_weekly AS (
         SELECT fixed.completed_at,
            fixed.pricing_type,
            fixed.payment_schedule,
            fixed.published_at
           FROM fixed
          WHERE ((fixed.payment_schedule)::text = 'Bi-Weekly'::text)
        ), fixed_monthly AS (
         SELECT fixed.completed_at,
            fixed.pricing_type,
            fixed.payment_schedule,
            fixed.published_at
           FROM fixed
          WHERE ((fixed.payment_schedule)::text = 'Monthly'::text)
        ), fixed_50_50 AS (
         SELECT fixed.completed_at,
            fixed.pricing_type,
            fixed.payment_schedule,
            fixed.published_at
           FROM fixed
          WHERE ((fixed.payment_schedule)::text = '50/50'::text)
        )
 SELECT 'completed_projects'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM completed) AS itd
UNION
 SELECT 'completed_projects_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM one_off) total,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM published
          WHERE (published.published_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM published
          WHERE (published.published_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed) itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM published) total_itd
UNION
 SELECT 'completed_projects_all_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_completed
          WHERE (all_completed.completed_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_completed
          WHERE (all_completed.completed_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed) itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM all_completed) total_itd
UNION
 SELECT 'completed_projects_hourly_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM hourly
          WHERE (hourly.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM hourly
          WHERE (hourly.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM hourly) itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed) total_itd
UNION
 SELECT 'completed_projects_fixed_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT NULLIF(count(*), 0) AS cnt
           FROM fixed
          WHERE (fixed.completed_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM fixed
          WHERE (fixed.completed_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed
          WHERE (completed.completed_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM fixed) itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM completed) total_itd
UNION
 SELECT 'completed_projects_hourly_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly
          WHERE (hourly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly
          WHERE (hourly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly) AS itd
UNION
 SELECT 'completed_projects_hourly_upon_completion_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_upon_completion
          WHERE (hourly_upon_completion.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_upon_completion
          WHERE (hourly_upon_completion.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_upon_completion) AS itd
UNION
 SELECT 'completed_projects_hourly_bi_weekly_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_bi_weekly
          WHERE (hourly_bi_weekly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_bi_weekly
          WHERE (hourly_bi_weekly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_bi_weekly) AS itd
UNION
 SELECT 'completed_projects_hourly_monthly_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_monthly
          WHERE (hourly_monthly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_monthly
          WHERE (hourly_monthly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM hourly_monthly) AS itd
UNION
 SELECT 'completed_projects_fixed_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed
          WHERE (fixed.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed
          WHERE (fixed.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed) AS itd
UNION
 SELECT 'completed_projects_fixed_upon_completion_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_upon_completion
          WHERE (fixed_upon_completion.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_upon_completion
          WHERE (fixed_upon_completion.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_upon_completion) AS itd
UNION
 SELECT 'completed_projects_fixed_bi_weekly_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_bi_weekly
          WHERE (fixed_bi_weekly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_bi_weekly
          WHERE (fixed_bi_weekly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_bi_weekly) AS itd
UNION
 SELECT 'completed_projects_fixed_monthly_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_monthly
          WHERE (fixed_monthly.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_monthly
          WHERE (fixed_monthly.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_monthly) AS itd
UNION
 SELECT 'completed_projects_fixed_50_50_pay'::character varying AS metric,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_50_50
          WHERE (fixed_50_50.completed_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_50_50
          WHERE (fixed_50_50.completed_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT NULLIF(count(*), 0) AS "nullif"
           FROM fixed_50_50) AS itd;


--
-- Name: metrics_projects_fixed_50_50_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_projects_fixed_50_50_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text) AND ((projects.payment_schedule)::text = '50/50'::text))
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

CREATE VIEW public.metrics_projects_fixed_bi_weekly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text) AND ((projects.payment_schedule)::text = 'Bi-Weekly'::text))
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

CREATE VIEW public.metrics_projects_fixed_monthly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text) AND ((projects.payment_schedule)::text = 'Monthly'::text))
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

CREATE VIEW public.metrics_projects_fixed_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
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

CREATE VIEW public.metrics_projects_fixed_share AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text))
        )
 SELECT 'projects_fixed_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND (projects.created_at >= date_trunc('month'::text, now())))) total_mtd,
    ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND (projects.created_at >= date_trunc('year'::text, now())))) total_fytd,
    ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE ((projects.type)::text = 'one_off'::text)) total_itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base) itd;


--
-- Name: metrics_projects_fixed_upon_completion_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_projects_fixed_upon_completion_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'fixed'::text) AND ((projects.payment_schedule)::text = 'Upon Completion'::text))
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

CREATE VIEW public.metrics_projects_hourly_bi_weekly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text) AND ((projects.payment_schedule)::text = 'Bi-Weekly'::text))
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

CREATE VIEW public.metrics_projects_hourly_monthly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text) AND ((projects.payment_schedule)::text = 'Monthly'::text))
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

CREATE VIEW public.metrics_projects_hourly_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
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

CREATE VIEW public.metrics_projects_hourly_share AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text))
        )
 SELECT 'projects_hourly_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND (projects.created_at >= date_trunc('month'::text, now())))) total_mtd,
    ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND (projects.created_at >= date_trunc('year'::text, now())))) total_fytd,
    ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE ((projects.type)::text = 'one_off'::text)) total_itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base) itd;


--
-- Name: metrics_projects_hourly_upon_completion_pay; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_projects_hourly_upon_completion_pay AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.pricing_type)::text = 'hourly'::text) AND ((projects.payment_schedule)::text = 'Upon Completion'::text))
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

CREATE VIEW public.metrics_projects_posted AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
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

CREATE VIEW public.metrics_projects_share AS
 WITH base AS (
         SELECT projects.created_at
           FROM public.projects
          WHERE ((projects.type)::text = 'one_off'::text)
        )
 SELECT 'projects_share'::character varying AS metric,
    (((mtd.cnt)::double precision / (total_mtd.cnt)::double precision) * (100)::double precision) AS mtd,
    (((fytd.cnt)::double precision / (total_fytd.cnt)::double precision) * (100)::double precision) AS fytd,
    (((itd.cnt)::double precision / (total_itd.cnt)::double precision) * (100)::double precision) AS itd
   FROM ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE (projects.created_at >= date_trunc('month'::text, now()))) total_mtd,
    ( SELECT count(*) AS cnt
           FROM public.projects
          WHERE (projects.created_at >= date_trunc('year'::text, now()))) total_fytd,
    ( SELECT count(*) AS cnt
           FROM public.projects) total_itd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('month'::text, now()))) mtd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base
          WHERE (base.created_at >= date_trunc('year'::text, now()))) fytd,
    ( SELECT NULLIF(count(*), 0) AS cnt
           FROM base) itd;


--
-- Name: metrics_projects_value; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_projects_value AS
 WITH base AS (
         SELECT projects.created_at,
            projects.fixed_budget,
            projects.hourly_rate,
            projects.estimated_hours
           FROM public.projects
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

CREATE VIEW public.metrics_signups AS
 SELECT 'all_signups'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM public.users
          WHERE (users.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM public.users
          WHERE (users.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM public.users) AS itd
UNION
 SELECT 'business_signups'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM public.businesses
          WHERE (businesses.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM public.businesses
          WHERE (businesses.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM public.businesses) AS itd
UNION
 SELECT 'specialist_signups'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM public.specialists
          WHERE (specialists.created_at >= date_trunc('month'::text, now()))) AS mtd,
    ( SELECT count(*) AS count
           FROM public.specialists
          WHERE (specialists.created_at >= date_trunc('year'::text, now()))) AS fytd,
    ( SELECT count(*) AS count
           FROM public.specialists) AS itd;


--
-- Name: metrics_time_to_completion; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_time_to_completion AS
 WITH one_off AS (
         SELECT projects.hired_at,
            projects.completed_at
           FROM public.projects
          WHERE (((projects.type)::text = 'one_off'::text) AND ((projects.status)::text = 'complete'::text))
        ), full_time AS (
         SELECT projects.hired_at,
            projects.completed_at
           FROM public.projects
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

CREATE VIEW public.metrics AS
 SELECT metrics_projects_posted.metric,
    metrics_projects_posted.mtd,
    metrics_projects_posted.fytd,
    metrics_projects_posted.itd
   FROM public.metrics_projects_posted
UNION
 SELECT metrics_projects_value.metric,
    metrics_projects_value.mtd,
    metrics_projects_value.fytd,
    metrics_projects_value.itd
   FROM public.metrics_projects_value
UNION
 SELECT metrics_projects_share.metric,
    metrics_projects_share.mtd,
    metrics_projects_share.fytd,
    metrics_projects_share.itd
   FROM public.metrics_projects_share
UNION
 SELECT metrics_projects_hourly_share.metric,
    metrics_projects_hourly_share.mtd,
    metrics_projects_hourly_share.fytd,
    metrics_projects_hourly_share.itd
   FROM public.metrics_projects_hourly_share
UNION
 SELECT metrics_projects_fixed_share.metric,
    metrics_projects_fixed_share.mtd,
    metrics_projects_fixed_share.fytd,
    metrics_projects_fixed_share.itd
   FROM public.metrics_projects_fixed_share
UNION
 SELECT metrics_projects_hourly_pay.metric,
    metrics_projects_hourly_pay.mtd,
    metrics_projects_hourly_pay.fytd,
    metrics_projects_hourly_pay.itd
   FROM public.metrics_projects_hourly_pay
UNION
 SELECT metrics_projects_hourly_upon_completion_pay.metric,
    metrics_projects_hourly_upon_completion_pay.mtd,
    metrics_projects_hourly_upon_completion_pay.fytd,
    metrics_projects_hourly_upon_completion_pay.itd
   FROM public.metrics_projects_hourly_upon_completion_pay
UNION
 SELECT metrics_projects_hourly_bi_weekly_pay.metric,
    metrics_projects_hourly_bi_weekly_pay.mtd,
    metrics_projects_hourly_bi_weekly_pay.fytd,
    metrics_projects_hourly_bi_weekly_pay.itd
   FROM public.metrics_projects_hourly_bi_weekly_pay
UNION
 SELECT metrics_projects_hourly_monthly_pay.metric,
    metrics_projects_hourly_monthly_pay.mtd,
    metrics_projects_hourly_monthly_pay.fytd,
    metrics_projects_hourly_monthly_pay.itd
   FROM public.metrics_projects_hourly_monthly_pay
UNION
 SELECT metrics_projects_fixed_pay.metric,
    metrics_projects_fixed_pay.mtd,
    metrics_projects_fixed_pay.fytd,
    metrics_projects_fixed_pay.itd
   FROM public.metrics_projects_fixed_pay
UNION
 SELECT metrics_projects_fixed_50_50_pay.metric,
    metrics_projects_fixed_50_50_pay.mtd,
    metrics_projects_fixed_50_50_pay.fytd,
    metrics_projects_fixed_50_50_pay.itd
   FROM public.metrics_projects_fixed_50_50_pay
UNION
 SELECT metrics_projects_fixed_upon_completion_pay.metric,
    metrics_projects_fixed_upon_completion_pay.mtd,
    metrics_projects_fixed_upon_completion_pay.fytd,
    metrics_projects_fixed_upon_completion_pay.itd
   FROM public.metrics_projects_fixed_upon_completion_pay
UNION
 SELECT metrics_projects_fixed_bi_weekly_pay.metric,
    metrics_projects_fixed_bi_weekly_pay.mtd,
    metrics_projects_fixed_bi_weekly_pay.fytd,
    metrics_projects_fixed_bi_weekly_pay.itd
   FROM public.metrics_projects_fixed_bi_weekly_pay
UNION
 SELECT metrics_projects_fixed_monthly_pay.metric,
    metrics_projects_fixed_monthly_pay.mtd,
    metrics_projects_fixed_monthly_pay.fytd,
    metrics_projects_fixed_monthly_pay.itd
   FROM public.metrics_projects_fixed_monthly_pay
UNION
 SELECT metrics_jobs_posted.metric,
    metrics_jobs_posted.mtd,
    metrics_jobs_posted.fytd,
    metrics_jobs_posted.itd
   FROM public.metrics_jobs_posted
UNION
 SELECT metrics_jobs_value.metric,
    metrics_jobs_value.mtd,
    metrics_jobs_value.fytd,
    metrics_jobs_value.itd
   FROM public.metrics_jobs_value
UNION
 SELECT metrics_jobs_share.metric,
    metrics_jobs_share.mtd,
    metrics_jobs_share.fytd,
    metrics_jobs_share.itd
   FROM public.metrics_jobs_share
UNION
 SELECT metrics_jobs_upfront_pay.metric,
    metrics_jobs_upfront_pay.mtd,
    metrics_jobs_upfront_pay.fytd,
    metrics_jobs_upfront_pay.itd
   FROM public.metrics_jobs_upfront_pay
UNION
 SELECT metrics_jobs_installment_pay.metric,
    metrics_jobs_installment_pay.mtd,
    metrics_jobs_installment_pay.fytd,
    metrics_jobs_installment_pay.itd
   FROM public.metrics_jobs_installment_pay
UNION
 SELECT metrics_project_completions.metric,
    metrics_project_completions.mtd,
    metrics_project_completions.fytd,
    metrics_project_completions.itd
   FROM public.metrics_project_completions
UNION
 SELECT metrics_job_completions.metric,
    metrics_job_completions.mtd,
    metrics_job_completions.fytd,
    metrics_job_completions.itd
   FROM public.metrics_job_completions
UNION
 SELECT metrics_time_to_completion.metric,
    metrics_time_to_completion.mtd,
    metrics_time_to_completion.fytd,
    metrics_time_to_completion.itd
   FROM public.metrics_time_to_completion
UNION
 SELECT metrics_avg_staffing_times.metric,
    metrics_avg_staffing_times.mtd,
    metrics_avg_staffing_times.fytd,
    metrics_avg_staffing_times.itd
   FROM public.metrics_avg_staffing_times
UNION
 SELECT metrics_escalated_projects.metric,
    metrics_escalated_projects.mtd,
    metrics_escalated_projects.fytd,
    metrics_escalated_projects.itd
   FROM public.metrics_escalated_projects
UNION
 SELECT metrics_extended_projects.metric,
    metrics_extended_projects.mtd,
    metrics_extended_projects.fytd,
    metrics_extended_projects.itd
   FROM public.metrics_extended_projects
UNION
 SELECT metrics_account_deletions.metric,
    metrics_account_deletions.mtd,
    metrics_account_deletions.fytd,
    metrics_account_deletions.itd
   FROM public.metrics_account_deletions
UNION
 SELECT metrics_signups.metric,
    metrics_signups.mtd,
    metrics_signups.fytd,
    metrics_signups.itd
   FROM public.metrics_signups;


--
-- Name: metrics_activity; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.metrics_activity AS
 WITH dates AS (
         SELECT (now() - '30 days'::interval) AS thirty_days_ago
        ), totals AS (
         SELECT count(*) AS cnt
           FROM public.users
        ), all_users AS (
         SELECT users.current_sign_in_at
           FROM public.users
        ), businesses_count AS (
         SELECT users.current_sign_in_at
           FROM (public.users
             JOIN public.businesses ON ((businesses.user_id = users.id)))
        ), specialists_count AS (
         SELECT users.current_sign_in_at
           FROM (public.users
             JOIN public.specialists ON ((specialists.user_id = users.id)))
        )
 SELECT 'recent_activity'::character varying AS metric,
    ( SELECT count(*) AS count
           FROM public.users
          WHERE (users.current_sign_in_at >= dates.thirty_days_ago)) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM public.users
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
           FROM public.users
          WHERE ((users.current_sign_in_at IS NULL) OR (users.current_sign_in_at < dates.thirty_days_ago))) AS cnt,
    ( SELECT (((count(*))::double precision / (totals.cnt)::double precision) * (100)::double precision)
           FROM public.users
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
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer,
    message character varying,
    action_path character varying,
    read_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    key character varying,
    associated_id integer,
    associated_type character varying,
    clear_manually boolean DEFAULT false NOT NULL,
    initiator character varying,
    img_path character varying
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: partnerships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.partnerships (
    id integer NOT NULL,
    company character varying,
    description text,
    discount character varying,
    discount_pub character varying,
    href character varying,
    logo_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category character varying
);


--
-- Name: partnerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.partnerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: partnerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.partnerships_id_seq OWNED BY public.partnerships.id;


--
-- Name: payment_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_profiles (
    id integer NOT NULL,
    business_id integer,
    stripe_customer_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payment_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_profiles_id_seq OWNED BY public.payment_profiles.id;


--
-- Name: payment_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_sources (
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

CREATE SEQUENCE public.payment_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_sources_id_seq OWNED BY public.payment_sources.id;


--
-- Name: project_ends; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_ends (
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

CREATE SEQUENCE public.project_ends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_ends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_ends_id_seq OWNED BY public.project_ends.id;


--
-- Name: project_extensions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_extensions (
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

CREATE SEQUENCE public.project_extensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_extensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_extensions_id_seq OWNED BY public.project_extensions.id;


--
-- Name: project_invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_invites (
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

CREATE SEQUENCE public.project_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_invites_id_seq OWNED BY public.project_invites.id;


--
-- Name: project_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_issues_id_seq OWNED BY public.project_issues.id;


--
-- Name: project_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_templates (
    id integer NOT NULL,
    title character varying,
    project_type character varying,
    location_type character varying,
    description character varying,
    payment_schedule character varying,
    fixed_budget numeric,
    hourly_rate numeric,
    estimated_hours integer,
    only_regulators boolean,
    annual_salary integer,
    fee_type character varying,
    minimum_experience integer,
    duration_type character varying,
    estimated_days integer,
    turnkey_solution_id integer,
    flavor character varying,
    key_deliverables character varying,
    pricing_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title_aum character varying,
    description_aum character varying,
    public_description text,
    public_features text
);


--
-- Name: project_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_templates_id_seq OWNED BY public.project_templates.id;


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: projects_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_skills (
    project_id integer NOT NULL,
    skill_id integer NOT NULL
);


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
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

CREATE SEQUENCE public.questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ratings (
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

CREATE SEQUENCE public.ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ratings_id_seq OWNED BY public.ratings.id;


--
-- Name: referral_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.referral_tokens (
    id integer NOT NULL,
    referrals_count integer DEFAULT 0 NOT NULL,
    amount_in_cents integer NOT NULL,
    token character varying NOT NULL,
    referrer_id integer NOT NULL,
    referrer_type character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: referral_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.referral_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: referral_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.referral_tokens_id_seq OWNED BY public.referral_tokens.id;


--
-- Name: referrals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.referrals (
    id integer NOT NULL,
    referral_token_id integer NOT NULL,
    referrable_id integer NOT NULL,
    referrable_type character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: referrals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.referrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: referrals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.referrals_id_seq OWNED BY public.referrals.id;


--
-- Name: rewards_tiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rewards_tiers (
    id integer NOT NULL,
    name character varying NOT NULL,
    fee_percentage numeric(2,2) NOT NULL,
    amount int4range NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rewards_tiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rewards_tiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rewards_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rewards_tiers_id_seq OWNED BY public.rewards_tiers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
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

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skills (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- Name: skills_specialists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skills_specialists (
    skill_id integer NOT NULL,
    specialist_id integer NOT NULL
);


--
-- Name: specialist_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialist_invitations (
    id integer NOT NULL,
    specialist_team_id integer NOT NULL,
    specialist_id integer,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    token character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


--
-- Name: specialist_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.specialist_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: specialist_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.specialist_invitations_id_seq OWNED BY public.specialist_invitations.id;


--
-- Name: specialist_teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialist_teams (
    id integer NOT NULL,
    manager_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: specialist_teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.specialist_teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: specialist_teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.specialist_teams_id_seq OWNED BY public.specialist_teams.id;


--
-- Name: specialists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.specialists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: specialists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.specialists_id_seq OWNED BY public.specialists.id;


--
-- Name: stripe_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_accounts (
    id integer NOT NULL,
    specialist_id integer,
    status character varying DEFAULT 'Pending'::character varying NOT NULL,
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
    verification_document text,
    secret_key character varying,
    publishable_key character varying
);


--
-- Name: stripe_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stripe_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stripe_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stripe_accounts_id_seq OWNED BY public.stripe_accounts.id;


--
-- Name: time_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.time_logs (
    id integer NOT NULL,
    timesheet_id integer,
    description character varying,
    hours numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hourly_rate numeric,
    total_amount numeric,
    date date
);


--
-- Name: time_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.time_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.time_logs_id_seq OWNED BY public.time_logs.id;


--
-- Name: timesheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timesheets (
    id integer NOT NULL,
    project_id integer,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_changed_at timestamp without time zone,
    first_submitted_at timestamp without time zone,
    expires_at timestamp without time zone,
    last_submitted_at timestamp without time zone
);


--
-- Name: timesheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timesheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timesheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timesheets_id_seq OWNED BY public.timesheets.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    stripe_id character varying,
    type character varying,
    amount_in_cents integer,
    processed_at timestamp without time zone,
    status character varying DEFAULT 'pending'::character varying,
    charge_source_id integer,
    payment_target_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    project_id integer,
    parent_transaction_id integer,
    status_detail character varying,
    fee_in_cents integer DEFAULT 0 NOT NULL,
    date timestamp without time zone,
    last_try_at timestamp without time zone,
    description text,
    business_credit_in_cents integer DEFAULT 0,
    specialist_credit_in_cents integer DEFAULT 0
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: turnkey_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.turnkey_pages (
    id integer NOT NULL,
    title character varying,
    url character varying,
    description text,
    cost character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    header_text character varying
);


--
-- Name: turnkey_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.turnkey_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: turnkey_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.turnkey_pages_id_seq OWNED BY public.turnkey_pages.id;


--
-- Name: turnkey_solutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.turnkey_solutions (
    id integer NOT NULL,
    title character varying,
    turnkey_page_id integer,
    range character varying,
    aum_enabled boolean,
    principal_office boolean,
    industries_enabled boolean,
    jurisdictions_enabled boolean,
    hours_enabled boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    info_dot character varying,
    accounts_enabled boolean DEFAULT false
);


--
-- Name: turnkey_solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.turnkey_solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: turnkey_solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.turnkey_solutions_id_seq OWNED BY public.turnkey_solutions.id;


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
-- Name: work_experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_experiences (
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

CREATE SEQUENCE public.work_experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.work_experiences_id_seq OWNED BY public.work_experiences.id;


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: bank_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts ALTER COLUMN id SET DEFAULT nextval('public.bank_accounts_id_seq'::regclass);


--
-- Name: businesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.businesses ALTER COLUMN id SET DEFAULT nextval('public.businesses_id_seq'::regclass);


--
-- Name: charges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charges ALTER COLUMN id SET DEFAULT nextval('public.charges_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: education_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_histories ALTER COLUMN id SET DEFAULT nextval('public.education_histories_id_seq'::regclass);


--
-- Name: email_threads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_threads ALTER COLUMN id SET DEFAULT nextval('public.email_threads_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: feedback_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_requests ALTER COLUMN id SET DEFAULT nextval('public.feedback_requests_id_seq'::regclass);


--
-- Name: flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags ALTER COLUMN id SET DEFAULT nextval('public.flags_id_seq'::regclass);


--
-- Name: industries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries ALTER COLUMN id SET DEFAULT nextval('public.industries_id_seq'::regclass);


--
-- Name: job_applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications ALTER COLUMN id SET DEFAULT nextval('public.job_applications_id_seq'::regclass);


--
-- Name: jurisdictions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jurisdictions ALTER COLUMN id SET DEFAULT nextval('public.jurisdictions_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: partnerships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partnerships ALTER COLUMN id SET DEFAULT nextval('public.partnerships_id_seq'::regclass);


--
-- Name: payment_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_profiles ALTER COLUMN id SET DEFAULT nextval('public.payment_profiles_id_seq'::regclass);


--
-- Name: payment_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_sources ALTER COLUMN id SET DEFAULT nextval('public.payment_sources_id_seq'::regclass);


--
-- Name: project_ends id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_ends ALTER COLUMN id SET DEFAULT nextval('public.project_ends_id_seq'::regclass);


--
-- Name: project_extensions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_extensions ALTER COLUMN id SET DEFAULT nextval('public.project_extensions_id_seq'::regclass);


--
-- Name: project_invites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_invites ALTER COLUMN id SET DEFAULT nextval('public.project_invites_id_seq'::regclass);


--
-- Name: project_issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_issues ALTER COLUMN id SET DEFAULT nextval('public.project_issues_id_seq'::regclass);


--
-- Name: project_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_templates ALTER COLUMN id SET DEFAULT nextval('public.project_templates_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: ratings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings ALTER COLUMN id SET DEFAULT nextval('public.ratings_id_seq'::regclass);


--
-- Name: referral_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referral_tokens ALTER COLUMN id SET DEFAULT nextval('public.referral_tokens_id_seq'::regclass);


--
-- Name: referrals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrals ALTER COLUMN id SET DEFAULT nextval('public.referrals_id_seq'::regclass);


--
-- Name: rewards_tiers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rewards_tiers ALTER COLUMN id SET DEFAULT nextval('public.rewards_tiers_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- Name: specialist_invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_invitations ALTER COLUMN id SET DEFAULT nextval('public.specialist_invitations_id_seq'::regclass);


--
-- Name: specialist_teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_teams ALTER COLUMN id SET DEFAULT nextval('public.specialist_teams_id_seq'::regclass);


--
-- Name: specialists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialists ALTER COLUMN id SET DEFAULT nextval('public.specialists_id_seq'::regclass);


--
-- Name: stripe_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_accounts ALTER COLUMN id SET DEFAULT nextval('public.stripe_accounts_id_seq'::regclass);


--
-- Name: time_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs ALTER COLUMN id SET DEFAULT nextval('public.time_logs_id_seq'::regclass);


--
-- Name: timesheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets ALTER COLUMN id SET DEFAULT nextval('public.timesheets_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: turnkey_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turnkey_pages ALTER COLUMN id SET DEFAULT nextval('public.turnkey_pages_id_seq'::regclass);


--
-- Name: turnkey_solutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turnkey_solutions ALTER COLUMN id SET DEFAULT nextval('public.turnkey_solutions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: work_experiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_experiences ALTER COLUMN id SET DEFAULT nextval('public.work_experiences_id_seq'::regclass);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: bank_accounts bank_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts
    ADD CONSTRAINT bank_accounts_pkey PRIMARY KEY (id);


--
-- Name: businesses businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: charges charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charges
    ADD CONSTRAINT charges_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: education_histories education_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_histories
    ADD CONSTRAINT education_histories_pkey PRIMARY KEY (id);


--
-- Name: email_threads email_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_threads
    ADD CONSTRAINT email_threads_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: feedback_requests feedback_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_requests
    ADD CONSTRAINT feedback_requests_pkey PRIMARY KEY (id);


--
-- Name: flags flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


--
-- Name: industries industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: job_applications job_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_pkey PRIMARY KEY (id);


--
-- Name: jurisdictions jurisdictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jurisdictions
    ADD CONSTRAINT jurisdictions_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: partnerships partnerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partnerships
    ADD CONSTRAINT partnerships_pkey PRIMARY KEY (id);


--
-- Name: payment_profiles payment_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_profiles
    ADD CONSTRAINT payment_profiles_pkey PRIMARY KEY (id);


--
-- Name: payment_sources payment_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_sources
    ADD CONSTRAINT payment_sources_pkey PRIMARY KEY (id);


--
-- Name: project_ends project_ends_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_ends
    ADD CONSTRAINT project_ends_pkey PRIMARY KEY (id);


--
-- Name: project_extensions project_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_extensions
    ADD CONSTRAINT project_extensions_pkey PRIMARY KEY (id);


--
-- Name: project_invites project_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_invites
    ADD CONSTRAINT project_invites_pkey PRIMARY KEY (id);


--
-- Name: project_issues project_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_issues
    ADD CONSTRAINT project_issues_pkey PRIMARY KEY (id);


--
-- Name: project_templates project_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_templates
    ADD CONSTRAINT project_templates_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: ratings ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: referral_tokens referral_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referral_tokens
    ADD CONSTRAINT referral_tokens_pkey PRIMARY KEY (id);


--
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- Name: rewards_tiers rewards_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rewards_tiers
    ADD CONSTRAINT rewards_tiers_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: specialist_invitations specialist_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_invitations
    ADD CONSTRAINT specialist_invitations_pkey PRIMARY KEY (id);


--
-- Name: specialist_teams specialist_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_teams
    ADD CONSTRAINT specialist_teams_pkey PRIMARY KEY (id);


--
-- Name: specialists specialists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialists
    ADD CONSTRAINT specialists_pkey PRIMARY KEY (id);


--
-- Name: stripe_accounts stripe_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_accounts
    ADD CONSTRAINT stripe_accounts_pkey PRIMARY KEY (id);


--
-- Name: time_logs time_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT time_logs_pkey PRIMARY KEY (id);


--
-- Name: timesheets timesheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets
    ADD CONSTRAINT timesheets_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: turnkey_pages turnkey_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turnkey_pages
    ADD CONSTRAINT turnkey_pages_pkey PRIMARY KEY (id);


--
-- Name: turnkey_solutions turnkey_solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turnkey_solutions
    ADD CONSTRAINT turnkey_solutions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: work_experiences work_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_experiences
    ADD CONSTRAINT work_experiences_pkey PRIMARY KEY (id);


--
-- Name: favorites_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX favorites_unique ON public.favorites USING btree (owner_id, owner_type, favorited_id, favorited_type);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_question_id ON public.answers USING btree (question_id);


--
-- Name: index_bank_accounts_on_stripe_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bank_accounts_on_stripe_account_id ON public.bank_accounts USING btree (stripe_account_id);


--
-- Name: index_businesses_industries_on_business_id_and_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_businesses_industries_on_business_id_and_industry_id ON public.businesses_industries USING btree (business_id, industry_id);


--
-- Name: index_businesses_on_anonymous; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_anonymous ON public.businesses USING btree (anonymous);


--
-- Name: index_businesses_on_discourse_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_discourse_username ON public.businesses USING btree (discourse_username);


--
-- Name: index_businesses_on_ratings_average; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_ratings_average ON public.businesses USING btree (ratings_average);


--
-- Name: index_businesses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_user_id ON public.businesses USING btree (user_id);


--
-- Name: index_charges_on_process_after; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_charges_on_process_after ON public.charges USING btree (process_after);


--
-- Name: index_charges_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_charges_on_project_id ON public.charges USING btree (project_id);


--
-- Name: index_charges_on_referenceable_type_and_referenceable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_charges_on_referenceable_type_and_referenceable_id ON public.charges USING btree (referenceable_type, referenceable_id);


--
-- Name: index_charges_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_charges_on_status ON public.charges USING btree (status);


--
-- Name: index_charges_on_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_charges_on_transaction_id ON public.charges USING btree (transaction_id);


--
-- Name: index_documents_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_owner_type_and_owner_id ON public.documents USING btree (owner_type, owner_id);


--
-- Name: index_documents_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_project_id ON public.documents USING btree (project_id);


--
-- Name: index_education_histories_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_education_histories_on_specialist_id ON public.education_histories USING btree (specialist_id);


--
-- Name: index_email_threads_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_threads_on_business_id ON public.email_threads USING btree (business_id);


--
-- Name: index_email_threads_on_business_id_and_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_email_threads_on_business_id_and_specialist_id ON public.email_threads USING btree (business_id, specialist_id);


--
-- Name: index_email_threads_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_threads_on_specialist_id ON public.email_threads USING btree (specialist_id);


--
-- Name: index_email_threads_on_thread_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_email_threads_on_thread_key ON public.email_threads USING btree (thread_key);


--
-- Name: index_favorites_on_favorited_type_and_favorited_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorites_on_favorited_type_and_favorited_id ON public.favorites USING btree (favorited_type, favorited_id);


--
-- Name: index_favorites_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorites_on_owner_type_and_owner_id ON public.favorites USING btree (owner_type, owner_id);


--
-- Name: index_flags_on_flagged_content_type_and_flagged_content_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flags_on_flagged_content_type_and_flagged_content_id ON public.flags USING btree (flagged_content_type, flagged_content_id);


--
-- Name: index_flags_on_flagger_type_and_flagger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flags_on_flagger_type_and_flagger_id ON public.flags USING btree (flagger_type, flagger_id);


--
-- Name: index_industries_projects_on_industry_id_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_industries_projects_on_industry_id_and_project_id ON public.industries_projects USING btree (industry_id, project_id);


--
-- Name: index_job_applications_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_applications_on_project_id ON public.job_applications USING btree (project_id);


--
-- Name: index_job_applications_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_applications_on_specialist_id ON public.job_applications USING btree (specialist_id);


--
-- Name: index_job_applications_on_specialist_id_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_job_applications_on_specialist_id_and_project_id ON public.job_applications USING btree (specialist_id, project_id);


--
-- Name: index_jurisdictions_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_jurisdictions_on_name ON public.jurisdictions USING btree (name);


--
-- Name: index_jurisdictions_projects_on_jurisdiction_id_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_jurisdictions_projects_on_jurisdiction_id_and_project_id ON public.jurisdictions_projects USING btree (jurisdiction_id, project_id);


--
-- Name: index_messages_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_recipient_type_and_recipient_id ON public.messages USING btree (recipient_type, recipient_id);


--
-- Name: index_messages_on_sender_type_and_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_sender_type_and_sender_id ON public.messages USING btree (sender_type, sender_id);


--
-- Name: index_messages_on_thread_type_and_thread_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_thread_type_and_thread_id ON public.messages USING btree (thread_type, thread_id);


--
-- Name: index_notifications_on_action_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_action_path ON public.notifications USING btree (action_path);


--
-- Name: index_notifications_on_associated_type_and_associated_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_associated_type_and_associated_id ON public.notifications USING btree (associated_type, associated_id);


--
-- Name: index_notifications_on_clear_manually; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_clear_manually ON public.notifications USING btree (clear_manually);


--
-- Name: index_notifications_on_read_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_read_at ON public.notifications USING btree (read_at);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_user_id ON public.notifications USING btree (user_id);


--
-- Name: index_payment_profiles_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_profiles_on_business_id ON public.payment_profiles USING btree (business_id);


--
-- Name: index_payment_sources_on_payment_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_sources_on_payment_profile_id ON public.payment_sources USING btree (payment_profile_id);


--
-- Name: index_payment_sources_on_stripe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_payment_sources_on_stripe_id ON public.payment_sources USING btree (stripe_id);


--
-- Name: index_payment_sources_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_sources_on_type ON public.payment_sources USING btree (type);


--
-- Name: index_project_ends_on_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_ends_on_expires_at ON public.project_ends USING btree (expires_at);


--
-- Name: index_project_ends_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_ends_on_project_id ON public.project_ends USING btree (project_id);


--
-- Name: index_project_ends_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_ends_on_status ON public.project_ends USING btree (status);


--
-- Name: index_project_extensions_on_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_extensions_on_expires_at ON public.project_extensions USING btree (expires_at);


--
-- Name: index_project_extensions_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_extensions_on_project_id ON public.project_extensions USING btree (project_id);


--
-- Name: index_project_extensions_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_extensions_on_status ON public.project_extensions USING btree (status);


--
-- Name: index_project_invites_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_invites_on_business_id ON public.project_invites USING btree (business_id);


--
-- Name: index_project_invites_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_invites_on_project_id ON public.project_invites USING btree (project_id);


--
-- Name: index_project_invites_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_invites_on_specialist_id ON public.project_invites USING btree (specialist_id);


--
-- Name: index_project_invites_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_invites_on_status ON public.project_invites USING btree (status);


--
-- Name: index_project_issues_on_admin_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_issues_on_admin_user_id ON public.project_issues USING btree (admin_user_id);


--
-- Name: index_project_issues_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_issues_on_project_id ON public.project_issues USING btree (project_id);


--
-- Name: index_project_issues_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_issues_on_status ON public.project_issues USING btree (status);


--
-- Name: index_project_issues_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_issues_on_user_id ON public.project_issues USING btree (user_id);


--
-- Name: index_projects_on_annual_salary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_annual_salary ON public.projects USING btree (annual_salary);


--
-- Name: index_projects_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_business_id ON public.projects USING btree (business_id);


--
-- Name: index_projects_on_calculated_budget; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_calculated_budget ON public.projects USING btree (calculated_budget);


--
-- Name: index_projects_on_completed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_completed_at ON public.projects USING btree (completed_at);


--
-- Name: index_projects_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_created_at ON public.projects USING btree (created_at);


--
-- Name: index_projects_on_estimated_hours; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_estimated_hours ON public.projects USING btree (estimated_hours);


--
-- Name: index_projects_on_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_expires_at ON public.projects USING btree (expires_at);


--
-- Name: index_projects_on_extended_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_extended_at ON public.projects USING btree (extended_at);


--
-- Name: index_projects_on_fee_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_fee_type ON public.projects USING btree (fee_type);


--
-- Name: index_projects_on_fixed_budget; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_fixed_budget ON public.projects USING btree (fixed_budget);


--
-- Name: index_projects_on_hired_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_hired_at ON public.projects USING btree (hired_at);


--
-- Name: index_projects_on_hourly_rate; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_hourly_rate ON public.projects USING btree (hourly_rate);


--
-- Name: index_projects_on_minimum_experience; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_minimum_experience ON public.projects USING btree (minimum_experience);


--
-- Name: index_projects_on_only_regulators; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_only_regulators ON public.projects USING btree (only_regulators);


--
-- Name: index_projects_on_payment_schedule; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_payment_schedule ON public.projects USING btree (payment_schedule);


--
-- Name: index_projects_on_point; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_point ON public.projects USING gist (point);


--
-- Name: index_projects_on_pricing_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_pricing_type ON public.projects USING btree (pricing_type);


--
-- Name: index_projects_on_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_published_at ON public.projects USING btree (published_at);


--
-- Name: index_projects_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_specialist_id ON public.projects USING btree (specialist_id);


--
-- Name: index_projects_on_starts_on; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_starts_on ON public.projects USING btree (starts_on);


--
-- Name: index_projects_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_status ON public.projects USING btree (status);


--
-- Name: index_projects_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_tsv ON public.projects USING gin (tsv);


--
-- Name: index_projects_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_type ON public.projects USING btree (type);


--
-- Name: index_projects_skills_on_project_id_and_skill_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_projects_skills_on_project_id_and_skill_id ON public.projects_skills USING btree (project_id, skill_id);


--
-- Name: index_questions_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_project_id ON public.questions USING btree (project_id);


--
-- Name: index_ratings_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ratings_on_project_id ON public.ratings USING btree (project_id);


--
-- Name: index_ratings_on_rater_type_and_rater_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ratings_on_rater_type_and_rater_id ON public.ratings USING btree (rater_type, rater_id);


--
-- Name: index_referral_tokens_on_referrer_id_and_referrer_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_referral_tokens_on_referrer_id_and_referrer_type ON public.referral_tokens USING btree (referrer_id, referrer_type);


--
-- Name: index_referral_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_referral_tokens_on_token ON public.referral_tokens USING btree (token);


--
-- Name: index_referrals_on_referrable_id_and_referrable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_referrals_on_referrable_id_and_referrable_type ON public.referrals USING btree (referrable_id, referrable_type);


--
-- Name: index_settings_on_target_type_and_target_id_and_var; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_settings_on_target_type_and_target_id_and_var ON public.settings USING btree (target_type, target_id, var);


--
-- Name: index_skills_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_skills_on_name ON public.skills USING btree (name);


--
-- Name: index_skills_specialists_on_skill_id_and_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_skills_specialists_on_skill_id_and_specialist_id ON public.skills_specialists USING btree (skill_id, specialist_id);


--
-- Name: index_specialist_invitations_on_specialist_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialist_invitations_on_specialist_team_id ON public.specialist_invitations USING btree (specialist_team_id);


--
-- Name: index_specialist_invitations_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialist_invitations_on_token ON public.specialist_invitations USING btree (token);


--
-- Name: index_specialist_teams_on_manager_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialist_teams_on_manager_id ON public.specialist_teams USING btree (manager_id);


--
-- Name: index_specialists_on_discourse_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialists_on_discourse_username ON public.specialists USING btree (discourse_username);


--
-- Name: index_specialists_on_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialists_on_first_name ON public.specialists USING btree (first_name);


--
-- Name: index_specialists_on_former_regulator; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialists_on_former_regulator ON public.specialists USING btree (former_regulator);


--
-- Name: index_specialists_on_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialists_on_last_name ON public.specialists USING btree (last_name);


--
-- Name: index_specialists_on_point; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialists_on_point ON public.specialists USING gist (point);


--
-- Name: index_specialists_on_ratings_average; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialists_on_ratings_average ON public.specialists USING btree (ratings_average);


--
-- Name: index_specialists_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialists_on_user_id ON public.specialists USING btree (user_id);


--
-- Name: index_stripe_accounts_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stripe_accounts_on_specialist_id ON public.stripe_accounts USING btree (specialist_id);


--
-- Name: index_stripe_accounts_on_stripe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stripe_accounts_on_stripe_id ON public.stripe_accounts USING btree (stripe_id);


--
-- Name: index_time_logs_on_timesheet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_time_logs_on_timesheet_id ON public.time_logs USING btree (timesheet_id);


--
-- Name: index_timesheets_on_first_submitted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timesheets_on_first_submitted_at ON public.timesheets USING btree (first_submitted_at);


--
-- Name: index_timesheets_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timesheets_on_project_id ON public.timesheets USING btree (project_id);


--
-- Name: index_timesheets_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timesheets_on_status ON public.timesheets USING btree (status);


--
-- Name: index_timesheets_on_status_changed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timesheets_on_status_changed_at ON public.timesheets USING btree (status_changed_at);


--
-- Name: index_transactions_on_charge_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_charge_source_id ON public.transactions USING btree (charge_source_id);


--
-- Name: index_transactions_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_date ON public.transactions USING btree (date);


--
-- Name: index_transactions_on_last_try_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_last_try_at ON public.transactions USING btree (last_try_at);


--
-- Name: index_transactions_on_parent_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_parent_transaction_id ON public.transactions USING btree (parent_transaction_id);


--
-- Name: index_transactions_on_payment_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_payment_target_id ON public.transactions USING btree (payment_target_id);


--
-- Name: index_transactions_on_processed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_processed_at ON public.transactions USING btree (processed_at);


--
-- Name: index_transactions_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_project_id ON public.transactions USING btree (project_id);


--
-- Name: index_transactions_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_status ON public.transactions USING btree (status);


--
-- Name: index_transactions_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_type ON public.transactions USING btree (type);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_deleted ON public.users USING btree (deleted);


--
-- Name: index_users_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_deleted_at ON public.users USING btree (deleted_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_suspended; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_suspended ON public.users USING btree (suspended);


--
-- Name: index_users_on_suspended_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_suspended_at ON public.users USING btree (suspended_at);


--
-- Name: index_work_experiences_on_compliance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_experiences_on_compliance ON public.work_experiences USING btree (compliance);


--
-- Name: index_work_experiences_on_current; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_experiences_on_current ON public.work_experiences USING btree (current);


--
-- Name: index_work_experiences_on_from; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_experiences_on_from ON public.work_experiences USING btree ("from");


--
-- Name: index_work_experiences_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_experiences_on_specialist_id ON public.work_experiences USING btree (specialist_id);


--
-- Name: index_work_experiences_on_to; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_experiences_on_to ON public.work_experiences USING btree ("to");


--
-- Name: industries_specialists_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX industries_specialists_unique ON public.industries_specialists USING btree (industry_id, specialist_id);


--
-- Name: jurisdictions_specialists_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX jurisdictions_specialists_unique ON public.jurisdictions_specialists USING btree (jurisdiction_id, specialist_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: projects calculate_budget; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER calculate_budget BEFORE INSERT OR UPDATE ON public.projects FOR EACH ROW EXECUTE PROCEDURE public.projects_calculate_budget();


--
-- Name: projects trigger_projects_on_lat_lng; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_projects_on_lat_lng BEFORE INSERT OR UPDATE OF lat, lng ON public.projects FOR EACH ROW EXECUTE PROCEDURE public.set_point_from_lat_lng();


--
-- Name: specialists trigger_specialists_on_lat_lng; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_specialists_on_lat_lng BEFORE INSERT OR UPDATE OF lat, lng ON public.specialists FOR EACH ROW EXECUTE PROCEDURE public.set_point_from_lat_lng();


--
-- Name: projects tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.projects FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv', 'pg_catalog.english', 'title', 'description');


--
-- Name: stripe_accounts fk_rails_7988d7b477; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_accounts
    ADD CONSTRAINT fk_rails_7988d7b477 FOREIGN KEY (specialist_id) REFERENCES public.specialists(id);


--
-- Name: project_issues fk_rails_80e6243750; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_issues
    ADD CONSTRAINT fk_rails_80e6243750 FOREIGN KEY (admin_user_id) REFERENCES public.admin_users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

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

INSERT INTO schema_migrations (version) VALUES ('20161216191410');

INSERT INTO schema_migrations (version) VALUES ('20161216194421');

INSERT INTO schema_migrations (version) VALUES ('20170109234629');

INSERT INTO schema_migrations (version) VALUES ('20170110003441');

INSERT INTO schema_migrations (version) VALUES ('20170110004317');

INSERT INTO schema_migrations (version) VALUES ('20170111205323');

INSERT INTO schema_migrations (version) VALUES ('20170111220646');

INSERT INTO schema_migrations (version) VALUES ('20170118003355');

INSERT INTO schema_migrations (version) VALUES ('20170118012655');

INSERT INTO schema_migrations (version) VALUES ('20170120205317');

INSERT INTO schema_migrations (version) VALUES ('20170120222804');

INSERT INTO schema_migrations (version) VALUES ('20170121204351');

INSERT INTO schema_migrations (version) VALUES ('20170124102558');

INSERT INTO schema_migrations (version) VALUES ('20170128182414');

INSERT INTO schema_migrations (version) VALUES ('20170201033003');

INSERT INTO schema_migrations (version) VALUES ('20170205030444');

INSERT INTO schema_migrations (version) VALUES ('20170206020010');

INSERT INTO schema_migrations (version) VALUES ('20170208044644');

INSERT INTO schema_migrations (version) VALUES ('20170208045428');

INSERT INTO schema_migrations (version) VALUES ('20170208211820');

INSERT INTO schema_migrations (version) VALUES ('20170306232008');

INSERT INTO schema_migrations (version) VALUES ('20170307203302');

INSERT INTO schema_migrations (version) VALUES ('20170314025240');

INSERT INTO schema_migrations (version) VALUES ('20170314145501');

INSERT INTO schema_migrations (version) VALUES ('20170314145531');

INSERT INTO schema_migrations (version) VALUES ('20170321022610');

INSERT INTO schema_migrations (version) VALUES ('20170321030955');

INSERT INTO schema_migrations (version) VALUES ('20170410233330');

INSERT INTO schema_migrations (version) VALUES ('20170415185854');

INSERT INTO schema_migrations (version) VALUES ('20170506204523');

INSERT INTO schema_migrations (version) VALUES ('20170508190146');

INSERT INTO schema_migrations (version) VALUES ('20170508231021');

INSERT INTO schema_migrations (version) VALUES ('20170720153724');

INSERT INTO schema_migrations (version) VALUES ('20170727084631');

INSERT INTO schema_migrations (version) VALUES ('20170919140223');

INSERT INTO schema_migrations (version) VALUES ('20170919163901');

INSERT INTO schema_migrations (version) VALUES ('20170919200413');

INSERT INTO schema_migrations (version) VALUES ('20180323075021');

INSERT INTO schema_migrations (version) VALUES ('20180531123213');

INSERT INTO schema_migrations (version) VALUES ('20180531132555');

INSERT INTO schema_migrations (version) VALUES ('20180605145214');

INSERT INTO schema_migrations (version) VALUES ('20180609010335');

INSERT INTO schema_migrations (version) VALUES ('20180614160822');

INSERT INTO schema_migrations (version) VALUES ('20180622004759');

INSERT INTO schema_migrations (version) VALUES ('20180712053404');

INSERT INTO schema_migrations (version) VALUES ('20180717152210');

INSERT INTO schema_migrations (version) VALUES ('20180728192204');

INSERT INTO schema_migrations (version) VALUES ('20180728213813');

INSERT INTO schema_migrations (version) VALUES ('20180729032945');

INSERT INTO schema_migrations (version) VALUES ('20180729172500');

INSERT INTO schema_migrations (version) VALUES ('20180807032531');

INSERT INTO schema_migrations (version) VALUES ('20180808042020');

INSERT INTO schema_migrations (version) VALUES ('20180809033224');

INSERT INTO schema_migrations (version) VALUES ('20180809052509');

INSERT INTO schema_migrations (version) VALUES ('20180811003234');

INSERT INTO schema_migrations (version) VALUES ('20180811025719');

INSERT INTO schema_migrations (version) VALUES ('20180811063154');

INSERT INTO schema_migrations (version) VALUES ('20180811063955');

INSERT INTO schema_migrations (version) VALUES ('20180819092322');

INSERT INTO schema_migrations (version) VALUES ('20180827045947');

INSERT INTO schema_migrations (version) VALUES ('20180827051141');

INSERT INTO schema_migrations (version) VALUES ('20180827191112');

INSERT INTO schema_migrations (version) VALUES ('20180908030634');

INSERT INTO schema_migrations (version) VALUES ('20180911180555');

INSERT INTO schema_migrations (version) VALUES ('20180911182144');

INSERT INTO schema_migrations (version) VALUES ('20180914165337');

INSERT INTO schema_migrations (version) VALUES ('20181026024940');

INSERT INTO schema_migrations (version) VALUES ('20181026212530');

INSERT INTO schema_migrations (version) VALUES ('20181028010350');

INSERT INTO schema_migrations (version) VALUES ('20181028023519');

INSERT INTO schema_migrations (version) VALUES ('20181028102912');

INSERT INTO schema_migrations (version) VALUES ('20181217094718');

INSERT INTO schema_migrations (version) VALUES ('20181217113715');

INSERT INTO schema_migrations (version) VALUES ('20181217114759');

INSERT INTO schema_migrations (version) VALUES ('20181219174332');

INSERT INTO schema_migrations (version) VALUES ('20181221144557');

INSERT INTO schema_migrations (version) VALUES ('20181221165209');

