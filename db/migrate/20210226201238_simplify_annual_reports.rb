# frozen_string_literal: true

class SimplifyAnnualReports < ActiveRecord::Migration[6.0]
  def change
    remove_column :annual_reports, :tailored_lvl, :integer
    remove_column :annual_reports, :comments, :text
    remove_column :annual_reports, :cof_bits, :string
  end
end
