# frozen_string_literal: true
class Metrics::Financials
  include ActiveSupport::NumberHelper
  include ActionView::Helpers::TextHelper
  include Metrics::Financials::Actual

  attr_reader :metrics

  def initialize
    @db_view = begin
                 ActiveRecord::Base.connection.execute('SELECT * FROM financials').to_a
               rescue
                 nil
               end
    @db_view += ActiveRecord::Base.connection.execute('SELECT * FROM metrics').to_a if @db_view
  end

  def invalid?
    @db_view.nil?
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(metric mtd fytd itd all_periods)
      rows = csv_from_hash(hash: actual, output_cols: 4).each_slice(5)
      rows.each { |row| csv << row }
      add_postings_csv csv
    end
  end

  private

  def add_postings_csv(csv)
    postings = Metrics::Financials::Postings.new.postings
    rows = csv_from_hash(hash: postings, value_cols: 1).each_slice(2)
    rows.each { |row| csv << ["Postings #{row[0]}", nil, nil, nil, row[1]] }
  end

  def csv_from_hash(hash:, prefix: '', value_cols: 3, output_cols: value_cols)
    hash.map do |label, row|
      label_with_prefix = "#{prefix.present? ? "#{prefix} / " : ''}#{label}"
      next if row.all?(&:nil?)
      fill_cols = [nil] * (output_cols - value_cols)
      if row.size == value_cols
        [label_with_prefix, *row + fill_cols]
      else
        nested = csv_from_hash(hash: row[-1],
                               prefix: label_with_prefix,
                               value_cols: value_cols,
                               output_cols: output_cols)
        [label_with_prefix, row[0..value_cols - 1] + fill_cols, nested]
      end
    end.flatten
  end

  # rubocop:disable Metrics/AbcSize
  def metric(name, cast = :int)
    values = @db_view.detect { |metric| metric['metric'] == name }
    results = [values['mtd'], values['fytd'], values['itd']]
    case cast
    when :float
      results.map { |r| r.to_f.round(2) }
    when :percentage
      results.map { |r| "#{r.to_f.round(2)}%" }
    when :currency
      results.map { |r| r.nil? ? number_to_currency(0) : number_to_currency(r) }
    when :days
      results.map { |r| pluralize(r.to_f.round, 'day', 'days') }
    else
      results.map(&:to_i)
    end
  end
end
