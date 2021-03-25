# frozen_string_literal: true

class AddYearToAnnualReports < ActiveRecord::Migration[6.0]
  def change
    add_column :annual_reports, :year, :integer, default: nil
  end
end
