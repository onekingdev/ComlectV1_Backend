WITH
  dates AS (
    SELECT now() - INTERVAL '30 days' AS thirty_days_ago
  ),
  totals AS (
    SELECT COUNT(*) AS cnt FROM users
  ),
  all_users AS (
    SELECT current_sign_in_at FROM users
  ),
  businesses_count AS (
    SELECT current_sign_in_at
    FROM users
    INNER JOIN businesses ON businesses.user_id = users.id
  ),
  specialists_count AS (
    SELECT current_sign_in_at
    FROM users
    INNER JOIN specialists ON specialists.user_id = users.id
  )

SELECT 'recent_activity'::varchar AS metric,
  (SELECT COUNT(*) FROM users WHERE current_sign_in_at >= thirty_days_ago) AS cnt,
  (SELECT COUNT(*)::float / totals.cnt * 100 FROM users WHERE current_sign_in_at >= thirty_days_ago) AS pct
FROM totals, dates

UNION SELECT 'recent_activity_businesses'::varchar AS metric,
  (SELECT COUNT(*) FROM businesses_count WHERE current_sign_in_at >= thirty_days_ago) AS cnt,
  (SELECT COUNT(*)::float / totals.cnt * 100 FROM businesses_count WHERE current_sign_in_at >= thirty_days_ago) AS pct
FROM totals, businesses_count, dates

UNION SELECT 'recent_activity_specialists'::varchar AS metric,
  (SELECT COUNT(*) FROM specialists_count WHERE current_sign_in_at >= thirty_days_ago) AS cnt,
  (SELECT COUNT(*)::float / totals.cnt * 100 FROM specialists_count WHERE current_sign_in_at >= thirty_days_ago) AS pct
FROM totals, specialists_count, dates

UNION SELECT 'old_activity'::varchar AS metric,
  (SELECT COUNT(*) FROM users WHERE current_sign_in_at IS NULL OR current_sign_in_at < thirty_days_ago) AS cnt,
  (SELECT COUNT(*)::float / totals.cnt * 100 FROM users WHERE current_sign_in_at IS NULL OR current_sign_in_at < thirty_days_ago) AS pct
FROM totals, dates

UNION SELECT 'old_activity_businesses'::varchar AS metric,
  (SELECT COUNT(*) FROM businesses_count WHERE current_sign_in_at IS NULL OR current_sign_in_at < thirty_days_ago) AS cnt,
  (SELECT COUNT(*)::float / totals.cnt * 100 FROM businesses_count WHERE current_sign_in_at IS NULL OR current_sign_in_at < thirty_days_ago) AS pct
FROM totals, businesses_count, dates

UNION SELECT 'old_activity_specialists'::varchar AS metric,
  (SELECT COUNT(*) FROM specialists_count WHERE current_sign_in_at IS NULL OR current_sign_in_at < thirty_days_ago) AS cnt,
  (SELECT COUNT(*)::float / totals.cnt * 100 FROM specialists_count WHERE current_sign_in_at IS NULL OR current_sign_in_at < thirty_days_ago) AS pct
FROM totals, specialists_count, dates

UNION SELECT 'all_activity_businesses'::varchar AS metric,
  (SELECT COUNT(*) FROM businesses_count) AS cnt,
  (SELECT COUNT(*)::float / totals.cnt * 100 FROM businesses_count) AS pct
FROM totals, dates

UNION SELECT 'all_activity_specialists'::varchar AS metric,
  (SELECT COUNT(*) FROM specialists_count) AS cnt,
  (SELECT COUNT(*)::float / totals.cnt * 100 FROM specialists_count) AS pct
FROM totals, dates
