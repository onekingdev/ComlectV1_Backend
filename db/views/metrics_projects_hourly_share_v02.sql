-- ftyd actually means calendar year to date so lets do that instead of using october 1st
WITH base AS (
  SELECT created_at
  FROM projects
  WHERE type = 'one_off' AND pricing_type = 'hourly'
)
SELECT
  'projects_hourly_share'::varchar AS metric,
  (mtd.cnt::float / total.cnt) * 100 AS mtd,
  (fytd.cnt::float / total.cnt) * 100 AS fytd,
  (itd.cnt::float / total.cnt) * 100 AS itd
FROM
  (SELECT COUNT(*) AS cnt FROM projects WHERE type = 'one_off') AS total,
  (SELECT COUNT(*) AS cnt FROM base WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) AS cnt FROM base WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) AS cnt FROM base) AS itd
