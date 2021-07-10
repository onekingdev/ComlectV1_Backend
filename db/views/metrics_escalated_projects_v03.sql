WITH escalated_projects AS (
  SELECT created_at AS escalated_at
  FROM project_issues
)

SELECT 'escalated_projects'::varchar AS metric,
  (SELECT COUNT(*) FROM escalated_projects WHERE escalated_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM escalated_projects WHERE escalated_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM escalated_projects) AS itd
