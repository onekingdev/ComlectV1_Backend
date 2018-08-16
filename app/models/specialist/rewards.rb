# frozen_string_literal: true

class Specialist::Rewards
  def self.calculate!(specialist)
    tier = RewardsTier.for(specialist.processed_transactions_amount)
    specialist.update(rewards_tier: tier)
  end
end
