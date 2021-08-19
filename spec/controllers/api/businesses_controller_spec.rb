# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::BusinessesController, type: :controller do
  before(:each) do
    login_as_business
  end

  describe 'PUT auto_populate' do
    context 'with empty params' do
      before { put :auto_populate, params: {} }

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['errors']['business']['crd_number']).to eq('Required field') }
    end

    context 'success response' do
      let(:crd_number) { '1111' }

      before { put :auto_populate, params: { crd_number: crd_number } }

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['crd_number']).to eq(crd_number) }
    end
  end
end
