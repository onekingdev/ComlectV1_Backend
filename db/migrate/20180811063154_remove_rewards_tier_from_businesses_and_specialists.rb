# frozen_string_literal: true

class RemoveRewardsTierFromBusinessesAndSpecialists < ActiveRecord::Migration
  def change
    remove_column :businesses, :rewards_tier
    remove_column :specialists, :rewards_tier
  end
end
