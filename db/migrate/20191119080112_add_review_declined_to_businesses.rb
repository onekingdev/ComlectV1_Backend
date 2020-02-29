# frozen_string_literal: true

class AddReviewDeclinedToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :review_declined, :boolean, default: false
  end
end
