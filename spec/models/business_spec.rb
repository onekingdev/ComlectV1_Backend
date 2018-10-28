# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business do
  describe '.for_signup' do
    context 'with referral token' do
      let(:referral_token) { create(:referral_token) }

      subject do
        Business.for_signup(
          attributes_for(:business).merge(user_attributes: attributes_for(:user)),
          referral_token.token
        )
      end

      it 'creates and processes a referral' do
        subject.save
        expect(subject.referral).to be_persisted
        expect(referral_token.reload.referrals_count).to eq 1
        expect(referral_token.referrer.reload.referral_credits_in_cents).to eq 1000
      end
    end

    context 'without referral token' do
      subject do
        Business.for_signup(
          attributes_for(:business).merge(user_attributes: attributes_for(:user))
        )
      end

      it 'does not create a referral' do
        subject.save
        expect(subject.referral).to be_nil
      end
    end
  end

  describe '#processed_transactions_amount' do
    let!(:business) { create(:business) }
    let!(:specialist) { create(:specialist) }
    let!(:project) { create(:project, business: business, specialist: specialist) }
    let!(:transaction1) { create(:transaction, :processed, project: project) }
    let!(:transaction2) { create(:transaction, :pending, project: project) }

    it 'returns the correct amount' do
      expect(business.processed_transactions_amount).to eq 100
    end
  end

  describe '#rewards_tier' do
    context 'with no rewards tier set' do
      let!(:default_tier) { create(:rewards_tier) }
      let!(:business) { create(:business, rewards_tier: nil) }

      it 'returns the correct tier' do
        expect(business.rewards_tier.name).to eq 'None'
      end
    end

    context 'with override greater than current tier' do
      let(:business) { create(:business, :gold_rewards, :platinum_rewards_override) }

      it 'returns the correct tier' do
        expect(business.rewards_tier.name).to eq 'Platinum'
      end
    end

    context 'with override less than current tier' do
      let(:business) { create(:business, :platinum_rewards, :gold_rewards_override) }

      it 'returns the correct tier' do
        expect(business.rewards_tier.name).to eq 'Platinum'
      end
    end

    context 'without override' do
      let(:business) { create(:business, :platinum_honors_rewards) }

      it 'returns the correct tier' do
        expect(business.rewards_tier.name).to eq 'Platinum Honors'
      end
    end
  end
end
