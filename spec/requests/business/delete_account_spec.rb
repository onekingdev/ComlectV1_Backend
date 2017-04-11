# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Deleting account", type: :request do
  include SessionsHelper

  context 'a business' do
    let(:business) { create :business }

    context 'deleting its account' do
      before do
        sign_in business.user
        delete business_settings_delete_account_path
        expect(response).to have_http_status(:found)
      end

      it 'cannot login anymore' do
        post user_session_path, 'user[email]' => business.user.email, 'user[password]' => 'password'
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/Invalid email or password/i)
      end

      it 'marks user as deleted' do
        user = business.user.reload
        expect(user.deleted_at.present?).to be_truthy
        expect(user.deleted).to be_truthy
      end
    end
  end
end
