# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business::Rewards do
  let!(:business) { create(:business) }
  let!(:gold) { create(:rewards_tier, :gold) }
  let!(:platinum) { create(:rewards_tier, :platinum) }

  describe '.calculate!' do
    it 'sets a tier' do
      expect(business).to receive(:processed_transactions_amount).and_return(35_000)
      Business::Rewards.calculate!(business)
      expect(business.rewards_tier.name).to eq 'Gold'
    end
  end
end
