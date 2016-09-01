SELECT
  'projects_hourly_pay'::varchar AS metric,
  mtd.cnt AS mtd,
  fytd.cnt AS fytd,
  itd.cnt AS itd
FROM
(SELECT COUNT(*) AS cnt
 FROM projects
 WHERE type = 'one_off' AND pricing_type = 'hourly' AND
       created_at::date >= DATE(date_part('year', current_date) || '-' || date_part('month', current_date) || '-01')
) AS mtd,
(SELECT COUNT(*) AS cnt
 FROM projects
 WHERE type = 'one_off' AND pricing_type = 'hourly' AND
       created_at::date >= (
       CASE
       WHEN current_date >= DATE(date_part('year', current_date) || '/10/01') THEN
         DATE(date_part('year', current_date) || '/10/01')::text
       ELSE
         DATE((date_part('year', current_date) - 1) || '/10/01')::text
       END
     )::date
) AS fytd,
(SELECT COUNT(*) AS cnt
 FROM projects
 WHERE type = 'one_off' AND pricing_type = 'hourly'
) AS itd
