WITH
  completed AS (
    SELECT completed_at
    FROM projects
    WHERE completed_at IS NOT NULL
  ),
  all_value AS (
    SELECT
      projects.completed_at,
      projects.type,
      project_id,
      amount_in_cents / 100.0 AS value,
      fee_in_cents / 100.0 AS revenue,
      total_with_fee_in_cents / 100.0 AS total
    FROM charges
    INNER JOIN projects ON projects.id = charges.project_id
  ),
  job_revenue AS (
    SELECT project_id, completed_at, revenue FROM all_value WHERE type = 'full_time'
  ),
  project_revenue AS (
    SELECT * FROM all_value WHERE type = 'one_off'
  )

SELECT 'actual_completed'::varchar AS metric,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM completed) AS itd

UNION SELECT 'actual_value'::varchar AS metric,
  (SELECT SUM(total) FROM all_value WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT SUM(total) FROM all_value WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT SUM(total) FROM all_value) AS itd

UNION SELECT 'actual_revenue'::varchar AS metric,
  (SELECT SUM(revenue) FROM all_value WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT SUM(revenue) FROM all_value WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT SUM(revenue) FROM all_value) AS itd

UNION SELECT 'actual_revenue_per_job'::varchar AS metric,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM job_revenue WHERE completed_at >= date_trunc('month', now()) GROUP BY project_id) rev) AS mtd,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM job_revenue WHERE completed_at >= date_trunc('year', now()) GROUP BY project_id) rev) AS fytd,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM job_revenue GROUP BY project_id) rev) AS itd

UNION SELECT 'actual_revenue_per_project'::varchar AS metric,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM project_revenue WHERE completed_at >= date_trunc('month', now()) GROUP BY project_id) rev) AS mtd,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM project_revenue WHERE completed_at >= date_trunc('year', now()) GROUP BY project_id) rev) AS fytd,
  (SELECT AVG(rev.revenue) FROM (SELECT AVG(revenue) AS revenue FROM project_revenue GROUP BY project_id) rev) AS itd

UNION SELECT 'actual_job_share'::varchar AS metric,
  (mtd.revenue / t_mtd.revenue::float) * 100 AS mtd,
  (fytd.revenue / t_fytd.revenue::float) * 100 AS fytd,
  (itd.revenue / t_itd.revenue::float) * 100 AS itd
FROM
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'full_time' AND completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'full_time' AND completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'full_time') AS itd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE completed_at >= date_trunc('month', now())) AS t_mtd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE completed_at >= date_trunc('year', now())) AS t_fytd,
  (SELECT SUM(revenue) AS revenue FROM all_value) AS t_itd

UNION SELECT 'actual_project_share'::varchar AS metric,
  (mtd.revenue / t_mtd.revenue::float) * 100 AS mtd,
  (fytd.revenue / t_fytd.revenue::float) * 100 AS fytd,
  (itd.revenue / t_itd.revenue::float) * 100 AS itd
FROM
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'one_off' AND completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'one_off' AND completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE type = 'one_off') AS itd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE completed_at >= date_trunc('month', now())) AS t_mtd,
  (SELECT SUM(revenue) AS revenue FROM all_value WHERE completed_at >= date_trunc('year', now())) AS t_fytd,
  (SELECT SUM(revenue) AS revenue FROM all_value) AS t_itd
