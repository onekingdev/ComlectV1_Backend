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
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA tiger;


--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA tiger_data;


--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA topology;


--
-- Name: address_standardizer; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS address_standardizer WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION address_standardizer IS 'Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.';


--
-- Name: address_standardizer_data_us; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS address_standardizer_data_us WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer_data_us; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION address_standardizer_data_us IS 'Address Standardizer US dataset example';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_sfcgal; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_sfcgal WITH SCHEMA public;


--
-- Name: EXTENSION postgis_sfcgal; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis_sfcgal IS 'PostGIS SFCGAL functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


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
-- Name: annual_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.annual_reports (
    id integer NOT NULL,
    exam_start date,
    exam_end date,
    review_start date,
    review_end date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    business_id integer,
    pdf_data jsonb,
    year integer,
    material_business_changes text DEFAULT ''::text,
    name character varying DEFAULT ''::character varying
);


--
-- Name: annual_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.annual_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: annual_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.annual_reports_id_seq OWNED BY public.annual_reports.id;


--
-- Name: annual_review_employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.annual_review_employees (
    id integer NOT NULL,
    name character varying,
    title character varying,
    department character varying,
    annual_report_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: annual_review_employees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.annual_review_employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: annual_review_employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.annual_review_employees_id_seq OWNED BY public.annual_review_employees.id;


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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


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
-- Name: audit_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_comments (
    id integer NOT NULL,
    audit_request_id integer,
    business_id integer,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audit_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_comments_id_seq OWNED BY public.audit_comments.id;


--
-- Name: audit_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_requests (
    id integer NOT NULL,
    body character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audit_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_requests_id_seq OWNED BY public.audit_requests.id;


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
-- Name: business_specialists_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_specialists_roles (
    id bigint NOT NULL,
    business_id bigint NOT NULL,
    specialist_id bigint NOT NULL,
    role integer DEFAULT 0
);


--
-- Name: business_specialists_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.business_specialists_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_specialists_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.business_specialists_roles_id_seq OWNED BY public.business_specialists_roles.id;


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
    credits_in_cents integer DEFAULT 0,
    qna_lvl integer DEFAULT 0,
    qna_viewed_questions integer[] DEFAULT '{}'::integer[],
    qna_views_left integer DEFAULT 3,
    username character varying,
    sub_industries character varying,
    business_stages character varying,
    business_risks character varying,
    business_other character varying,
    sec_or_crd character varying,
    office_state character varying,
    branch_offices boolean,
    client_account_cnt integer,
    client_types character varying,
    aum numeric,
    cco character varying,
    already_covered character varying,
    review_plan character varying,
    annual_compliance boolean,
    already_covered_other character varying,
    tutorial_complete boolean DEFAULT false,
    review_declined boolean DEFAULT false,
    onboard_call_booked boolean DEFAULT false,
    welcomed boolean DEFAULT false,
    total_assets numeric,
    onboarding_passed boolean DEFAULT false,
    ria_dashboard boolean DEFAULT false,
    compliance_policies_spawned boolean DEFAULT false,
    annual_budget numeric,
    risk_tolerance character varying,
    reminders_mailed_at timestamp without time zone,
    crd_number character varying,
    account_created boolean DEFAULT false,
    apartment character varying
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
-- Name: compliance_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compliance_categories (
    id integer NOT NULL,
    name character varying,
    checkboxes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text DEFAULT ''::text,
    however text DEFAULT ''::text,
    findings_everywhere text DEFAULT ''::text
);


--
-- Name: compliance_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compliance_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compliance_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compliance_categories_id_seq OWNED BY public.compliance_categories.id;


--
-- Name: compliance_policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compliance_policies (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    business_id integer,
    pdf_data jsonb,
    "position" double precision,
    ban boolean DEFAULT false,
    description text DEFAULT ''::text,
    src_id integer,
    status character varying DEFAULT 'draft'::character varying,
    sections jsonb,
    archived boolean DEFAULT false
);


--
-- Name: compliance_policies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compliance_policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compliance_policies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compliance_policies_id_seq OWNED BY public.compliance_policies.id;


--
-- Name: compliance_policies_risks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compliance_policies_risks (
    id bigint NOT NULL,
    risk_id bigint NOT NULL,
    compliance_policy_id bigint NOT NULL
);


--
-- Name: compliance_policies_risks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compliance_policies_risks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compliance_policies_risks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compliance_policies_risks_id_seq OWNED BY public.compliance_policies_risks.id;


--
-- Name: compliance_policy_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compliance_policy_configurations (
    id bigint NOT NULL,
    business_id integer,
    logo_data jsonb,
    address boolean,
    phone boolean,
    email boolean,
    disclosure boolean,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: compliance_policy_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compliance_policy_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compliance_policy_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compliance_policy_configurations_id_seq OWNED BY public.compliance_policy_configurations.id;


--
-- Name: compliance_policy_docs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compliance_policy_docs (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    compliance_policy_id integer,
    doc_data jsonb,
    pdf_data jsonb
);


--
-- Name: compliance_policy_docs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compliance_policy_docs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compliance_policy_docs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compliance_policy_docs_id_seq OWNED BY public.compliance_policy_docs.id;


--
-- Name: cookie_agreements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cookie_agreements (
    id integer NOT NULL,
    agreement_date timestamp without time zone,
    cookie_description character varying,
    status boolean,
    ip_address character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cookie_agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cookie_agreements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cookie_agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cookie_agreements_id_seq OWNED BY public.cookie_agreements.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    owner_id integer,
    owner_type character varying,
    local_project_id integer NOT NULL,
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
-- Name: exam_request_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_request_files (
    id bigint NOT NULL,
    exam_request_id integer,
    file_data jsonb,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: exam_request_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exam_request_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exam_request_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exam_request_files_id_seq OWNED BY public.exam_request_files.id;


--
-- Name: exam_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_requests (
    id bigint NOT NULL,
    name character varying,
    details text,
    text_items jsonb,
    complete boolean DEFAULT false,
    shared boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    exam_id integer
);


--
-- Name: exam_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exam_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exam_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exam_requests_id_seq OWNED BY public.exam_requests.id;


--
-- Name: exams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exams (
    id bigint NOT NULL,
    name character varying,
    starts_on date,
    ends_on date,
    share_uuid character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    business_id integer,
    complete boolean DEFAULT false
);


--
-- Name: exams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exams_id_seq OWNED BY public.exams.id;


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
-- Name: file_docs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_docs (
    id integer NOT NULL,
    business_id integer,
    file_folder_id integer,
    file_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: file_docs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.file_docs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_docs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.file_docs_id_seq OWNED BY public.file_docs.id;


--
-- Name: file_folders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_folders (
    id integer NOT NULL,
    business_id integer,
    name character varying,
    parent_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locked boolean DEFAULT false,
    zip_data jsonb
);


--
-- Name: file_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.file_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.file_folders_id_seq OWNED BY public.file_folders.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    business_id integer NOT NULL,
    type character varying DEFAULT 'rfp'::character varying NOT NULL,
    status character varying DEFAULT 'draft'::character varying NOT NULL,
    title character varying,
    location_type character varying,
    location character varying,
    description character varying,
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
    expires_at timestamp without time zone,
    solicited_business_rating boolean DEFAULT false,
    solicited_specialist_rating boolean DEFAULT false,
    duration_type character varying DEFAULT 'custom'::character varying,
    estimated_days integer,
    rfp_timing character varying,
    est_budget numeric,
    applicant_selection character varying DEFAULT 'interview'::character varying,
    admin_notified boolean DEFAULT false,
    business_fee_free boolean DEFAULT false,
    color character varying,
    local_project_id integer,
    role_details text DEFAULT ''::text,
    upper_hourly_rate numeric,
    minimum_experience integer DEFAULT 0
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
-- Name: forum_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forum_answers (
    id integer NOT NULL,
    user_id integer,
    body text,
    forum_question_id integer,
    reply_to integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    upvotes_cnt integer DEFAULT 0,
    file_data jsonb
);


--
-- Name: forum_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.forum_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forum_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.forum_answers_id_seq OWNED BY public.forum_answers.id;


--
-- Name: forum_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forum_questions (
    id integer NOT NULL,
    title character varying,
    body text,
    state character varying,
    business_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_activity timestamp without time zone,
    url character varying
);


--
-- Name: forum_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.forum_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forum_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.forum_questions_id_seq OWNED BY public.forum_questions.id;


--
-- Name: forum_questions_industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forum_questions_industries (
    forum_question_id integer NOT NULL,
    industry_id integer NOT NULL
);


--
-- Name: forum_questions_jurisdictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forum_questions_jurisdictions (
    forum_question_id integer NOT NULL,
    jurisdiction_id integer NOT NULL
);


--
-- Name: forum_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forum_subscriptions (
    id integer NOT NULL,
    business_id integer,
    billing_type integer DEFAULT 0,
    level integer DEFAULT 0,
    suspended boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fee integer DEFAULT 0,
    stripe_customer_id character varying,
    stripe_subscription_id character varying,
    renewal_date timestamp without time zone,
    cancelled boolean DEFAULT false,
    auto_renew boolean DEFAULT false
);


--
-- Name: forum_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.forum_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forum_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.forum_subscriptions_id_seq OWNED BY public.forum_subscriptions.id;


--
-- Name: forum_votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forum_votes (
    id integer NOT NULL,
    user_id integer,
    forum_answer_id integer,
    upvote boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: forum_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.forum_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forum_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.forum_votes_id_seq OWNED BY public.forum_votes.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    short_name character varying,
    sub_industries text DEFAULT ''::text,
    sub_industries_specialist text DEFAULT ''::text
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
    status character varying,
    role_details text DEFAULT ''::text
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
    updated_at timestamp without time zone NOT NULL,
    sub_jurisdictions_specialist text DEFAULT ''::text
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
-- Name: local_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.local_projects (
    id bigint NOT NULL,
    business_id integer,
    title character varying,
    description text,
    starts_on date,
    ends_on date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status character varying DEFAULT 'inprogress'::character varying
);


--
-- Name: local_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.local_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: local_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.local_projects_id_seq OWNED BY public.local_projects.id;


--
-- Name: local_projects_specialists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.local_projects_specialists (
    id bigint NOT NULL,
    local_project_id bigint NOT NULL,
    specialist_id bigint NOT NULL
);


--
-- Name: local_projects_specialists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.local_projects_specialists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: local_projects_specialists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.local_projects_specialists_id_seq OWNED BY public.local_projects_specialists.id;


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
    updated_at timestamp without time zone NOT NULL,
    read_by_recipient boolean DEFAULT false
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
    credits_in_cents integer DEFAULT 0,
    forum_upvotes_for_review integer DEFAULT 0,
    username character varying,
    specialist_risks character varying,
    specialist_other character varying,
    sub_industries character varying,
    project_types character varying,
    jurisdiction_states_usa character varying DEFAULT ''::character varying,
    jurisdiction_states_canada character varying DEFAULT ''::character varying,
    sub_jurisdictions character varying,
    sub_jurisdictions_other character varying,
    call_booked boolean DEFAULT false,
    dashboard_unlocked boolean DEFAULT false,
    min_hourly_rate integer,
    annual_revenue_goal numeric,
    risk_tolerance character varying,
    automatching_available boolean DEFAULT false,
    reminders_mailed_at timestamp without time zone,
    zero_fee boolean DEFAULT false,
    seat_role integer DEFAULT 0,
    experience integer DEFAULT 0
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
    inactive_for_period boolean DEFAULT false,
    muted_projects text DEFAULT '--- []
'::text,
    otp_secret character varying,
    otp_counter integer,
    email_confirmed boolean DEFAULT false,
    hidden_local_projects jsonb DEFAULT '[]'::jsonb
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
    updated_at timestamp without time zone NOT NULL,
    failed boolean DEFAULT false
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
    validated boolean DEFAULT false NOT NULL,
    coupon_id character varying
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
-- Name: ported_businesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ported_businesses (
    id integer NOT NULL,
    company character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    specialist_id integer,
    status integer DEFAULT 0,
    token text,
    business_id integer
);


--
-- Name: ported_businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ported_businesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ported_businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ported_businesses_id_seq OWNED BY public.ported_businesses.id;


--
-- Name: ported_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ported_subscriptions (
    id integer NOT NULL,
    specialist_id integer,
    period integer DEFAULT 0,
    subscribed_at timestamp without time zone,
    billing_period_ends_at timestamp without time zone,
    stripe_subscription_id text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status integer DEFAULT 0
);


--
-- Name: ported_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ported_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ported_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ported_subscriptions_id_seq OWNED BY public.ported_subscriptions.id;


--
-- Name: potential_businesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.potential_businesses (
    id bigint NOT NULL,
    crd_number character varying,
    contact_phone character varying,
    business_name character varying,
    website character varying,
    address_1 character varying,
    city character varying,
    state character varying,
    zipcode character varying,
    apartment character varying,
    client_account_cnt integer,
    aum numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: potential_businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.potential_businesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: potential_businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.potential_businesses_id_seq OWNED BY public.potential_businesses.id;


--
-- Name: project_ends; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_ends (
    id integer NOT NULL,
    project_id integer,
    status character varying,
    expires_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    requester character varying
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
    ends_on date,
    expires_at timestamp without time zone,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    requester character varying,
    starts_on date,
    fixed_budget numeric,
    hourly_rate numeric,
    role_details text,
    key_deliverables character varying,
    ends_on_only boolean DEFAULT false
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
    public_features text,
    business_fee_free boolean DEFAULT false,
    identifier character varying,
    applicant_selection character varying DEFAULT 'interview'::character varying
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
    updated_at timestamp without time zone NOT NULL,
    forum_rating boolean DEFAULT false,
    specialist_id integer
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
-- Name: regulatory_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulatory_changes (
    id integer NOT NULL,
    annual_report_id integer,
    change text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: regulatory_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regulatory_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regulatory_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regulatory_changes_id_seq OWNED BY public.regulatory_changes.id;


--
-- Name: reminders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reminders (
    id integer NOT NULL,
    body character varying,
    remindable_id integer,
    remind_at date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    done_at timestamp without time zone,
    end_date date,
    remindable_type character varying,
    repeats character varying,
    end_by date,
    repeat_every integer,
    repeat_on integer,
    on_type character varying,
    skip_occurencies text DEFAULT ''::text,
    done_occurencies text,
    note character varying DEFAULT ''::character varying,
    description text DEFAULT ''::text,
    linkable_id integer,
    linkable_type character varying
);


--
-- Name: reminders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reminders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reminders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reminders_id_seq OWNED BY public.reminders.id;


--
-- Name: review_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review_categories (
    id bigint NOT NULL,
    annual_report_id integer,
    complete boolean DEFAULT false,
    name character varying DEFAULT ''::character varying,
    review_topics jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: review_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.review_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.review_categories_id_seq OWNED BY public.review_categories.id;


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
-- Name: risks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.risks (
    id bigint NOT NULL,
    name character varying,
    impact integer,
    business_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    likelihood integer
);


--
-- Name: risks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.risks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: risks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.risks_id_seq OWNED BY public.risks.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: seats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seats (
    id integer NOT NULL,
    business_id bigint,
    subscription_id bigint,
    team_member_id bigint,
    subscribed_at timestamp without time zone,
    assigned_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: seats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seats_id_seq OWNED BY public.seats.id;


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
    specialist_team_id integer,
    specialist_id integer,
    first_name character varying NOT NULL,
    last_name character varying,
    email character varying NOT NULL,
    token character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    team_id integer,
    role integer DEFAULT 0
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
-- Name: specialist_payment_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialist_payment_sources (
    id integer NOT NULL,
    specialist_id integer,
    stripe_customer_id text,
    stripe_card_id text,
    brand text,
    exp_month integer,
    exp_year integer,
    last4 text,
    "primary" boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    validated boolean DEFAULT false,
    bank_account boolean DEFAULT false,
    country character varying,
    currency character varying,
    account_holder_name character varying,
    account_holder_type character varying
);


--
-- Name: specialist_payment_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.specialist_payment_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: specialist_payment_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.specialist_payment_sources_id_seq OWNED BY public.specialist_payment_sources.id;


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
-- Name: subscription_charges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription_charges (
    id integer NOT NULL,
    stripe_charge_id character varying,
    status integer,
    plan character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stripe_subscription_id character varying,
    forum_subscription_id integer,
    amount integer,
    chargeable_id integer,
    chargeable_type character varying,
    title character varying
);


--
-- Name: subscription_charges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscription_charges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscription_charges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscription_charges_id_seq OWNED BY public.subscription_charges.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    business_id bigint,
    stripe_subscription_id character varying,
    stripe_invoice_item_id character varying,
    plan integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    kind_of integer DEFAULT 0,
    title character varying,
    billing_period_ends integer,
    payment_source_id integer,
    auto_renew boolean DEFAULT false,
    status integer DEFAULT 0,
    specialist_id bigint,
    specialist_payment_source_id bigint
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_members (
    id integer NOT NULL,
    team_id integer,
    name character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying,
    start_date date,
    end_date date,
    termination_reason text,
    first_name character varying,
    last_name character varying,
    access_person boolean DEFAULT false,
    business_member boolean DEFAULT false
);


--
-- Name: team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_members_id_seq OWNED BY public.team_members.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    business_id integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display boolean DEFAULT true
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


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
-- Name: tos_agreements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tos_agreements (
    id integer NOT NULL,
    agreement_date timestamp without time zone,
    tos_description character varying,
    status boolean,
    ip_address character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tos_agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tos_agreements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tos_agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tos_agreements_id_seq OWNED BY public.tos_agreements.id;


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
-- Name: annual_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annual_reports ALTER COLUMN id SET DEFAULT nextval('public.annual_reports_id_seq'::regclass);


--
-- Name: annual_review_employees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annual_review_employees ALTER COLUMN id SET DEFAULT nextval('public.annual_review_employees_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: audit_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_comments ALTER COLUMN id SET DEFAULT nextval('public.audit_comments_id_seq'::regclass);


--
-- Name: audit_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_requests ALTER COLUMN id SET DEFAULT nextval('public.audit_requests_id_seq'::regclass);


--
-- Name: bank_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts ALTER COLUMN id SET DEFAULT nextval('public.bank_accounts_id_seq'::regclass);


--
-- Name: business_specialists_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_specialists_roles ALTER COLUMN id SET DEFAULT nextval('public.business_specialists_roles_id_seq'::regclass);


--
-- Name: businesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.businesses ALTER COLUMN id SET DEFAULT nextval('public.businesses_id_seq'::regclass);


--
-- Name: charges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charges ALTER COLUMN id SET DEFAULT nextval('public.charges_id_seq'::regclass);


--
-- Name: compliance_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_categories ALTER COLUMN id SET DEFAULT nextval('public.compliance_categories_id_seq'::regclass);


--
-- Name: compliance_policies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policies ALTER COLUMN id SET DEFAULT nextval('public.compliance_policies_id_seq'::regclass);


--
-- Name: compliance_policies_risks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policies_risks ALTER COLUMN id SET DEFAULT nextval('public.compliance_policies_risks_id_seq'::regclass);


--
-- Name: compliance_policy_configurations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policy_configurations ALTER COLUMN id SET DEFAULT nextval('public.compliance_policy_configurations_id_seq'::regclass);


--
-- Name: compliance_policy_docs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policy_docs ALTER COLUMN id SET DEFAULT nextval('public.compliance_policy_docs_id_seq'::regclass);


--
-- Name: cookie_agreements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cookie_agreements ALTER COLUMN id SET DEFAULT nextval('public.cookie_agreements_id_seq'::regclass);


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
-- Name: exam_request_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_request_files ALTER COLUMN id SET DEFAULT nextval('public.exam_request_files_id_seq'::regclass);


--
-- Name: exam_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_requests ALTER COLUMN id SET DEFAULT nextval('public.exam_requests_id_seq'::regclass);


--
-- Name: exams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams ALTER COLUMN id SET DEFAULT nextval('public.exams_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: feedback_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_requests ALTER COLUMN id SET DEFAULT nextval('public.feedback_requests_id_seq'::regclass);


--
-- Name: file_docs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_docs ALTER COLUMN id SET DEFAULT nextval('public.file_docs_id_seq'::regclass);


--
-- Name: file_folders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_folders ALTER COLUMN id SET DEFAULT nextval('public.file_folders_id_seq'::regclass);


--
-- Name: flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags ALTER COLUMN id SET DEFAULT nextval('public.flags_id_seq'::regclass);


--
-- Name: forum_answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forum_answers ALTER COLUMN id SET DEFAULT nextval('public.forum_answers_id_seq'::regclass);


--
-- Name: forum_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forum_questions ALTER COLUMN id SET DEFAULT nextval('public.forum_questions_id_seq'::regclass);


--
-- Name: forum_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forum_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.forum_subscriptions_id_seq'::regclass);


--
-- Name: forum_votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forum_votes ALTER COLUMN id SET DEFAULT nextval('public.forum_votes_id_seq'::regclass);


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
-- Name: local_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_projects ALTER COLUMN id SET DEFAULT nextval('public.local_projects_id_seq'::regclass);


--
-- Name: local_projects_specialists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_projects_specialists ALTER COLUMN id SET DEFAULT nextval('public.local_projects_specialists_id_seq'::regclass);


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
-- Name: ported_businesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ported_businesses ALTER COLUMN id SET DEFAULT nextval('public.ported_businesses_id_seq'::regclass);


--
-- Name: ported_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ported_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.ported_subscriptions_id_seq'::regclass);


--
-- Name: potential_businesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.potential_businesses ALTER COLUMN id SET DEFAULT nextval('public.potential_businesses_id_seq'::regclass);


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
-- Name: regulatory_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulatory_changes ALTER COLUMN id SET DEFAULT nextval('public.regulatory_changes_id_seq'::regclass);


--
-- Name: reminders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reminders ALTER COLUMN id SET DEFAULT nextval('public.reminders_id_seq'::regclass);


--
-- Name: review_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_categories ALTER COLUMN id SET DEFAULT nextval('public.review_categories_id_seq'::regclass);


--
-- Name: rewards_tiers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rewards_tiers ALTER COLUMN id SET DEFAULT nextval('public.rewards_tiers_id_seq'::regclass);


--
-- Name: risks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.risks ALTER COLUMN id SET DEFAULT nextval('public.risks_id_seq'::regclass);


--
-- Name: seats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seats ALTER COLUMN id SET DEFAULT nextval('public.seats_id_seq'::regclass);


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
-- Name: specialist_payment_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_payment_sources ALTER COLUMN id SET DEFAULT nextval('public.specialist_payment_sources_id_seq'::regclass);


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
-- Name: subscription_charges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_charges ALTER COLUMN id SET DEFAULT nextval('public.subscription_charges_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: team_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members ALTER COLUMN id SET DEFAULT nextval('public.team_members_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: time_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_logs ALTER COLUMN id SET DEFAULT nextval('public.time_logs_id_seq'::regclass);


--
-- Name: timesheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets ALTER COLUMN id SET DEFAULT nextval('public.timesheets_id_seq'::regclass);


--
-- Name: tos_agreements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tos_agreements ALTER COLUMN id SET DEFAULT nextval('public.tos_agreements_id_seq'::regclass);


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
-- Name: annual_reports annual_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annual_reports
    ADD CONSTRAINT annual_reports_pkey PRIMARY KEY (id);


--
-- Name: annual_review_employees annual_review_employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annual_review_employees
    ADD CONSTRAINT annual_review_employees_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: audit_comments audit_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_comments
    ADD CONSTRAINT audit_comments_pkey PRIMARY KEY (id);


--
-- Name: audit_requests audit_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_requests
    ADD CONSTRAINT audit_requests_pkey PRIMARY KEY (id);


--
-- Name: bank_accounts bank_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts
    ADD CONSTRAINT bank_accounts_pkey PRIMARY KEY (id);


--
-- Name: business_specialists_roles business_specialists_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_specialists_roles
    ADD CONSTRAINT business_specialists_roles_pkey PRIMARY KEY (id);


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
-- Name: compliance_categories compliance_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_categories
    ADD CONSTRAINT compliance_categories_pkey PRIMARY KEY (id);


--
-- Name: compliance_policies compliance_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policies
    ADD CONSTRAINT compliance_policies_pkey PRIMARY KEY (id);


--
-- Name: compliance_policies_risks compliance_policies_risks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policies_risks
    ADD CONSTRAINT compliance_policies_risks_pkey PRIMARY KEY (id);


--
-- Name: compliance_policy_configurations compliance_policy_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policy_configurations
    ADD CONSTRAINT compliance_policy_configurations_pkey PRIMARY KEY (id);


--
-- Name: compliance_policy_docs compliance_policy_docs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policy_docs
    ADD CONSTRAINT compliance_policy_docs_pkey PRIMARY KEY (id);


--
-- Name: cookie_agreements cookie_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cookie_agreements
    ADD CONSTRAINT cookie_agreements_pkey PRIMARY KEY (id);


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
-- Name: exam_request_files exam_request_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_request_files
    ADD CONSTRAINT exam_request_files_pkey PRIMARY KEY (id);


--
-- Name: exam_requests exam_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_requests
    ADD CONSTRAINT exam_requests_pkey PRIMARY KEY (id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


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
-- Name: file_docs file_docs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_docs
    ADD CONSTRAINT file_docs_pkey PRIMARY KEY (id);


--
-- Name: file_folders file_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_folders
    ADD CONSTRAINT file_folders_pkey PRIMARY KEY (id);


--
-- Name: flags flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


--
-- Name: forum_answers forum_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forum_answers
    ADD CONSTRAINT forum_answers_pkey PRIMARY KEY (id);


--
-- Name: forum_questions forum_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forum_questions
    ADD CONSTRAINT forum_questions_pkey PRIMARY KEY (id);


--
-- Name: forum_subscriptions forum_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forum_subscriptions
    ADD CONSTRAINT forum_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: forum_votes forum_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forum_votes
    ADD CONSTRAINT forum_votes_pkey PRIMARY KEY (id);


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
-- Name: local_projects local_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_projects
    ADD CONSTRAINT local_projects_pkey PRIMARY KEY (id);


--
-- Name: local_projects_specialists local_projects_specialists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_projects_specialists
    ADD CONSTRAINT local_projects_specialists_pkey PRIMARY KEY (id);


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
-- Name: ported_businesses ported_businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ported_businesses
    ADD CONSTRAINT ported_businesses_pkey PRIMARY KEY (id);


--
-- Name: ported_subscriptions ported_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ported_subscriptions
    ADD CONSTRAINT ported_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: potential_businesses potential_businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.potential_businesses
    ADD CONSTRAINT potential_businesses_pkey PRIMARY KEY (id);


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
-- Name: regulatory_changes regulatory_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulatory_changes
    ADD CONSTRAINT regulatory_changes_pkey PRIMARY KEY (id);


--
-- Name: reminders reminders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reminders
    ADD CONSTRAINT reminders_pkey PRIMARY KEY (id);


--
-- Name: review_categories review_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_categories
    ADD CONSTRAINT review_categories_pkey PRIMARY KEY (id);


--
-- Name: rewards_tiers rewards_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rewards_tiers
    ADD CONSTRAINT rewards_tiers_pkey PRIMARY KEY (id);


--
-- Name: risks risks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.risks
    ADD CONSTRAINT risks_pkey PRIMARY KEY (id);


--
-- Name: seats seats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_pkey PRIMARY KEY (id);


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
-- Name: specialist_payment_sources specialist_payment_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_payment_sources
    ADD CONSTRAINT specialist_payment_sources_pkey PRIMARY KEY (id);


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
-- Name: subscription_charges subscription_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_charges
    ADD CONSTRAINT subscription_charges_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


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
-- Name: tos_agreements tos_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tos_agreements
    ADD CONSTRAINT tos_agreements_pkey PRIMARY KEY (id);


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
-- Name: index_business_specialists_roles_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_specialists_roles_on_business_id ON public.business_specialists_roles USING btree (business_id);


--
-- Name: index_business_specialists_roles_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_specialists_roles_on_specialist_id ON public.business_specialists_roles USING btree (specialist_id);


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
-- Name: index_compliance_policies_risks_on_compliance_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_compliance_policies_risks_on_compliance_policy_id ON public.compliance_policies_risks USING btree (compliance_policy_id);


--
-- Name: index_compliance_policies_risks_on_risk_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_compliance_policies_risks_on_risk_id ON public.compliance_policies_risks USING btree (risk_id);


--
-- Name: index_cookie_agreements_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cookie_agreements_on_user_id ON public.cookie_agreements USING btree (user_id);


--
-- Name: index_documents_on_local_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_local_project_id ON public.documents USING btree (local_project_id);


--
-- Name: index_documents_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_owner_type_and_owner_id ON public.documents USING btree (owner_type, owner_id);


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
-- Name: index_forum_subscriptions_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_forum_subscriptions_on_business_id ON public.forum_subscriptions USING btree (business_id);


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
-- Name: index_local_projects_specialists_on_local_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_local_projects_specialists_on_local_project_id ON public.local_projects_specialists USING btree (local_project_id);


--
-- Name: index_local_projects_specialists_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_local_projects_specialists_on_specialist_id ON public.local_projects_specialists USING btree (specialist_id);


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
-- Name: index_ported_businesses_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ported_businesses_on_business_id ON public.ported_businesses USING btree (business_id);


--
-- Name: index_ported_subscriptions_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ported_subscriptions_on_specialist_id ON public.ported_subscriptions USING btree (specialist_id);


--
-- Name: index_potential_businesses_on_crd_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_potential_businesses_on_crd_number ON public.potential_businesses USING btree (crd_number);


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
-- Name: index_seats_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_seats_on_business_id ON public.seats USING btree (business_id);


--
-- Name: index_seats_on_team_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_seats_on_team_member_id ON public.seats USING btree (team_member_id);


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
-- Name: index_specialist_invitations_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialist_invitations_on_team_id ON public.specialist_invitations USING btree (team_id);


--
-- Name: index_specialist_invitations_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialist_invitations_on_token ON public.specialist_invitations USING btree (token);


--
-- Name: index_specialist_payment_sources_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specialist_payment_sources_on_specialist_id ON public.specialist_payment_sources USING btree (specialist_id);


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
-- Name: index_subscription_charges_on_forum_subscription_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscription_charges_on_forum_subscription_id ON public.subscription_charges USING btree (forum_subscription_id);


--
-- Name: index_subscriptions_on_kind_of; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_kind_of ON public.subscriptions USING btree (kind_of);


--
-- Name: index_subscriptions_on_specialist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_specialist_id ON public.subscriptions USING btree (specialist_id);


--
-- Name: index_subscriptions_on_specialist_payment_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_specialist_payment_source_id ON public.subscriptions USING btree (specialist_payment_source_id);


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
-- Name: index_tos_agreements_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tos_agreements_on_user_id ON public.tos_agreements USING btree (user_id);


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
-- Name: local_projects_specialists fk_rails_05ae228387; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_projects_specialists
    ADD CONSTRAINT fk_rails_05ae228387 FOREIGN KEY (local_project_id) REFERENCES public.local_projects(id);


--
-- Name: cookie_agreements fk_rails_1a26beb8cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cookie_agreements
    ADD CONSTRAINT fk_rails_1a26beb8cc FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: local_projects_specialists fk_rails_2cd11c2911; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_projects_specialists
    ADD CONSTRAINT fk_rails_2cd11c2911 FOREIGN KEY (specialist_id) REFERENCES public.specialists(id);


--
-- Name: subscriptions fk_rails_61927ae2df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_61927ae2df FOREIGN KEY (specialist_payment_source_id) REFERENCES public.specialist_payment_sources(id);


--
-- Name: tos_agreements fk_rails_6e25fd106a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tos_agreements
    ADD CONSTRAINT fk_rails_6e25fd106a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: business_specialists_roles fk_rails_77436698dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_specialists_roles
    ADD CONSTRAINT fk_rails_77436698dd FOREIGN KEY (specialist_id) REFERENCES public.specialists(id);


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
-- Name: business_specialists_roles fk_rails_a4e1c0f49f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_specialists_roles
    ADD CONSTRAINT fk_rails_a4e1c0f49f FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: compliance_policies_risks fk_rails_c295f383a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policies_risks
    ADD CONSTRAINT fk_rails_c295f383a5 FOREIGN KEY (risk_id) REFERENCES public.risks(id);


--
-- Name: subscriptions fk_rails_dafea693de; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_dafea693de FOREIGN KEY (specialist_id) REFERENCES public.specialists(id);


--
-- Name: compliance_policies_risks fk_rails_ec44012ae5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_policies_risks
    ADD CONSTRAINT fk_rails_ec44012ae5 FOREIGN KEY (compliance_policy_id) REFERENCES public.compliance_policies(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public, tiger;

INSERT INTO "schema_migrations" (version) VALUES
('20160603200743'),
('20160606215415'),
('20160606230043'),
('20160607025107'),
('20160607205707'),
('20160611004308'),
('20160614211137'),
('20160616013430'),
('20160616155048'),
('20160616211257'),
('20160620220131'),
('20160621014832'),
('20160621181454'),
('20160623211024'),
('20160721011122'),
('20160722233234'),
('20160802183502'),
('20160802190058'),
('20160802200651'),
('20160802202615'),
('20160802210000'),
('20160802213145'),
('20160806190620'),
('20160807224348'),
('20160808122359'),
('20160808161529'),
('20160808163055'),
('20160808172557'),
('20160809161615'),
('20160810005559'),
('20160810021451'),
('20160812150543'),
('20160815145734'),
('20160815191902'),
('20160816192820'),
('20160816195801'),
('20160820222822'),
('20160820222901'),
('20160824202048'),
('20160826174241'),
('20160830172251'),
('20160830180941'),
('20160830194700'),
('20160831005700'),
('20160831170413'),
('20160831202556'),
('20160901060934'),
('20160901175940'),
('20160905191421'),
('20160906170404'),
('20160907162030'),
('20160908143324'),
('20160908170540'),
('20160909053710'),
('20160909170311'),
('20160909170614'),
('20160913025529'),
('20160913030250'),
('20160914160717'),
('20160916041708'),
('20160920034425'),
('20160929002205'),
('20160929181728'),
('20161004031506'),
('20161005031450'),
('20161005041957'),
('20161005193709'),
('20161005195837'),
('20161006060606'),
('20161006192238'),
('20161010150831'),
('20161013042100'),
('20161013153825'),
('20161013154701'),
('20161014194840'),
('20161014195149'),
('20161014231410'),
('20161018182637'),
('20161018200158'),
('20161018231053'),
('20161019231647'),
('20161019233541'),
('20161019233916'),
('20161020003125'),
('20161020003532'),
('20161020004927'),
('20161020060113'),
('20161021013658'),
('20161021014432'),
('20161026162641'),
('20161026171857'),
('20161027163457'),
('20161104010221'),
('20161105034339'),
('20161107203304'),
('20161130201113'),
('20161204011945'),
('20161204020457'),
('20161207193307'),
('20161216191410'),
('20161216194421'),
('20170109234629'),
('20170110003441'),
('20170110004317'),
('20170111205323'),
('20170111220646'),
('20170118003355'),
('20170118012655'),
('20170120205317'),
('20170120222804'),
('20170121204351'),
('20170124102558'),
('20170128182414'),
('20170201033003'),
('20170205030444'),
('20170206020010'),
('20170208044644'),
('20170208045428'),
('20170208211820'),
('20170306232008'),
('20170307203302'),
('20170314025240'),
('20170314145501'),
('20170314145531'),
('20170321022610'),
('20170321030955'),
('20170410233330'),
('20170415185854'),
('20170506204523'),
('20170508190146'),
('20170508231021'),
('20170720153724'),
('20170727084631'),
('20170919140223'),
('20170919163901'),
('20170919200413'),
('20180323075021'),
('20180531123213'),
('20180531132555'),
('20180605145214'),
('20180609010335'),
('20180614160822'),
('20180622004759'),
('20180712053404'),
('20180717152210'),
('20180728192204'),
('20180728213813'),
('20180729032945'),
('20180729172500'),
('20180807032531'),
('20180808042020'),
('20180809033224'),
('20180809052509'),
('20180811003234'),
('20180811025719'),
('20180811063154'),
('20180811063955'),
('20180819092322'),
('20180827045947'),
('20180827051141'),
('20180827191112'),
('20180908030634'),
('20180911180555'),
('20180911182144'),
('20180914165337'),
('20181026024940'),
('20181026212530'),
('20181028010350'),
('20181028023519'),
('20181028102912'),
('20181102164606'),
('20181110001445'),
('20181111001648'),
('20181112100355'),
('20181118233812'),
('20181123042811'),
('20181124133815'),
('20181124135819'),
('20181204204949'),
('20181204223503'),
('20181204224111'),
('20181205190733'),
('20181206190337'),
('20181206193340'),
('20181206194641'),
('20181206194651'),
('20181206201151'),
('20181207154323'),
('20181213163257'),
('20181213180722'),
('20181217094718'),
('20181217113715'),
('20181217114759'),
('20181218181633'),
('20181218185020'),
('20181219174332'),
('20181221144557'),
('20181221165209'),
('20190107142827'),
('20190111052406'),
('20190111081217'),
('20190113223605'),
('20190117163709'),
('20190117194225'),
('20190127161134'),
('20190226184824'),
('20190410191210'),
('20190613005026'),
('20190719004511'),
('20190723185902'),
('20190725045730'),
('20190804164816'),
('20190806212346'),
('20190806214013'),
('20190827194645'),
('20190912145221'),
('20190929215310'),
('20191013070720'),
('20191028010601'),
('20191028033710'),
('20191028035845'),
('20191028040525'),
('20191028054616'),
('20191101200437'),
('20191106180256'),
('20191107010504'),
('20191119063004'),
('20191119080112'),
('20191120121410'),
('20191205023843'),
('20191205203522'),
('20191205235626'),
('20191206010659'),
('20191208014625'),
('20191208014754'),
('20191208014928'),
('20191208015014'),
('20191208015712'),
('20191208015810'),
('20191209010949'),
('20191219200231'),
('20191219201057'),
('20191221035118'),
('20191221040705'),
('20200113034256'),
('20200114210331'),
('20200117080343'),
('20200117095549'),
('20200118000622'),
('20200118201501'),
('20200119192255'),
('20200131171456'),
('20200221232045'),
('20200222224002'),
('20200223204523'),
('20200225070555'),
('20200229052054'),
('20200229053148'),
('20200229114848'),
('20200301120149'),
('20200305092313'),
('20200305192127'),
('20200310192546'),
('20200317092334'),
('20200405173634'),
('20200406000415'),
('20200407165401'),
('20200407183907'),
('20200410005704'),
('20200410021818'),
('20200417022050'),
('20200420060723'),
('20200426013206'),
('20200426033608'),
('20200426092251'),
('20200506095205'),
('20200513204030'),
('20200525022434'),
('20200602133029'),
('20200603162452'),
('20200604180231'),
('20200613233942'),
('20200613235248'),
('20200615212030'),
('20200615222549'),
('20200616003446'),
('20200616103242'),
('20200617023543'),
('20200624064838'),
('20200626125809'),
('20200629164722'),
('20200630113358'),
('20200630141818'),
('20200630161825'),
('20200630192522'),
('20200630205225'),
('20200630220333'),
('20200630223715'),
('20200701133723'),
('20200705150209'),
('20200715003410'),
('20200715034355'),
('20200719214711'),
('20200722151132'),
('20200722221907'),
('20200722233313'),
('20200723011130'),
('20200723030449'),
('20200828043028'),
('20200903144149'),
('20200908062614'),
('20200911062229'),
('20200914113651'),
('20200914144201'),
('20200916052649'),
('20200918212506'),
('20200922124235'),
('20200923045825'),
('20200923060320'),
('20200925050217'),
('20200929162556'),
('20201007134635'),
('20201110132337'),
('20201210160135'),
('20201225213003'),
('20210118192309'),
('20210128050645'),
('20210203192622'),
('20210205083649'),
('20210210173529'),
('20210211082102'),
('20210211121353'),
('20210211201513'),
('20210216123812'),
('20210219194005'),
('20210219221153'),
('20210222204415'),
('20210222204529'),
('20210226200129'),
('20210226200705'),
('20210226201238'),
('20210226220020'),
('20210226220403'),
('20210226223208'),
('20210301091555'),
('20210306222201'),
('20210309155436'),
('20210309175424'),
('20210311181533'),
('20210311184609'),
('20210311184928'),
('20210312165913'),
('20210315233431'),
('20210316121459'),
('20210317135216'),
('20210320105303'),
('20210321120504'),
('20210323154622'),
('20210323174434'),
('20210323180114'),
('20210323180130'),
('20210326130422'),
('20210329160613'),
('20210329192005'),
('20210331224316'),
('20210401163159'),
('20210401163637'),
('20210401192628'),
('20210404131222'),
('20210407003049'),
('20210408131105'),
('20210410142233'),
('20210415142648'),
('20210423114454'),
('20210502165601'),
('20210505154804'),
('20210508134939'),
('20210516095619'),
('20210518154715');


