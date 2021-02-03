# frozen_string_literal: true

class UpdateMetricsAndFinancials < ActiveRecord::Migration
  def change
    replace_view :financials_actual, version: 3, revert_to_version: 2
    replace_view :financials_forecasted, version: 3, revert_to_version: 2
    replace_view :metrics_project_completions, version: 3, revert_to_version: 2
    replace_view :metrics_job_completions, version: 2, revert_to_version: 1
  end
end
