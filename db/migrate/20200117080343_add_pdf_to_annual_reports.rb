# frozen_string_literal: true

class AddPdfToAnnualReports < ActiveRecord::Migration
  def change
    add_column :annual_reports, :pdf_data, :jsonb, default: nil
  end
end
