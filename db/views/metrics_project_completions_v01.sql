WITH
  one_off AS (SELECT completed_at, pricing_type, payment_schedule
              FROM projects
              WHERE type = 'one_off' AND status = 'complete'),
  completed AS (SELECT * FROM one_off WHERE completed_at IS NOT NULL),
  hourly AS (SELECT * FROM completed WHERE pricing_type = 'hourly'),
  fixed AS (SELECT * FROM completed WHERE pricing_type = 'fixed'),
  hourly_upon_completion AS (SELECT * FROM hourly WHERE payment_schedule = 'Upon Completion'),
  hourly_bi_weekly AS (SELECT * FROM hourly WHERE payment_schedule = 'Bi-Weekly'),
  hourly_monthly AS (SELECT * FROM hourly WHERE payment_schedule = 'Monthly'),
  fixed_upon_completion AS (SELECT * FROM fixed WHERE payment_schedule = 'Upon Completion'),
  fixed_bi_weekly AS (SELECT * FROM fixed WHERE payment_schedule = 'Bi-Weekly'),
  fixed_monthly AS (SELECT * FROM fixed WHERE payment_schedule = 'Monthly'),
  fixed_50_50 AS (SELECT * FROM fixed WHERE payment_schedule = '50/50')

SELECT 'completed_projects'::varchar AS metric,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM completed) AS itd

UNION SELECT 'completed_projects_share'::varchar AS metric,
  (mtd.cnt::float / total.cnt) * 100 AS mtd,
  (fytd.cnt::float / total.cnt) * 100 AS fytd,
  (itd.cnt::float / total.cnt) * 100 AS itd
FROM
  (SELECT COUNT(*) AS cnt FROM one_off) AS total,
  (SELECT COUNT(*) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) AS cnt FROM completed) AS itd

UNION SELECT 'completed_projects_all_share'::varchar AS metric,
  (mtd.cnt::float / total.cnt) * 100 AS mtd,
  (fytd.cnt::float / total.cnt) * 100 AS fytd,
  (itd.cnt::float / total.cnt) * 100 AS itd
FROM
  (SELECT COUNT(*) AS cnt FROM projects) AS total,
  (SELECT COUNT(*) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) AS cnt FROM completed) AS itd

UNION SELECT 'completed_projects_hourly_share'::varchar AS metric,
  (mtd.cnt::float / total.cnt) * 100 AS mtd,
  (fytd.cnt::float / total.cnt) * 100 AS fytd,
  (itd.cnt::float / total.cnt) * 100 AS itd
FROM
  (SELECT COUNT(*) AS cnt FROM one_off) AS total,
  (SELECT COUNT(*) AS cnt FROM hourly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) AS cnt FROM hourly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) AS cnt FROM hourly) AS itd

UNION SELECT 'completed_projects_fixed_share'::varchar AS metric,
  (mtd.cnt::float / total.cnt) * 100 AS mtd,
  (fytd.cnt::float / total.cnt) * 100 AS fytd,
  (itd.cnt::float / total.cnt) * 100 AS itd
FROM
  (SELECT COUNT(*) AS cnt FROM completed) AS total,
  (SELECT COUNT(*) AS cnt FROM fixed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) AS cnt FROM fixed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) AS cnt FROM fixed) AS itd

UNION SELECT 'completed_projects_hourly_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM hourly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM hourly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM hourly) AS itd

UNION SELECT 'completed_projects_hourly_upon_completion_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM hourly_upon_completion WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM hourly_upon_completion WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM hourly_upon_completion) AS itd

UNION SELECT 'completed_projects_hourly_bi_weekly_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM hourly_bi_weekly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM hourly_bi_weekly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM hourly_bi_weekly) AS itd

UNION SELECT 'completed_projects_hourly_monthly_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM hourly_monthly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM hourly_monthly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM hourly_monthly) AS itd

UNION SELECT 'completed_projects_fixed_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM fixed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM fixed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM fixed) AS itd

UNION SELECT 'completed_projects_fixed_upon_completion_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM fixed_upon_completion WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM fixed_upon_completion WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM fixed_upon_completion) AS itd

UNION SELECT 'completed_projects_fixed_bi_weekly_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM fixed_bi_weekly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM fixed_bi_weekly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM fixed_bi_weekly) AS itd

UNION SELECT 'completed_projects_fixed_monthly_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM fixed_monthly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM fixed_monthly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM fixed_monthly) AS itd

UNION SELECT 'completed_projects_fixed_50_50_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM fixed_50_50 WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM fixed_50_50 WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM fixed_50_50) AS itd
