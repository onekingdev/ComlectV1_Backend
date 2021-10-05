# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Specialist::UpgradesController, type: :controller do
  let(:specialist) { create(:specialist, dashboard_unlocked: false) }

  before(:each) do
    request.headers['Authorization'] = get_specialist_token(specialist.user)
  end

  describe 'POST create' do
    context 'raises ParameterMissing exception' do
      let(:error) { ActionController::ParameterMissing }

      it { expect { post(:create, {}) }.to raise_error(error) }
      it { expect { post(:create, as: 'json', params: { upgrade: {} }) }.to raise_error(error) }
    end

    context 'fake plan name' do
      before { post :create, as: 'json', params: { upgrade: { plan: 'invalid-plan' } } }
      it { expect(JSON.parse(response.body)['error']).to eq('Wrong plan name') }
    end

    context 'free plan' do
      let(:msg) { "Plan has been downgraded to 'Free Plan'." }
      before { post :create, as: 'json', params: { upgrade: { plan: 'free' } } }

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status(201) }
      it { expect(Specialist.last.dashboard_unlocked).to be_truthy }
      it { expect(JSON.parse(response.body)['message']).to eq(msg) }
    end
  end
end
