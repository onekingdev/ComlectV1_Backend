# frozen_string_literal: true

class AddYearToAnnualReports < ActiveRecord::Migration
  def change
    add_column :annual_reports, :year, :integer, default: nil
  end
end
