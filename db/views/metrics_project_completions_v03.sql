WITH
  one_off AS (SELECT completed_at, pricing_type, payment_schedule, published_at
              FROM projects
              WHERE type = 'one_off'),
  all_completed AS (SELECT completed_at, pricing_type, payment_schedule, published_at
              FROM projects
              WHERE completed_at IS NOT NULL),
  published AS (SELECT * FROM one_off WHERE published_at IS NOT NULL),
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
  (SELECT NULLIF(COUNT(*), 0) FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM completed) AS itd

UNION SELECT 'completed_projects_share'::varchar AS metric,
  (mtd.cnt::float / total_mtd.cnt) * 100 AS mtd,
  (fytd.cnt::float / total_fytd.cnt) * 100 AS fytd,
  (itd.cnt::float / total_itd.cnt) * 100 AS itd
FROM
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM one_off) AS total,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM published WHERE published_at >= date_trunc('month', now())) AS total_mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM published WHERE published_at >= date_trunc('year', now())) AS total_fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed) AS itd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM published) AS total_itd

UNION SELECT 'completed_projects_all_share'::varchar AS metric,
  (mtd.cnt::float / total_mtd.cnt) * 100 AS mtd,
  (fytd.cnt::float / total_fytd.cnt) * 100 AS fytd,
  (itd.cnt::float / total_itd.cnt) * 100 AS itd
FROM
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM all_completed WHERE completed_at >= date_trunc('month', now())) AS total_mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM all_completed WHERE completed_at >= date_trunc('year', now())) AS total_fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed) AS itd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM all_completed) AS total_itd

UNION SELECT 'completed_projects_hourly_share'::varchar AS metric,
  (mtd.cnt::float / total_mtd.cnt) * 100 AS mtd,
  (fytd.cnt::float / total_fytd.cnt) * 100 AS fytd,
  (itd.cnt::float / total_itd.cnt) * 100 AS itd
FROM
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM hourly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS total_mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM hourly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS total_fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM hourly) AS itd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed) AS total_itd

UNION SELECT 'completed_projects_fixed_share'::varchar AS metric,
  (mtd.cnt::float / total_mtd.cnt) * 100 AS mtd,
  (fytd.cnt::float / total_fytd.cnt) * 100 AS fytd,
  (itd.cnt::float / total_itd.cnt) * 100 AS itd
FROM
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM fixed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS total_mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM fixed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS total_fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM fixed) AS itd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed) AS total_itd

UNION SELECT 'completed_projects_hourly_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly) AS itd

UNION SELECT 'completed_projects_hourly_upon_completion_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_upon_completion WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_upon_completion WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_upon_completion) AS itd

UNION SELECT 'completed_projects_hourly_bi_weekly_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_bi_weekly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_bi_weekly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_bi_weekly) AS itd

UNION SELECT 'completed_projects_hourly_monthly_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_monthly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_monthly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM hourly_monthly) AS itd

UNION SELECT 'completed_projects_fixed_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed) AS itd

UNION SELECT 'completed_projects_fixed_upon_completion_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_upon_completion WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_upon_completion WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_upon_completion) AS itd

UNION SELECT 'completed_projects_fixed_bi_weekly_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_bi_weekly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_bi_weekly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_bi_weekly) AS itd

UNION SELECT 'completed_projects_fixed_monthly_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_monthly WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_monthly WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_monthly) AS itd

UNION SELECT 'completed_projects_fixed_50_50_pay'::varchar AS metric,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_50_50 WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_50_50 WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) FROM fixed_50_50) AS itd
