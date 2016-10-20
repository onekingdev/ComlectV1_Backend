SELECT 'all_signups'::varchar AS metric,
  (SELECT COUNT(*) FROM users WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM users WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM users) AS itd

UNION SELECT 'business_signups'::varchar AS metric,
  (SELECT COUNT(*) FROM businesses WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM businesses WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM businesses) AS itd

UNION SELECT 'specialist_signups'::varchar AS metric,
  (SELECT COUNT(*) FROM specialists WHERE created_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM specialists WHERE created_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM specialists) AS itd
