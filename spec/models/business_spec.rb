# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business do
  describe '#referral_token' do
    let!(:business) { create(:business) }

    let!(:token1) do
      ReferralToken::Generate.new(
        referrer: business,
        amount_in_cents: 1000
      ).call
    end

    let!(:token2) do
      ReferralToken::Generate.new(
        referrer: business,
        amount_in_cents: 2000
      ).call
    end

    let!(:token3) do
      ReferralToken::Generate.new(
        referrer: business,
        amount_in_cents: 3000
      ).call
    end

    it 'returns the latest token' do
      token = business.referral_token
      expect(token.token).to eq token3.reload.token
      expect(token.amount_in_cents).to eq 3000
    end
  end

  describe '.for_signup' do
    context 'with referral token' do
      let(:referral_token) { create(:referral_token) }

      subject do
        Business.for_signup(
          attributes_for(:business).merge(user_attributes: attributes_for(:user).merge(
            cookie_agreement_attributes: attributes_for(:cookie_agreement, status: true),
            tos_agreement_attributes: attributes_for(:tos_agreement, status: true)
          )),
          referral_token.token
        )
      end

      it 'creates and processes a referral' do
        subject.save
        expect(subject.referral).to be_persisted
        expect(referral_token.reload.referrals_count).to eq 1
        expect(referral_token.referrer.reload.credits_in_cents).to eq 1000
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

  describe '#business?' do
    let(:business) { create(:business) }
    it { expect(business.business?).to be_truthy }
  end

  describe '#specialist?' do
    let(:business) { create(:business) }
    it { expect(business.specialist?).to be_falsey }
  end
end
