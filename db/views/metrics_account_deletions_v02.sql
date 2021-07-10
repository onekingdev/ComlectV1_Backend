-- This view is identical to the previous version because somehow the structure.sql file had the wrong view
-- so we recreate it here for upgrading/fixing
WITH
  deleted_users AS (
    SELECT id, deleted_at
    FROM users
    WHERE deleted_at IS NOT NULL
  ),
  deleted_businesses AS (
    SELECT deleted_at
    FROM deleted_users
    INNER JOIN businesses ON businesses.user_id = deleted_users.id
  ),
  deleted_specialists AS (
    SELECT deleted_at
    FROM deleted_users
    INNER JOIN specialists ON specialists.user_id = deleted_users.id
  )

SELECT 'all_account_deletions'::varchar AS metric,
  (SELECT COUNT(*) FROM deleted_users WHERE deleted_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM deleted_users WHERE deleted_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM deleted_users) AS itd

UNION SELECT 'business_account_deletions'::varchar AS metric,
  (SELECT COUNT(*) FROM deleted_businesses WHERE deleted_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM deleted_businesses WHERE deleted_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM deleted_businesses) AS itd

UNION SELECT 'specialist_account_deletions'::varchar AS metric,
  (SELECT COUNT(*) FROM deleted_specialists WHERE deleted_at >= date_trunc('month', now())) AS mtd,
  (SELECT COUNT(*) FROM deleted_specialists WHERE deleted_at >= date_trunc('year', now())) AS fytd,
  (SELECT COUNT(*) FROM deleted_specialists) AS itd
