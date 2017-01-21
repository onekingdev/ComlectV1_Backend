SELECT 'extended_projects'::varchar AS metric,
  (SELECT COUNT(*) FROM projects WHERE extended_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM projects WHERE extended_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM projects WHERE extended_at IS NOT NULL) AS itd
