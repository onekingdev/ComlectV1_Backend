# frozen_string_literal: true
class UpdateEscalatedProjectsMetrics < ActiveRecord::Migration
  def change
    replace_view :metrics_escalated_projects, version: 3, revert_to_version: 2
  end
end
