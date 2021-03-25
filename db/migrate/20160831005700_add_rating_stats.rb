# frozen_string_literal: true

class AddRatingStats < ActiveRecord::Migration
  def change
    add_column :businesses, :ratings_count, :integer, null: false, default: 0
    add_column :businesses, :ratings_total, :integer, null: false, default: 0
    add_column :businesses, :ratings_average, :float
    add_index :businesses, :ratings_average

    add_column :specialists, :ratings_count, :integer, null: false, default: 0
    add_column :specialists, :ratings_total, :integer, null: false, default: 0
    add_column :specialists, :ratings_average, :float
    add_index :specialists, :ratings_average
  end
end
