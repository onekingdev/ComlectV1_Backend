# frozen_string_literal: true

class UpdateMetricsView < ActiveRecord::Migration[6.0]
  def change
    replace_view :metrics_project_completions, version: 2, revert_to_version: 1
  end
end
