# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Business::UpgradesController, type: :controller do
  before(:each) do
    request.headers['Authorization'] = get_business_token(business.user)
  end

  describe 'POST subscribe' do
    context 'raises ParameterMissing exception' do
      let(:business) { create(:business) }
      let(:error) { ActionController::ParameterMissing }

      it { expect { post(:create, {}) }.to raise_error(error) }
      it { expect { post(:create, as: 'json', params: { upgrade: {} }) }.to raise_error(error) }
    end

    context 'invalid plan name' do
      let(:business) { create(:business) }

      before { post :create, as: 'json', params: { plan: 'invalid-plan' } }
      it { expect(JSON.parse(response.body)['error']).to eq('Wrong plan name') }
    end

    context 'free plan' do
      let(:business) { create(:business) }
      let(:msg) { "Plan has been upgraded to 'Free Plan'." }

      before do
        expect(business.onboarding_passed).to be_falsey
        post :create, as: 'json', params: { plan: 'free' }
      end

      it { expect(response).to be_successful }
      it { expect(business.reload.onboarding_passed).to be_truthy }
      it { expect(JSON.parse(response.body)['error']).to be_nil }
      it { expect(JSON.parse(response.body)['message']).to eq(msg) }
      it { expect(JSON.parse(response.body)['processed'][0]['plan']).to eq('free') }
      it { expect(JSON.parse(response.body)['processed'][0]['status']).to eq('active') }
      it { expect(JSON.parse(response.body)['processed'][0]['title']).to eq('Free Plan') }
      it { expect(JSON.parse(response.body)['processed'][0]['total_seat_count']).to eq(1) }
      it { expect(JSON.parse(response.body)['processed'][0]['available_seat_count']).to eq(0) }
    end

    context 'free plan already subscribed' do
      let(:msg) { "You have already subscribed to 'Free Plan'" }
      let(:business) { create(:business_with_free_subscription) }

      before do
        expect(business.onboarding_passed).to be_truthy
        post :create, as: 'json', params: { plan: 'free' }
      end

      it { expect(response).to have_http_status(422) }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(JSON.parse(response.body)['error']).to eq(msg) }
      it { expect(JSON.parse(response.body)['message']).to be_nil }
    end
  end
end
