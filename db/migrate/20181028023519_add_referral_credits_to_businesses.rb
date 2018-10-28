# frozen_string_literal: true

class AddReferralCreditsToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :referral_credits_in_cents, :integer, default: 0
  end
end
