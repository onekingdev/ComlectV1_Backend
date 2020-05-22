# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Business charge', type: :request do
  include SessionsHelper

  let(:request) {
    post business_charges_path(
      charge: {
        amount_in_cents: 500,
        description: 'Widgets'
      }
    )
  }

  context 'when not signed in' do
    it 'redirects to sign in' do
      request
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when signed in as a specialist' do
    let(:specialist) { create(:specialist) }

    before { sign_in specialist.user }

    it 'responds with a forbidden status' do
      request
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when signed in as a business' do
    before { sign_in business.user }

    context 'with no payment profile' do
      let(:business) { create(:business) }

      it 'responds with a forbidden status' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with payment profile' do
      let(:business) { create(:business, :with_payment_profile) }

      it 'responds with a forbidden status' do
        request
        expect(response).to have_http_status(:created)
      end
    end
  end
end
