# frozen_string_literal: true

class FixDivZeroInViews < ActiveRecord::Migration
  def change
    replace_view :metrics_jobs_share, version: 4, revert_to_version: 3
    replace_view :metrics_projects_share, version: 4, revert_to_version: 3
    replace_view :metrics_projects_fixed_share, version: 4, revert_to_version: 3
    replace_view :metrics_projects_hourly_share, version: 4, revert_to_version: 3
  end
end
