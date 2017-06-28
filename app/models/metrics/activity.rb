# frozen_string_literal: true

class Metrics::Activity < Metrics
  def initialize
    @db_view = ActiveRecord::Base.connection.execute('SELECT * FROM metrics_activity').to_a
  end

  def activity
    return {} if invalid?
    @metrics = {
      'Under 30 days since last activity' => [*metric('recent_activity'), {
        'Businesses' => metric('recent_activity_businesses'),
        'Specialists' => metric('recent_activity_specialists')
      }],
      'Over 30 days since last activity' => [*metric('old_activity'), {
        'Businesses' => metric('old_activity_businesses'),
        'Specialists' => metric('old_activity_specialists')
      }],
      'Total' => [nil, nil, {
        'Businesses' => metric('all_activity_businesses'),
        'Specialists' => metric('all_activity_specialists')
      }]
    }
  end

  def metric(name)
    values = @db_view.detect { |metric| metric['metric'] == name }
    [values['cnt'].to_i, "#{values['pct'].to_f.round(2)}%"]
  end
end
