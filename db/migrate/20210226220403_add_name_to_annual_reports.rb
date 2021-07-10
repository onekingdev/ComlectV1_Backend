# frozen_string_literal: true

class AddNameToAnnualReports < ActiveRecord::Migration[6.0]
  def change
    add_column :annual_reports, :name, :string, default: ''
  end
end
