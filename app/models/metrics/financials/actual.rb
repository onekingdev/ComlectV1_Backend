# frozen_string_literal: true
module Metrics::Financials::Actual
  # rubocop:disable Metrics/MethodLength
  def actual
    return {} if invalid?
    @metrics = {
      'Completed' => [*metric('actual_completed'), {
        'Value' => metric('actual_value', :currency),
        'Revenue' => [*metric('actual_revenue', :currency), {
          'Average per Job' => metric('actual_revenue_per_job', :currency),
          'Average per Project' => metric('actual_revenue_per_project', :currency)
        }],
        'Percent Jobs' => metric('actual_job_share', :percentage),
        'Percent Projects' => metric('actual_project_share', :percentage)
      }],
      'Forecast' => [*metric('forecasted_completed'), {
        'Value' => metric('forecasted_value', :currency),
        'Revenue' => [*metric('forecasted_revenue', :currency), {
          'Average per Job' => metric('forecasted_revenue_per_job', :currency),
          'Average per Project' => metric('forecasted_revenue_per_project', :currency)
        }],
        'Percent Jobs' => metric('forecasted_job_share', :percentage),
        'Percent Projects' => metric('forecasted_project_share', :percentage)
      }]
    }
  end
end
