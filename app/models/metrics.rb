# frozen_string_literal: true
class Metrics
  include ActiveSupport::NumberHelper
  include ActionView::Helpers::TextHelper
  include Metrics::Postings
  include Metrics::Completions

  attr_reader :metrics

  def initialize
    @db_view = ActiveRecord::Base.connection.execute('SELECT * FROM metrics').to_a
  end

  private

  def metric(name, cast = :int)
    values = @db_view.detect { |metric| metric['metric'] == name }
    results = [values['mtd'], values['fytd'], values['itd']]
    case cast
    when :float
      results.map { |r| r.to_f.round(2) }
    when :percentage
      results.map { |r| "#{r.to_f.round(2)}%" }
    when :currency
      results.map(&method(:number_to_currency))
    when :days
      results.map { |r| pluralize(r, 'day', 'days') }
    else
      results.map(&:to_i)
    end
  end
end
