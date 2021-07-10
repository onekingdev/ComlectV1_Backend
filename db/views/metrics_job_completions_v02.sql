WITH
    full_time AS (SELECT completed_at, published_at, pricing_type, fee_type
                  FROM projects
                  WHERE type = 'full_time'),
    all_completed AS (SELECT completed_at, pricing_type, payment_schedule, published_at
                      FROM projects
                      WHERE completed_at IS NOT NULL),
    published AS (SELECT * FROM full_time WHERE published_at IS NOT NULL),
    completed AS (SELECT * FROM full_time WHERE completed_at IS NOT NULL),
    upfront_fee AS (SELECT * FROM completed WHERE fee_type = 'upfront_fee'),
    monthly_fee AS (SELECT * FROM completed WHERE fee_type = 'monthly_fee')

SELECT 'completed_jobs'::varchar AS metric,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM completed) AS itd

UNION SELECT 'completed_jobs_share'::varchar AS metric,
  (mtd.cnt::float / total_mtd.cnt) * 100 AS mtd,
  (fytd.cnt::float / total_fytd.cnt) * 100 AS fytd,
  (itd.cnt::float / total_itd.cnt) * 100 AS itd
FROM
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM full_time) AS total,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM published WHERE published_at >= date_trunc('month', now())) AS total_mtd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM published WHERE published_at >= date_trunc('year', now())) AS total_fytd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM completed) AS itd,
  (SELECT NULLIF(COUNT(*), 0) AS cnt FROM published) AS total_itd

UNION SELECT 'completed_jobs_all_share'::varchar AS metric,
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

UNION SELECT 'completed_jobs_upfront_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM upfront_fee WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM upfront_fee WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM upfront_fee) AS itd

UNION SELECT 'completed_jobs_monthly_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM monthly_fee WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM monthly_fee WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM monthly_fee) AS itd
