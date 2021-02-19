# frozen_string_literal: true

class RemoveRatingAvgFromSpecialists < ActiveRecord::Migration
  def change
    remove_column :specialists, :rating_avg, :decimal
  end
end
