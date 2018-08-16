# frozen_string_literal: true

class Business::Rewards
  def self.calculate!(business)
    tier = RewardsTier.for(business.processed_transactions_amount)
    business.update(rewards_tier: tier)
  end
end
