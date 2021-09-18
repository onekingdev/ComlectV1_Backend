# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Specialist::UpgradeController, type: :controller do
  before(:each) do
    login_as_specialist
  end

  describe 'POST subscribe' do
    context 'raises ParameterMissing exception' do
      let(:error) { ActionController::ParameterMissing }

      it { expect { post(:subscribe, {}) }.to raise_error(error) }
      it { expect { post(:subscribe, as: 'json', params: { upgrade: {} }) }.to raise_error(error) }
    end

    context 'fake plan name' do
      before { post :subscribe, as: 'json', params: { upgrade: { plan: 'invalid-plan' } } }
      it { expect(JSON.parse(response.body)['message']).to eq('Wrong plan name') }
    end

    context 'free plan' do
      before do
        Specialist.last.update(dashboard_unlocked: false)
        post :subscribe, as: 'json', params: { upgrade: { plan: 'free' } }
      end

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status(201) }
      it { expect(Specialist.last.dashboard_unlocked).to be_truthy }
      it { expect(JSON.parse(response.body)['message']).to eq('Plan has been upgraded.') }
    end
  end
end
