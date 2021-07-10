# frozen_string_literal: true

class AnnualRewardsResetJob < ApplicationJob
  queue_as :default

  def perform
    reset_businesses!
    reset_specialists!
  end

  private

  def reset_businesses!
    Business.all.find_each { |business| Business::Rewards.reset! business }
  end

  def reset_specialists!
    Specialist.all.find_each { |specialist| Specialist::Rewards.reset! specialist }
  end
end
