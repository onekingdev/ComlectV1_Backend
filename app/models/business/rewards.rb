# frozen_string_literal: true

class Business::Rewards < Business
  def self.calculate_tier!(business)
    return business.update(rewards_tier: nil) if business.completed_projects_amount < 10_000
    return business.gold! if business.completed_projects_amount <= 50_000
    return business.platinum! if business.completed_projects_amount <= 100_000
    return business.platinum_honors! if business.completed_projects_amount > 100_000
  end
end
