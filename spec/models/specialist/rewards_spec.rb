# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist::Rewards do
  let!(:specialist) { create(:specialist) }
  let!(:gold) { create(:rewards_tier, :gold) }
  let!(:platinum) { create(:rewards_tier, :platinum) }

  describe '.calculate!' do
    it 'sets a tier' do
      expect(specialist).to receive(:processed_transactions_amount).and_return(55_000)
      Specialist::Rewards.calculate!(specialist)
      expect(specialist.rewards_tier.name).to eq 'Platinum'
    end
  end
end
