# frozen_string_literal: true

class ReferralToken < ApplicationRecord
  belongs_to :referrer, polymorphic: true
  has_many :referrals

  validates :token, uniqueness: true

  def amount
    amount_in_cents / 100.0
  end

  def redeem
    referrer.credits_in_cents += amount_in_cents
    referrer.save
  end
end
