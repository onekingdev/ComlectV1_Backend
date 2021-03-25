# frozen_string_literal: true

class AddRewardsTierOverrideIdToBusinessesAndSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :rewards_tier_override_id, :integer
    add_column :specialists, :rewards_tier_override_id, :integer
  end
end
