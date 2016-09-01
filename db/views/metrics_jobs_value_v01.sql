SELECT
  'jobs_value'::varchar AS metric,
  mtd.avg AS mtd,
  fytd.avg AS fytd,
  itd.avg AS itd
FROM
(SELECT
    AVG(annual_salary) AS avg
    FROM projects
    WHERE type = 'full_time' AND created_at::date >= DATE(date_part('year', current_date) || '-' || date_part('month', current_date) || '-01')
) AS mtd,
(SELECT
    AVG(annual_salary) AS avg
    FROM projects
    WHERE type = 'full_time' AND created_at::date >= (CASE
      WHEN current_date >= DATE(date_part('year', current_date) || '/10/01') THEN DATE(date_part('year', current_date) || '/10/01')::text
      ELSE DATE((date_part('year', current_date) - 1) || '/10/01')::text
    END)::date
) AS fytd,
(SELECT
    AVG(annual_salary) AS avg
    FROM projects
    WHERE type = 'full_time'
) AS itd
