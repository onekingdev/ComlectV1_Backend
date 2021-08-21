# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::SpecialistsController, type: :controller do
  before(:each) do
    login_as_specialist
  end

  describe 'GET current' do
    context 'specialit' do
      let(:specialist) { Specialist.last }
      before { get :current }

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['last_name']).to eq(specialist.last_name) }
      it { expect(JSON.parse(response.body)['first_name']).to eq(specialist.first_name) }
    end
  end
end
