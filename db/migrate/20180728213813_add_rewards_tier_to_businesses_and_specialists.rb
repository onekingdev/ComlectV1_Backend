# frozen_string_literal: true

class AddRewardsTierToBusinessesAndSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :rewards_tier, :integer
    add_column :specialists, :rewards_tier, :integer
  end
end
