# frozen_string_literal: true

class CreateMetrics < ActiveRecord::Migration
  # rubocop:disable Metrics/AbcSize
  def change
    create_view :metrics_projects_posted
    create_view :metrics_projects_value
    create_view :metrics_projects_share
    create_view :metrics_projects_hourly_share
    create_view :metrics_projects_fixed_share
    create_view :metrics_projects_hourly_pay
    create_view :metrics_projects_hourly_upon_completion_pay
    create_view :metrics_projects_hourly_bi_weekly_pay
    create_view :metrics_projects_hourly_monthly_pay
    create_view :metrics_projects_fixed_pay
    create_view :metrics_projects_fixed_50_50_pay
    create_view :metrics_projects_fixed_upon_completion_pay
    create_view :metrics_projects_fixed_bi_weekly_pay
    create_view :metrics_projects_fixed_monthly_pay
    create_view :metrics_jobs_posted
    create_view :metrics_jobs_value
    create_view :metrics_jobs_share
    create_view :metrics_jobs_upfront_pay
    create_view :metrics_jobs_installment_pay
    create_view :metrics
  end
end
