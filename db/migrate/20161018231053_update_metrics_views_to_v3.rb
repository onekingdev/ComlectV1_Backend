# frozen_string_literal: true
class UpdateMetricsViewsToV3 < ActiveRecord::Migration
  # rubocop:disable Metrics/MethodLength
  def change
    replace_view :metrics_jobs_installment_pay, version: 3, revert_to_version: 2
    replace_view :metrics_jobs_posted, version: 2, revert_to_version: 1
    replace_view :metrics_jobs_share, version: 2, revert_to_version: 1
    replace_view :metrics_jobs_upfront_pay, version: 3, revert_to_version: 2
    replace_view :metrics_jobs_value, version: 2, revert_to_version: 1
    replace_view :metrics_projects_fixed_50_50_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_fixed_bi_weekly_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_fixed_monthly_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_fixed_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_fixed_share, version: 2, revert_to_version: 1
    replace_view :metrics_projects_fixed_upon_completion_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_hourly_bi_weekly_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_hourly_monthly_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_hourly_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_hourly_share, version: 2, revert_to_version: 1
    replace_view :metrics_projects_hourly_upon_completion_pay, version: 2, revert_to_version: 1
    replace_view :metrics_projects_posted, version: 2, revert_to_version: 1
    replace_view :metrics_projects_share, version: 2, revert_to_version: 1
    replace_view :metrics_projects_value, version: 2, revert_to_version: 1
  end
end
