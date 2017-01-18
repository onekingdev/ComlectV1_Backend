WITH
  active AS (
    SELECT created_at
    FROM projects
    WHERE status = 'published'
  ),
  project_value AS (
    SELECT
      projects.created_at,
      projects.type,
      project_id,
      amount_in_cents / 100::float AS value,
      -- Multiply revenue by 2 because a fee is taken both from the amount paid by business and what the specialists actually get
      (fee_in_cents / 100.0) * 2 AS revenue
    FROM charges
    INNER JOIN projects ON projects.id = charges.project_id
    WHERE projects.type = 'one_off' AND charges.status <> 'processed'
  ),
  job_value AS (
    SELECT
      projects.created_at,
      projects.type,
      project_id,
      projects.annual_salary AS value,
      fee_in_cents / 100.0 AS revenue
    FROM charges
    INNER JOIN projects ON projects.id = charges.project_id
    WHERE projects.type = 'full_time' AND charges.status <> 'processed'
  ),
  all_value AS (
    SELECT
      projects.created_at,
      projects.type,
      project_id,
      amount_in_cents / 100::float AS value,
      -- Multiply revenue by 2 because a fee is taken both from the amount paid by business and what the specialists actually get
      (fee_in_cents / 100.0) * (CASE WHEN projects.type = 'one_off' THEN 2 ELSE 1 END) AS revenue
    FROM charges
    INNER JOIN projects ON projects.id = charges.project_id
    WHERE charges.status <> 'processed'
  ),
  job_revenue AS (
    SELECT project_id, created_at, revenue FROM all_value WHERE type = 'full_time'
  ),
  project_revenue AS (
    SELECT * FROM all_value WHERE type = 'one_off'
  )

SELECT 'forecasted_completed'::varchar AS metric,
  (SELECT COUNT(*) FROM active WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM active WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM active) AS itd

UNION SELECT 'forecasted_value'::varchar AS metric,
  (SELECT SUM(value) FROM all_value WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT SUM(value) FROM all_value WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT SUM(value) FROM all_value) AS itd

UNION SELECT 'forecasted_revenue'::varchar AS metric,
  (SELECT SUM(revenue) FROM all_value WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT SUM(revenue) FROM all_value WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT SUM(revenue) FROM all_value) AS itd

UNION SELECT 'forecasted_revenue_per_job'::varchar AS metric,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM job_revenue WHERE created_at >= date_trunc('month', now()) GROUP BY project_id) rev) AS mtd,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM job_revenue WHERE created_at >= date_trunc('year', now()) GROUP BY project_id) rev) AS fytd,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM job_revenue GROUP BY project_id) rev) AS itd

UNION SELECT 'forecasted_revenue_per_project'::varchar AS metric,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM project_revenue WHERE created_at >= date_trunc('month', now()) GROUP BY project_id) rev) AS mtd,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM project_revenue WHERE created_at >= date_trunc('year', now()) GROUP BY project_id) rev) AS fytd,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM project_revenue GROUP BY project_id) rev) AS itd

UNION SELECT 'forecasted_job_share'::varchar AS metric,
  (mtd.revenue / t_mtd.revenue::float) * 100 AS mtd,
  (fytd.revenue / t_fytd.revenue::float) * 100 AS fytd,
  (itd.revenue / t_itd.revenue::float) * 100 AS itd
FROM
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'full_time' AND created_at >= date_trunc('month', now())) AS mtd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'full_time' AND created_at >= date_trunc('year', now())) AS fytd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'full_time') AS itd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE created_at >= date_trunc('month', now())) AS t_mtd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE created_at >= date_trunc('year', now())) AS t_fytd,
  (SELECT SUM(revenue) AS revenue FROM all_value) AS t_itd

UNION SELECT 'forecasted_project_share'::varchar AS metric,
  (mtd.revenue / t_mtd.revenue::float) * 100 AS mtd,
  (fytd.revenue / t_fytd.revenue::float) * 100 AS fytd,
  (itd.revenue / t_itd.revenue::float) * 100 AS itd
FROM
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'one_off' AND created_at >= date_trunc('month', now())) AS mtd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'one_off' AND created_at >= date_trunc('year', now())) AS fytd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'one_off') AS itd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE created_at >= date_trunc('month', now())) AS t_mtd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE created_at >= date_trunc('year', now())) AS t_fytd,
  (SELECT SUM(revenue) AS revenue FROM all_value) AS t_itd
