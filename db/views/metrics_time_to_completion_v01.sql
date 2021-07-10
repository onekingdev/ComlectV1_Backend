WITH
    one_off AS (SELECT hired_at, completed_at
                FROM projects
                WHERE type = 'one_off' AND status = 'complete'),
    full_time AS (SELECT hired_at, completed_at
                  FROM projects
                  WHERE type = 'full_time' AND status = 'complete')

SELECT 'completed_projects_average_time'::varchar AS metric,
  (SELECT AVG(EXTRACT(days from completed_at - hired_at)) FROM one_off WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT AVG(EXTRACT(days from completed_at - hired_at)) FROM one_off WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT AVG(EXTRACT(days from completed_at - hired_at)) FROM one_off) AS itd

UNION

SELECT 'completed_jobs_average_time'::varchar AS metric,
  (SELECT AVG(EXTRACT(days from completed_at - hired_at)) FROM full_time WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT AVG(EXTRACT(days from completed_at - hired_at)) FROM full_time WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT AVG(EXTRACT(days from completed_at - hired_at)) FROM full_time) AS itd
