# frozen_string_literal: true
module Metrics::Completions
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def completions
    @metrics = {
      'Projects' => [nil, nil, nil, {
        'Number Completed' => metric('completed_projects'),
        'Percent Completed' => metric('completed_projects_share', :percentage),
        'Percent of All Completions' => metric('completed_projects_all_share', :percentage),
        'Percent Hourly' => metric('completed_projects_hourly_share', :percentage),
        'Percent Fixed' => metric('completed_projects_fixed_share', :percentage),
        'By Payment Plan' => [nil, nil, nil, {
          'Hourly' => [*metric('completed_projects_hourly_pay'), {
            'Upon Completion' => metric('completed_projects_hourly_upon_completion_pay'),
            'Bi-Weekly' => metric('completed_projects_hourly_bi_weekly_pay'),
            'Monthly' => metric('completed_projects_hourly_monthly_pay')
          }],
          'Fixed' => [*metric('completed_projects_fixed_pay'), {
            '50/50' => metric('completed_projects_fixed_50_50_pay'),
            'Upon Completion' => metric('completed_projects_fixed_upon_completion_pay'),
            'Bi-Weekly' => metric('completed_projects_fixed_bi_weekly_pay'),
            'Monthly' => metric('completed_projects_fixed_monthly_pay')
          }]
        }]
      }],
      'Jobs' => [nil, nil, nil, {
        'Number Completed' => metric('completed_jobs'),
        'Percent Completed' => metric('completed_jobs_share', :percentage),
        'Percent of All Postings' => metric('completed_jobs_all_share', :percentage),
        'By Payment Plan' => [nil, nil, nil, {
          'Upfront' => metric('completed_jobs_upfront_pay'),
          'Monthly' => metric('completed_jobs_monthly_pay')
        }]
      }],
      'Total' => [nil, nil, nil, {
        'Number Posted' => [metric('completed_jobs'), metric('completed_projects')].transpose.map(&:sum),
        'Percent Projects' => metric('completed_projects_share', :percentage),
        'Percent Jobs' => metric('completed_jobs_share', :percentage)
      }],
      'Average Time to Completion' => [nil, nil, nil, {
        'Projects' => metric('completed_projects_average_time', :days),
        'Jobs' => metric('completed_jobs_average_time', :days)
      }]
    }
  end
end
