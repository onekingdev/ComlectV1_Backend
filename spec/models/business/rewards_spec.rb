# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business::Rewards do
  let!(:default) { create(:rewards_tier, :default) }
  let!(:gold) { create(:rewards_tier, :gold) }
  let!(:platinum) { create(:rewards_tier, :platinum) }

  describe '.calculate!' do
    let!(:business) { create(:business) }

    it 'sets a tier' do
      expect(business).to receive(:processed_transactions_amount).and_return(35_000)
      Business::Rewards.calculate!(business)
      expect(business.rewards_tier.name).to eq 'Gold'
    end
  end

  describe '.reset!' do
    let!(:business) { create(:business, :gold_rewards) }

    it 'resets the rewards tier' do
      expect(business.rewards_tier.name).to eq 'Gold'
      Business::Rewards.reset! business
      expect(business.rewards_tier.name).to eq 'None'
    end
  end
end
