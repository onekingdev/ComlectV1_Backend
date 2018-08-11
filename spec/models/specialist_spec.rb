# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist do
  describe '#rewards_tier' do
    context 'with override greater than current tier' do
      let(:specialist) { create(:specialist, :gold_rewards, :platinum_rewards_override) }

      it 'returns the correct tier' do
        expect(specialist.rewards_tier.name).to eq 'Platinum'
      end
    end

    context 'with override less than current tier' do
      let(:specialist) { create(:specialist, :platinum_rewards, :gold_rewards_override) }

      it 'returns the correct tier' do
        expect(specialist.rewards_tier.name).to eq 'Platinum'
      end
    end

    context 'without override' do
      let(:specialist) { create(:specialist, :platinum_honors_rewards) }

      it 'returns the correct tier' do
        expect(specialist.rewards_tier.name).to eq 'Platinum Honors'
      end
    end
  end
end
