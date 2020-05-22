# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist::Rewards do
  let!(:default) { create(:rewards_tier, :default) }
  let!(:gold) { create(:rewards_tier, :gold) }
  let!(:platinum) { create(:rewards_tier, :platinum) }

  describe '.calculate!' do
    let!(:specialist) { create(:specialist) }

    it 'sets a tier' do
      expect(specialist).to receive(:processed_transactions_amount).and_return(55_000)
      Specialist::Rewards.calculate!(specialist)
      expect(specialist.rewards_tier.name).to eq 'Platinum'
    end
  end

  describe '.reset!' do
    let!(:specialist) { create(:specialist, :gold_rewards) }

    it 'resets the rewards tier' do
      expect(specialist.rewards_tier.name).to eq 'Gold'
      Specialist::Rewards.reset! specialist
      expect(specialist.rewards_tier.name).to eq 'None'
    end
  end
end
