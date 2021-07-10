WITH
    full_time AS (SELECT completed_at, published_at, pricing_type, fee_type
                  FROM projects
                  WHERE type = 'full_time'),
    completed AS (SELECT * FROM full_time WHERE completed_at IS NOT NULL),
    upfront_fee AS (SELECT * FROM completed WHERE fee_type = 'upfront_fee'),
    monthly_fee AS (SELECT * FROM completed WHERE fee_type = 'monthly_fee')

SELECT 'completed_jobs'::varchar AS metric,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM completed) AS itd

UNION SELECT 'completed_jobs_share'::varchar AS metric,
  (mtd.cnt::float / total.cnt) * 100 AS mtd,
  (fytd.cnt::float / total.cnt) * 100 AS fytd,
  (itd.cnt::float / total.cnt) * 100 AS itd
FROM
  (SELECT COUNT(*) AS cnt FROM full_time) AS total,
  (SELECT COUNT(*) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) AS cnt FROM completed) AS itd

UNION SELECT 'completed_jobs_all_share'::varchar AS metric,
  (mtd.cnt::float / total.cnt) * 100 AS mtd,
  (fytd.cnt::float / total.cnt) * 100 AS fytd,
  (itd.cnt::float / total.cnt) * 100 AS itd
FROM
  (SELECT COUNT(*) AS cnt FROM projects) AS total,
  (SELECT COUNT(*) AS cnt FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) AS cnt FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) AS cnt FROM completed) AS itd

UNION SELECT 'completed_jobs_upfront_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM upfront_fee WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM upfront_fee WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM upfront_fee) AS itd

UNION SELECT 'completed_jobs_monthly_pay'::varchar AS metric,
  (SELECT COUNT(*) FROM monthly_fee WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM monthly_fee WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM monthly_fee) AS itd
