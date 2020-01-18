# frozen_string_literal: true

class AddProcessedToAnnualReviews < ActiveRecord::Migration
  def change
    add_column :annual_reviews, :processed, :boolean, default: false
  end
end
