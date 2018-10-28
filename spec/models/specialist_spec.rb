# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist do
  describe '#active_referral_token' do
    let!(:specialist) { create(:specialist) }

    let!(:token1) {
      ReferralToken::Generate.new(
        referrer: specialist,
        amount_in_cents: 1000
      ).call
    }

    let!(:token2) {
      ReferralToken::Generate.new(
        referrer: specialist,
        amount_in_cents: 2000
      ).call
    }

    let!(:token3) {
      ReferralToken::Generate.new(
        referrer: specialist,
        amount_in_cents: 3000
      ).call
    }

    it 'returns the latest token' do
      token = specialist.active_referral_token
      expect(token.token).to eq token3.reload.token
      expect(token.amount_in_cents).to eq 3000
    end
  end

  describe '#processed_transactions_amount' do
    let!(:business) { create(:business) }
    let!(:specialist) { create(:specialist) }
    let!(:project) { create(:project, business: business, specialist: specialist) }

    let!(:transaction1) {
      create(
        :transaction,
        :processed,
        project: project,
        fee_in_cents: 1000
      )
    }

    let!(:transaction2) {
      create(
        :transaction,
        :pending,
        project: project
      )
    }

    it 'returns the correct amount' do
      expect(specialist.processed_transactions_amount).to eq 90
    end
  end

  describe '#years_of_compilant_experience' do
    let!(:specialist) { create(:specialist, work_experiences: []) }

    let!(:experience) {
      create(
        :work_experience,
        :compliance,
        specialist: specialist,
        from: Date.new(2012, 11, 7),
        to: Date.new(2014, 6, 7)
      )
    }

    it 'should return compliance working experience rounded' do
      from_date = specialist.reload.work_experiences.first.from
      to_date = specialist.reload.work_experiences.first.to

      compliance_years = ((to_date - from_date) / 365).round

      expect(specialist.reload.years_of_compilant_experience).to eq(compliance_years)
    end
  end

  describe '#rewards_tier' do
    context 'with no rewards tier set' do
      let!(:default_tier) { create(:rewards_tier) }
      let!(:specialist) { create(:specialist, rewards_tier: nil) }

      it 'returns the correct tier' do
        expect(specialist.rewards_tier.name).to eq 'None'
      end
    end

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
