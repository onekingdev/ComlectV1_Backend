# frozen_string_literal: true

class AddReferralCreditsToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :referral_credits_in_cents, :integer, default: 0
  end
end
