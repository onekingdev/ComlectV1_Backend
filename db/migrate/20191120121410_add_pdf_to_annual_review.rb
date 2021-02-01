# frozen_string_literal: true

class AddPdfToAnnualReview < ActiveRecord::Migration
  def change
    add_column :annual_reviews, :pdf_data, :jsonb, default: nil
  end
end
