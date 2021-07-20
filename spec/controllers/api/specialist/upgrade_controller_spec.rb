# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Specialist::UpgradeController, type: :controller do
  before(:each) do
    login_as_specialist
  end

  describe 'POST subscribe' do
    context 'without plan name' do
      before { post :subscribe, params: {} }

      it { expect(response).to have_http_status(422) }
      it { expect(response.message).to eq('Unprocessable Entity') }
      it { expect(JSON.parse(response.body)['message']).to eq('Wrong plan name') }
    end

    context 'invalid plan name' do
      before { post :subscribe, params: { plan: 'invalid-plan' } }
      it { expect(JSON.parse(response.body)['message']).to eq('Wrong plan name') }
    end

    context 'free plan' do
      before do
        Specialist.last.update(dashboard_unlocked: false)
        post :subscribe, params: { plan: 'free' }
      end

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status(201) }
      it { expect(Specialist.last.dashboard_unlocked).to be_truthy }
      it { expect(JSON.parse(response.body)['message']).to eq('You have successfully subscribed') }
    end
  end
end
