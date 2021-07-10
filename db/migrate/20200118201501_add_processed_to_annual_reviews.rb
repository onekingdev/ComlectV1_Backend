# frozen_string_literal: true

class AddProcessedToAnnualReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :annual_reviews, :processed, :boolean, default: false
  end
end
