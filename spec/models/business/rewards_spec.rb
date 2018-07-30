# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business::Rewards, type: :model do
  describe '.calculate_tier!' do
    let(:business) { create(:business) }

    context 'when completed projects amount is less than 10,000' do
      it 'sets rewards_tier to nil' do
        expect(business).to receive(:completed_projects_amount).once.and_return(9000)
        Business::Rewards.calculate_tier!(business)
        expect(business.rewards_tier).to be_nil
      end
    end

    context 'when completed projects amount is between 10,000 and 50,000' do
      it 'sets rewards_tier to gold' do
        expect(business).to receive(:completed_projects_amount).twice.and_return(35_000)
        Business::Rewards.calculate_tier!(business)
        expect(business).to be_gold
      end
    end

    context 'when completed projects amount is between 50,000 and 100,000' do
      it 'sets rewards_tier to platinum' do
        expect(business).to receive(:completed_projects_amount).exactly(3).times.and_return(65_000)
        Business::Rewards.calculate_tier!(business)
        expect(business).to be_platinum
      end
    end

    context 'when completed projects amount is greater than 100,000' do
      it 'sets rewards_tier to platinum honors' do
        expect(business).to receive(:completed_projects_amount).exactly(4).times.and_return(200_000)
        Business::Rewards.calculate_tier!(business)
        expect(business).to be_platinum_honors
      end
    end
  end
end
