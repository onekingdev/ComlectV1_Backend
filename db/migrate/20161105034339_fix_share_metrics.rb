# frozen_string_literal: true

class FixShareMetrics < ActiveRecord::Migration[6.0]
  def change
    replace_view :metrics_projects_share, version: 3, revert_to_version: 2
    replace_view :metrics_projects_fixed_share, version: 3, revert_to_version: 2
    replace_view :metrics_projects_hourly_share, version: 3, revert_to_version: 2
    replace_view :metrics_jobs_share, version: 3, revert_to_version: 2
  end
end
