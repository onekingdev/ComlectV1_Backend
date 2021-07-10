SELECT * FROM metrics_projects_posted
UNION
SELECT * FROM metrics_projects_value
UNION
SELECT * FROM metrics_projects_share
UNION
SELECT * FROM metrics_projects_hourly_share
UNION
SELECT * FROM metrics_projects_fixed_share
UNION
SELECT * FROM metrics_projects_hourly_pay
UNION
SELECT * FROM metrics_projects_hourly_upon_completion_pay
UNION
SELECT * FROM metrics_projects_hourly_bi_weekly_pay
UNION
SELECT * FROM metrics_projects_hourly_monthly_pay
UNION
SELECT * FROM metrics_projects_fixed_pay
UNION
SELECT * FROM metrics_projects_fixed_50_50_pay
UNION
SELECT * FROM metrics_projects_fixed_upon_completion_pay
UNION
SELECT * FROM metrics_projects_fixed_bi_weekly_pay
UNION
SELECT * FROM metrics_projects_fixed_monthly_pay
UNION
SELECT * FROM metrics_jobs_posted
UNION
SELECT * FROM metrics_jobs_value
UNION
SELECT * FROM metrics_jobs_share
UNION
SELECT * FROM metrics_jobs_upfront_pay
UNION
SELECT * FROM metrics_jobs_installment_pay
