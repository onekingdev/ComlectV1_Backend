# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist::Form do
  describe '.signup' do
    context 'with referral token' do
      let(:referral_token) { create(:referral_token) }

      subject do
        Specialist::Form.signup(
          attributes_for(:specialist).merge(user_attributes: attributes_for(:user).merge(
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
        Specialist::Form.signup(
          attributes_for(:specialist).merge(user_attributes: attributes_for(:user))
        )
      end

      it 'does not create a referral' do
        subject.save
        expect(subject.referral).to be_nil
      end
    end
  end
end
