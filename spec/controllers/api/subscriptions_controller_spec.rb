# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::SubscriptionsController, type: :controller do
  before(:each) do
    request.headers['Authorization'] = token
  end

  describe 'GET index' do
    context 'business' do
      context 'empty response' do
        let(:token) { get_business_token }

        before { get :index, as: 'json' }

        it { expect(response).to have_http_status(200) }
        it { expect(JSON.parse(response.body)).to eq([]) }
        it { expect(assigns(:current_someone).business?).to be_truthy }
      end

      context 'success response' do
        let(:business) { create(:business_with_team_annual_subscription) }
        let(:token) { get_business_token(business.user) }

        before { get :index, as: 'json' }

        it { expect(response).to have_http_status(200) }
        it { expect(JSON.parse(response.body)[0]['last4']).to eq('4242') }
        it { expect(JSON.parse(response.body)[0]['currency']).to eq('usd') }
        it { expect(JSON.parse(response.body)[0]['interval']).to eq('year') }
        it { expect(JSON.parse(response.body)[0]['title']).to eq('Team Plan') }
        it { expect(JSON.parse(response.body)[0]['amount_in_cents']).to eq(150_000) }
        it { expect(JSON.parse(response.body)[0]['total_seat_count']).to be_present }
        it { expect(JSON.parse(response.body)[0]['plan']).to eq('team_tier_annual') }
        it { expect(JSON.parse(response.body)[0]['next_payment_date']).to be_present }
        it { expect(JSON.parse(response.body)[0]['price_interval']).to eq('$1500/year') }
      end
    end

    context 'specialist' do
      context 'empty response' do
        let(:token) { get_specialist_token }

        before { get :index, as: 'json' }

        it { expect(response).to have_http_status(200) }
        it { expect(JSON.parse(response.body)).to eq([]) }
        it { expect(assigns(:current_someone).specialist?).to be_truthy }
      end

      context 'success response' do
        let(:specialist) { create(:specialist_with_pro_subscription) }
        let(:token) { get_specialist_token(specialist.user) }

        before { get :index, as: 'json' }

        it { expect(response).to have_http_status(200) }
        it { expect(JSON.parse(response.body)[0]['last4']).to eq('4242') }
        it { expect(JSON.parse(response.body)[0]['currency']).to eq('usd') }
        it { expect(JSON.parse(response.body)[0]['interval']).to eq('year') }
        it { expect(JSON.parse(response.body)[0]['plan']).to eq('specialist_pro') }
        it { expect(JSON.parse(response.body)[0]['amount_in_cents']).to eq(40_000) }
        it { expect(JSON.parse(response.body)[0]['next_payment_date']).to be_present }
        it { expect(JSON.parse(response.body)[0]['price_interval']).to eq('$400/year') }
        it { expect(JSON.parse(response.body)[0]['title']).to eq('All Access Membership') }
      end
    end
  end
end
