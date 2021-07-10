-- ftyd actually means calendar year to date so lets do that instead of using october 1st
WITH base AS (
  SELECT created_at, fixed_budget, hourly_rate, estimated_hours
  FROM projects
  WHERE type = 'one_off'
)
SELECT
  'projects_value'::varchar AS metric,
  mtd.avg AS mtd,
  fytd.avg AS fytd,
  itd.avg AS itd
FROM
  (SELECT AVG(COALESCE(fixed_budget, hourly_rate * estimated_hours)) FROM base WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT AVG(COALESCE(fixed_budget, hourly_rate * estimated_hours)) FROM base WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT AVG(COALESCE(fixed_budget, hourly_rate * estimated_hours)) FROM base) AS itd
