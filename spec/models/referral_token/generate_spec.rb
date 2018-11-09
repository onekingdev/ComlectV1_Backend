# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReferralToken::Generate do
  describe '#call' do
    let(:specialist) { create(:specialist) }

    subject do
      ReferralToken::Generate.new(referrer: specialist, amount_in_cents: 10 * 100)
    end

    it 'generates a token' do
      subject.call
      expect(subject).to be_persisted
      expect(subject.referrer).to eq specialist
    end
  end
end
