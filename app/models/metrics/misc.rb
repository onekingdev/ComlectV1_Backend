# frozen_string_literal: true
module Metrics::Misc
  # rubocop:disable Metrics/MethodLength
  def misc
    return {} if invalid?
    @metrics = {
      'Average Time to Getting Staffed' => [*metric('avg_staffing_time', :days), {
        'Projects' => metric('avg_project_staffing_time', :days),
        'Jobs' => metric('avg_job_staffing_time', :days)
      }],
      'Signups' => [*metric('all_signups'), {
        'Businesses' => metric('business_signups'),
        'Specialists' => metric('specialist_signups')
      }],
      'Deletions' => [*metric('all_account_deletions'), {
        'Businesses' => metric('business_account_deletions'),
        'Specialists' => metric('specialist_account_deletions')
      }],
      'Other' => [nil, nil, nil, {
        'Escalated Projects' => metric('escalated_projects'),
        'Extended Projects' => metric('extended_projects')
      }]
    }
  end
end
