# frozen_string_literal: true
class AddActivityMetricsViews < ActiveRecord::Migration
  def change
    create_view :metrics_avg_staffing_times
    create_view :metrics_escalated_projects
    create_view :metrics_extended_projects
    create_view :metrics_account_deletions
    create_view :metrics_signups
    create_view :metrics_activity
    replace_view :metrics, version: 3, revert_to_version: 2
  end
end
