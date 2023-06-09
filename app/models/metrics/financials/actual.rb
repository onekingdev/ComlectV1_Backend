# frozen_string_literal: true

module Metrics::Financials::Actual
  def actual
    return {} if invalid?
    @metrics = {
      'Completed' => [*metric('actual_completed'), {
        'Value' => metric('actual_value', :currency),
        'Revenue' => [*metric('actual_revenue', :currency), {
          'Average per Job' => metric('actual_revenue_per_job', :currency),
          'Average per Project' => metric('actual_revenue_per_project', :currency)
        }],
        'Percent Jobs' => metric('jobs_share', :percentage),
        'Percent Projects' => metric('projects_share', :percentage)
      }],
      # Client only wants ITD column:
      'Forecast' => [nil, nil, metric('forecasted_completed')[-1], {
        'Value' => [nil, nil, metric('forecasted_value', :currency)[-1]],
        'Revenue' => [nil, nil, metric('forecasted_revenue', :currency)[-1], {
          'Average per Job' => [nil, nil, metric('forecasted_revenue_per_job', :currency)[-1]],
          'Average per Project' => [nil, nil, metric('forecasted_revenue_per_project', :currency)[-1]]
        }],
        'Percent Jobs' => [nil, nil, metric('forecasted_job_share', :percentage)[-1]],
        'Percent Projects' => [nil, nil, metric('forecasted_project_share', :percentage)[-1]]
      }]
    }
  end
end
