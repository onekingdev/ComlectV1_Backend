# frozen_string_literal: true

class RewardsTier < ApplicationRecord
  def self.default
    find_by(name: 'None')
  end

  def self.for(amount)
    all.find { |tier| tier.amount.include? amount }
  end
end
