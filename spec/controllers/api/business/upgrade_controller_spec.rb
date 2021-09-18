# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Business::UpgradeController, type: :controller do
  before(:each) do
    login_as_business
  end

  describe 'POST subscribe' do
    context 'raises ParameterMissing exception' do
      let(:error) { ActionController::ParameterMissing }

      it { expect { post(:subscribe, {}) }.to raise_error(error) }
      it { expect { post(:subscribe, as: 'json', params: { upgrade: {} }) }.to raise_error(error) }
    end

    context 'invalid plan name' do
      before { post :subscribe, as: 'json', params: { plan: 'invalid-plan' } }
      it { expect(JSON.parse(response.body)['error']).to eq('Wrong plan name') }
    end

    context 'free plan' do
      before do
        expect(Business.last.onboarding_passed).to be_falsey
        post :subscribe, as: 'json', params: { plan: 'free' }
      end

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status(201) }
      it { expect(Business.last.onboarding_passed).to be_truthy }
      it { expect(JSON.parse(response.body)['error']).to be_nil }
      it { expect(JSON.parse(response.body)['message']).to eq('subscribed') }
    end
  end
end
