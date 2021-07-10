WITH base AS (
  SELECT created_at
  FROM projects
  WHERE type = 'one_off' AND pricing_type = 'hourly'
)
SELECT
  'projects_hourly_share'::varchar AS metric,
  (mtd.cnt::float / total_mtd.cnt) * 100 AS mtd,
  (fytd.cnt::float / total_fytd.cnt) * 100 AS fytd,
  (itd.cnt::float / total_itd.cnt) * 100 AS itd
FROM
  (SELECT COUNT(*) AS cnt FROM projects WHERE type = 'one_off' AND created_at >= date_trunc('month', now())) AS total_mtd,
  (SELECT COUNT(*) AS cnt FROM projects WHERE type = 'one_off' AND created_at >= date_trunc('year', now())) AS total_fytd,
  (SELECT COUNT(*) AS cnt FROM projects WHERE type = 'one_off') AS total_itd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM base WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM base WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM base) AS itd
