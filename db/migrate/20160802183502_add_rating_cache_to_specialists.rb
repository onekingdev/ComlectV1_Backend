# frozen_string_literal: true

class AddRatingCacheToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :rating_avg, :decimal
    add_index :specialists, :rating_avg
  end
end
