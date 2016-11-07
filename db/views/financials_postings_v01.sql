WITH
  active AS (
    SELECT created_at
    FROM projects
    WHERE completed_at IS NULL
  ),
  all_projects AS (
    SELECT
      created_at,
      type,
      pricing_type,
      calculated_budget,
      annual_salary,
      fee_type
    FROM projects
  ),
  job_value AS (
    SELECT
      calculated_budget * (CASE WHEN fee_type = 'upfront_fee' THEN 1.15 ELSE 1.18 END) AS value
    FROM all_projects
    WHERE type = 'full_time'
  ),
  job_revenue AS (
    SELECT
      calculated_budget * (CASE WHEN fee_type = 'upfront_fee' THEN 0.15 ELSE 0.18 END) AS revenue
    FROM all_projects
    WHERE type = 'full_time'
  ),
  project_value AS (
    SELECT
      created_at,
      calculated_budget * 1.20 AS value
    FROM all_projects
    WHERE type = 'one_off'
  ),
  project_revenue AS (
    SELECT
      calculated_budget * 0.2 AS revenue
    FROM all_projects
    WHERE type = 'one_off'
  ),
  all_value AS (
    SELECT COALESCE(a.value, 0) + COALESCE(b.value, 0) AS value
    FROM
    (SELECT SUM(value) AS value FROM job_value) AS a,
    (SELECT SUM(value) AS value FROM project_value) AS b
  ),
  all_revenue AS (
    SELECT COALESCE(a.revenue, 0) + COALESCE(b.revenue, 0) AS revenue
    FROM
    (SELECT SUM(revenue) AS revenue FROM job_revenue) AS a,
    (SELECT SUM(revenue) AS revenue FROM project_revenue) AS b
  )

SELECT 'postings_value'::varchar AS metric,
  (SELECT SUM(value) FROM all_value) AS value

UNION SELECT 'postings_revenue'::varchar AS metric,
  (SELECT SUM(revenue) FROM all_revenue) AS value

UNION SELECT 'postings_revenue_per_job'::varchar AS metric,
  (SELECT AVG(revenue) FROM job_revenue) AS value

UNION SELECT 'postings_revenue_per_project'::varchar AS metric,
  (SELECT AVG(revenue) FROM project_revenue) AS value

UNION SELECT 'postings_job_share'::varchar AS metric,
  (j.revenue / a.revenue) * 100 AS value
FROM
  (SELECT COALESCE(SUM(revenue), 0) AS revenue FROM all_revenue) AS a,
  (SELECT COALESCE(SUM(revenue), 0) AS revenue FROM job_revenue) AS j

UNION SELECT 'postings_project_share'::varchar AS metric,
  (p.revenue / a.revenue) * 100 AS value
FROM
  (SELECT COALESCE(SUM(revenue), 0) AS revenue FROM all_revenue) AS a,
  (SELECT COALESCE(SUM(revenue), 0) AS revenue FROM project_revenue) AS p
