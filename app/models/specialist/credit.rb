# frozen_string_literal: true

class Specialist::Credit
  attr_accessor :specialist

  def self.for(specialist)
    new.tap do |credit|
      credit.specialist = specialist
    end
  end

  def amount_in_cents
    specialist.credits_in_cents
  end

  def redeem!(amount_in_cents)
    specialist.referral_credits_in_cents -= amount_in_cents
    specialist.save
  end
end
