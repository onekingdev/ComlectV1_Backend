# frozen_string_literal: true

module Metrics::Postings
  def postings
    return {} if invalid?
    @metrics = {
      'Projects' => [nil, nil, nil, {
        'Number Posted' => metric('projects_posted'),
        'Average Value' => metric('projects_value', :currency),
        'Percent of All Postings' => metric('projects_share', :percentage),
        'Percent Hourly' => metric('projects_hourly_share', :percentage),
        'Percent Fixed' => metric('projects_fixed_share', :percentage),
        'By Payment Plan' => [nil, nil, nil, {
          'Hourly' => [*metric('projects_hourly_pay'), {
            'Upon Completion' => metric('projects_hourly_upon_completion_pay'),
            'Bi-Weekly' => metric('projects_hourly_bi_weekly_pay'),
            'Monthly' => metric('projects_hourly_monthly_pay')
          }],
          'Fixed' => [*metric('projects_fixed_pay'), {
            '50/50' => metric('projects_fixed_50_50_pay'),
            'Upon Completion' => metric('projects_fixed_upon_completion_pay'),
            'Bi-Weekly' => metric('projects_fixed_bi_weekly_pay'),
            'Monthly' => metric('projects_fixed_monthly_pay')
          }]
        }]
      }],
      'Jobs' => [nil, nil, nil, {
        'Number Posted' => metric('jobs_posted'),
        'Average Value' => metric('jobs_value', :currency),
        'Percent of All Postings' => metric('jobs_share', :percentage),
        'By Payment Plan' => [nil, nil, nil, {
          'Upfront' => metric('jobs_upfront_pay'),
          'Monthly' => metric('jobs_installment_pay')
        }]
      }],
      'Total' => [nil, nil, nil, {
        'Number Posted' => [metric('jobs_posted'), metric('projects_posted')].transpose.map(&:sum),
        'Percent Projects' => metric('projects_share', :percentage),
        'Percent Jobs' => metric('jobs_share', :percentage)
      }]
    }
  end
end
