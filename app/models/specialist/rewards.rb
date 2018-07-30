# frozen_string_literal: true

class Specialist::Rewards < Specialist
  def self.calculate_tier!(specialist)
    return specialist.update(rewards_tier: nil) if specialist.completed_projects_amount < 10_000
    return specialist.gold! if specialist.completed_projects_amount <= 50_000
    return specialist.platinum! if specialist.completed_projects_amount <= 100_000
    return specialist.platinum_honors! if specialist.completed_projects_amount > 100_000
  end

  def self.fee_percentage(specialist)
    return Charge::COMPLECT_FEE_PCT if specialist.completed_projects_amount < 10_000
    return Charge::COMPLECT_FEE_PCT_GOLD_TIER if specialist.completed_projects_amount <= 50_000
    return Charge::COMPLECT_FEE_PCT_PLATINUM_TIER if specialist.completed_projects_amount <= 100_000
    return Charge::COMPLECT_FEE_PCT_PLATINUM_HONORS_TIER if specialist.completed_projects_amount > 100_000
  end
end
