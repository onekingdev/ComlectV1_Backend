-- ftyd actually means calendar year to date so lets do that instead of using october 1st
WITH base AS (
  SELECT created_at, annual_salary FROM projects WHERE type = 'full_time'
)
SELECT
  'jobs_value'::varchar AS metric,
  (SELECT AVG(annual_salary) FROM base WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT AVG(annual_salary) FROM base WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT AVG(annual_salary) FROM base) AS itd
