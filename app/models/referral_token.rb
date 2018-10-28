# frozen_string_literal: true

class ReferralToken < ApplicationRecord
  belongs_to :referrer, polymorphic: true
  has_many :referrals

  validates :token, uniqueness: true
end
