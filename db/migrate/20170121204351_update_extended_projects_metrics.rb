# frozen_string_literal: true
class UpdateExtendedProjectsMetrics < ActiveRecord::Migration
  def change
    replace_view :metrics_extended_projects, version: 2, revert_to_version: 1
  end
end
