-- ftyd actually means calendar year to date so lets do that instead of using october 1st
WITH base AS (
  SELECT created_at FROM projects WHERE type = 'one_off'
)
SELECT
  'projects_posted'::varchar AS metric,
  (SELECT COUNT(*) FROM base WHERE created_at >= date_trunc('month', now())) AS mtd, 
  (SELECT COUNT(*) FROM base WHERE created_at >= date_trunc('year', now())) AS fytd, 
  (SELECT COUNT(*) FROM base) AS itd 
