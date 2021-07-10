# frozen_string_literal: true

class CompletionMetricsViews < ActiveRecord::Migration[6.0]
  def change
    create_view :metrics_project_completions
    create_view :metrics_job_completions
    create_view :metrics_time_to_completion
    replace_view :metrics, version: 2, revert_to_version: 1
  end
end
