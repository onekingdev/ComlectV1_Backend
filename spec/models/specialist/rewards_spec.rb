# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist::Rewards do
  let!(:default) { create(:rewards_tier, :default) }

  describe '.calculate!' do
    let!(:specialist) { create(:specialist) }

    it 'sets a tier' do
      Specialist::Rewards.calculate!(specialist)
      expect(specialist.rewards_tier.name).to eq 'None'
    end
  end

  describe '.reset!' do
    let!(:specialist) { create(:specialist) }

    it 'resets the rewards tier' do
      expect(specialist.rewards_tier.name).to eq 'None'
      Specialist::Rewards.reset! specialist
      expect(specialist.rewards_tier.name).to eq 'None'
    end
  end
end
