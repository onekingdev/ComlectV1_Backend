# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Buy seats', type: :request do
  include SessionsHelper
  include Rails.application.routes.url_helpers
  include StripeHelper

  let(:business) { create :business, :with_payment_profile }

  before do
    sign_in business.user
    create_stripe_plans
  end

  context 'when correct params' do
    it 'reloads page' do
      # post business_seats_buy_path, { seat: { cnt: 3, plan: :monthly } }
      # Stripe-ruby-mock should be upgraded because I see
      # Stripe::InvalidRequestError:
      #        Received unknown parameter: cancel_at, proration_behavior
      # expect(response).to redirect_to(business_seats_path)
    end
  end
  context 'when wrong plan params'
  context 'when wrong count of seats params'
end
