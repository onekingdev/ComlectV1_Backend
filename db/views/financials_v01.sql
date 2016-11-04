WITH
  completed AS (
    SELECT completed_at
    FROM projects
    WHERE completed_at IS NOT NULL
  ),
  all_value AS (
    SELECT projects.completed_at, (amount_in_cents - fee_in_cents) / 100 AS value
    FROM transactions
    INNER JOIN projects ON projects.id = transactions.project_id
    WHERE transactions.type = 'Transaction::BusinessCharge'
    GROUP BY project_id
  )

SELECT 'all_completed'::varchar AS metric,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM completed WHERE completed_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM completed) AS itd

UNION SELECT 'all_value'::varchar AS metric,
  (SELECT SUM(value) FROM all_value WHERE )
