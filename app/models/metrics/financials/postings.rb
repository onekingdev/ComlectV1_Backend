# frozen_string_literal: true

class Metrics::Financials::Postings < Metrics::Financials
  def initialize
    @db_view = ActiveRecord::Base.connection.execute('SELECT * FROM financials_postings').to_a
  end

  def postings
    return {} if invalid?
    @metrics = {
      'Value' => metric('postings_value'),
      'Revenue' => [*metric('postings_revenue'), {
        'Average per Job' => metric('postings_revenue_per_job'),
        'Average per Project' => metric('postings_revenue_per_project')
      }],
      'Percent Jobs' => metric('postings_job_share', :percentage),
      'Percent Projects' => metric('postings_project_share', :percentage)
    }
  end

  def metric(name, cast = :currency)
    value = @db_view.detect { |metric| metric['metric'] == name }['value']
    case cast
    when :percentage
      ["#{value.to_f.round(2)}%"]
    when :currency
      [number_to_currency(value)]
    end
  end
end
