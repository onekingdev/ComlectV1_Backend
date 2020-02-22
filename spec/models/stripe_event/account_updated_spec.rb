# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeEvent::AccountUpdated, type: :model do
  before do
    expect_any_instance_of(
      Stripe::StripeObject
    ).to receive(:secret).and_return('sk_test_456')

    expect_any_instance_of(
      Stripe::StripeObject
    ).to receive(:publishable).and_return('pk_test_456')
  end

  describe 'document verification' do
    let!(:stripe_account) { create :stripe_account }

    let(:event) {
      {
        type: 'account.updated',
        data: {
          object: {
            id: stripe_account.stripe_id,
            legal_entity: {
              verification: {
                status: 'unverified'
              }
            }
          }
        }
      }
    }

    let(:account) {
      {
        verification: {
          fields_needed: ['document']
        }
      }
    }

    it 'sends a verification missing notification' do
      expect(Stripe::Event).to receive(:retrieve)
        .with('evt_123', api_key: 'sk_test_456')
        .and_return(JSON.parse(event.to_json, object_class: OpenStruct))

      expect(Stripe::Account).to receive(:retrieve)
        .with(stripe_account.stripe_id)
        .and_return(JSON.parse(account.to_json, object_class: OpenStruct))

      expect(Notification::Deliver).to receive(:verification_missing!)

      StripeEvent.handle('evt_123', stripe_account.stripe_id, connect: true)
    end
  end
end
