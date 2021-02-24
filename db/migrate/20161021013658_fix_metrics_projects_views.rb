# frozen_string_literal: true

class FixMetricsProjectsViews < ActiveRecord::Migration[6.0]
  def change
    replace_view :metrics_projects_fixed_50_50_pay, version: 3, revert_to_version: 2
    replace_view :metrics_projects_fixed_bi_weekly_pay, version: 3, revert_to_version: 2
    replace_view :metrics_projects_fixed_monthly_pay, version: 3, revert_to_version: 2
    replace_view :metrics_projects_fixed_upon_completion_pay, version: 3, revert_to_version: 2
    replace_view :metrics_projects_hourly_bi_weekly_pay, version: 3, revert_to_version: 2
    replace_view :metrics_projects_hourly_monthly_pay, version: 3, revert_to_version: 2
    replace_view :metrics_projects_hourly_upon_completion_pay, version: 3, revert_to_version: 2
  end
end
