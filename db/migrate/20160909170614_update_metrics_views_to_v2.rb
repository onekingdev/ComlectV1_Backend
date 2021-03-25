# frozen_string_literal: true

class UpdateMetricsViewsToV2 < ActiveRecord::Migration[6.0]
  def change
    replace_view :metrics_jobs_installment_pay, version: 2, revert_to_version: 1
    replace_view :metrics_jobs_upfront_pay, version: 2, revert_to_version: 1
  end
end
