# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deleting account', type: :request do
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
        post(
          user_session_path,
          params: {
            'user[email]' => business.user.email,
            'user[password]' => 'password'
          }
        )

        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/\/users\/sign_in/i)
      end

      it 'marks user as deleted' do
        user = business.user.reload
        expect(user.deleted_at.present?).to be_truthy
        expect(user.deleted).to be_truthy
      end
    end

    context 'with full time projects started within 6 months' do
      let!(:project) {
        create(
          :project_full_time,
          :complete,
          business: business,
          starts_on: Time.zone.today
        )
      }

      before do
        sign_in business.user
        delete business_settings_delete_account_path
      end

      it 'responds with a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with full time projects started outside 6 months' do
      let!(:project) {
        create(
          :project_full_time,
          :complete,
          business: business,
          starts_on: Time.zone.today - 7.months
        )
      }

      before do
        sign_in business.user
        delete business_settings_delete_account_path
      end

      it 'responds with a found status' do
        expect(response).to have_http_status(:found)
      end

      it 'marks user as deleted' do
        user = business.user.reload
        expect(user.deleted_at.present?).to be_truthy
        expect(user.deleted).to be_truthy
      end
    end

    context 'with one off projects ended within 1 week' do
      let(:specialist) { create(:specialist) }

      let!(:project) {
        create(
          :project_one_off,
          :complete,
          business: business,
          specialist: specialist,
          starts_on: Time.zone.today - 1.week,
          ends_on: Time.zone.today - 2.days
        )
      }

      before do
        sign_in business.user
        delete business_settings_delete_account_path
      end

      it 'responds with a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with active projects' do
      let(:specialist) { create(:specialist) }

      let!(:project) {
        create(
          :project_one_off,
          :published,
          business: business,
          specialist: specialist,
          starts_on: Time.zone.today
        )
      }

      before do
        sign_in business.user
        delete business_settings_delete_account_path
      end

      it 'responds with a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
