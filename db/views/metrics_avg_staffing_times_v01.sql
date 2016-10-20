WITH
  one_off AS (SELECT published_at, hired_at FROM projects WHERE type = 'one_off'),
  full_time AS (SELECT published_at, hired_at FROM projects WHERE type = 'full_time')

SELECT 'avg_staffing_time'::varchar AS metric,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM projects WHERE hired_at >= date_trunc('month', now())) AS mtd,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM projects WHERE hired_at >= date_trunc('year', now())) AS fytd,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM projects) AS itd

UNION SELECT 'avg_project_staffing_time'::varchar AS metric,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM one_off WHERE hired_at >= date_trunc('month', now())) AS mtd,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM one_off WHERE hired_at >= date_trunc('year', now())) AS fytd,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM one_off) AS itd

UNION SELECT 'avg_job_staffing_time'::varchar AS metric,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM full_time WHERE hired_at >= date_trunc('month', now())) AS mtd,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM full_time WHERE hired_at >= date_trunc('year', now())) AS fytd,
  (SELECT AVG(EXTRACT(days from hired_at - published_at)) FROM full_time) AS itd
