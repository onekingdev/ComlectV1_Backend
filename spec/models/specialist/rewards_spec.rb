# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist::Rewards, type: :model do
  describe '.calculate_tier!' do
    let(:specialist) { create(:specialist) }

    context 'when completed projects amount is less than 10,000' do
      it 'sets rewards_tier to nil' do
        expect(specialist).to receive(:completed_projects_amount).once.and_return(9000)
        Specialist::Rewards.calculate_tier!(specialist)
        expect(specialist.rewards_tier).to be_nil
      end
    end

    context 'when completed projects amount is between 10,000 and 50,000' do
      it 'sets rewards_tier to gold' do
        expect(specialist).to receive(:completed_projects_amount).twice.and_return(35_000)
        Specialist::Rewards.calculate_tier!(specialist)
        expect(specialist).to be_gold
      end
    end

    context 'when completed projects amount is between 50,000 and 100,000' do
      it 'sets rewards_tier to platinum' do
        expect(specialist).to receive(:completed_projects_amount).exactly(3).times.and_return(65_000)
        Specialist::Rewards.calculate_tier!(specialist)
        expect(specialist).to be_platinum
      end
    end

    context 'when completed projects amount is greater than 100,000' do
      it 'sets rewards_tier to platinum honors' do
        expect(specialist).to receive(:completed_projects_amount).exactly(4).times.and_return(200_000)
        Specialist::Rewards.calculate_tier!(specialist)
        expect(specialist).to be_platinum_honors
      end
    end
  end
end
