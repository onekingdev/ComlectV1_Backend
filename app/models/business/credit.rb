# frozen_string_literal: true

class Business::Credit
  attr_accessor :business

  def self.for(business)
    new.tap do |credit|
      credit.business = business
    end
  end

  def amount_in_cents
    business.credits_in_cents
  end

  def redeem!(amount_in_cents)
    business.referral_credits_in_cents -= amount_in_cents
    business.save
  end
end
