# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist do
  describe '#referral_token' do
    let!(:specialist) { create(:specialist) }

    let!(:token1) do
      ReferralToken::Generate.new(
        referrer: specialist,
        amount_in_cents: 1000
      ).call
    end

    let!(:token2) do
      ReferralToken::Generate.new(
        referrer: specialist,
        amount_in_cents: 2000
      ).call
    end

    let!(:token3) do
      ReferralToken::Generate.new(
        referrer: specialist,
        amount_in_cents: 3000
      ).call
    end

    it 'returns the latest token' do
      token = specialist.referral_token
      expect(token.token).to eq token3.reload.token
      expect(token.amount_in_cents).to eq 3000
    end
  end

  describe '#processed_transactions_amount' do
    let!(:business) { create(:business) }
    let!(:specialist) { create(:specialist) }
    let!(:project) { create(:project, business: business, specialist: specialist) }

    let!(:transaction1) do
      create(
        :transaction,
        :processed,
        project: project,
        fee_in_cents: 1000
      )
    end

    let!(:transaction2) do
      create(
        :transaction,
        :pending,
        project: project
      )
    end

    it 'returns the correct amount' do
      expect(specialist.processed_transactions_amount).to eq 90
    end
  end

  describe '#business?' do
    let(:specialist) { create(:specialist) }
    it { expect(specialist.business?).to be_falsey }
  end

  describe '#specialist?' do
    let(:specialist) { create(:specialist) }
    it { expect(specialist.specialist?).to be_truthy }
  end
end
