# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Business::SeatsController, type: :controller do
  let(:business) { create(:business_with_subscription) }

  before(:each) do
    login_as_business(business.user)
  end

  describe 'GET available_seat_count' do
    context 'seats does not exist in db' do
      before { get :available_seat_count, as: 'json' }

      it { expect(Seat.count).to eq(0) }
      it { expect(response.message).to eq('OK') }
      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['count']).to eq(0) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
    end

    context 'there is one available seat' do
      let!(:seat) { create(:seat, business: Business.first, subscription: Subscription.first) }

      before { get :available_seat_count, as: 'json' }

      it { expect(Seat.count).to eq(1) }
      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['count']).to eq(1) }
    end

    context 'there is one taken seat' do
      let!(:team_member) { create(:team_member, team_id: Business.first.teams.first.id) }
      let!(:seat) { create(:seat, business: Business.first, subscription: Subscription.first) }

      before do
        seat.assign_to(team_member.id)
        get :available_seat_count, as: 'json'
      end

      it { expect(Seat.count).to eq(1) }
      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['count']).to eq(0) }
    end
  end
end
