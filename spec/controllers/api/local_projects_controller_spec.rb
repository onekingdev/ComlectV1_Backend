# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::LocalProjectsController, type: :controller do
  before(:each) do
    request.headers['Authorization'] = token
  end

  describe 'POST create' do
    context 'specialist' do
      let(:token) { get_specialist_token }

      context 'raise error' do
        let(:msg) { 'Able to create project only through business' }

        before { post :create, as: :json }

        it { expect(response).to have_http_status(422) }
        it { expect(JSON.parse(response.body)['error']).to eq(msg) }
      end
    end

    context 'business' do
      let(:token) { get_business_token }

      context 'raises ParameterMissing exception' do
        let(:error) { ActionController::ParameterMissing }

        it { expect { post(:create, {}) }.to raise_error(error) }
        it { expect { post(:create, as: 'json', params: { local_project: {} }) }.to raise_error(error) }
      end

      context 'return errors' do
        before { post :create, as: 'json', params: { local_project: { title: '' } } }

        it { expect(response).to have_http_status(422) }
        it { expect(JSON.parse(response.body)['errors']['title']).to eq(['Required field']) }
        it { expect(JSON.parse(response.body)['errors']['ends_on']).to eq(['Required field']) }
        it { expect(JSON.parse(response.body)['errors']['starts_on']).to eq(['Required field']) }
      end

      context 'return errors' do
        let(:params) do
          {
            title: 'Job Title',
            starts_on: Time.zone.now,
            ends_on: Time.zone.now + 1.day
          }
        end

        before do
          expect(LocalProject.count).to be_zero
          post :create, as: 'json', params: params
        end

        it { expect(response).to have_http_status(201) }

        it { expect(LocalProject.count).to eq(1) }
        it { expect(JSON.parse(response.body)['errors']).to be_nil }
      end
    end
  end
end
