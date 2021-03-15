# frozen_string_literal: true

class DropAnnualReview < ActiveRecord::Migration[6.0]
  def change
    drop_table :annual_reviews
  end
end
