# frozen_string_literal: true

class AddPdfToAnnualReview < ActiveRecord::Migration[6.0]
  def change
    add_column :annual_reviews, :pdf_data, :jsonb, default: nil
  end
end
