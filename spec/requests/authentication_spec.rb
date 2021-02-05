# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::AuthenticationController, type: :request do
  describe 'POST #create' do
    let(:password) { '12345678' }
    let(:user) { create(:user, password: password) }

    context 'success' do
      let(:valid_params) do
        {
          email: user.email,
          password: password
        }
      end

      subject do
        post '/api/users/sign_in', params: { user: valid_params }
      end

      before { subject }

      context 'with valid credentials' do
        it 'returns new user token' do
          expect(json[:token].present?).to be true
        end
      end

      context 'with uppercase email' do
        let(:valid_params) do
          {
            email: user.email.upcase,
            password: password
          }
        end

        it 'returns new user token' do
          expect(json[:token].present?).to be true
        end
      end
    end

    context 'fail' do
      shared_examples 'do not authenticate user' do
        it 'returns error message' do
          expect(json[:errors][:invalid]).to eq('Invalid email or password.')
        end
      end

      subject do
        post '/api/users/sign_in', params: { user: invalid_params }
      end

      before { subject }

      context 'when invalid email' do
        let(:invalid_params) do
          {
            email: 'invalid_email@example.com',
            password: password
          }
        end

        it_behaves_like 'do not authenticate user'
      end

      context 'when invalid password' do
        let(:invalid_params) do
          {
            email: user.email,
            password: 'invalid_password'
          }
        end

        it_behaves_like 'do not authenticate user'
      end
    end
  end
end
