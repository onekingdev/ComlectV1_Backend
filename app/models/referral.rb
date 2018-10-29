# frozen_string_literal: true

class Referral < ApplicationRecord
  belongs_to :referral_token, counter_cache: true
  belongs_to :referrable, polymorphic: true
  has_one :referrer, through: :referral_token

  validates :referrable_id, uniqueness: { scope: %i[referrable_id referrable_type] }

  after_create :redeem_token

  private

  def redeem_token
    referral_token.redeem
  end
end
