# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deleting account', type: :request do
  include SessionsHelper

  context 'a specialist' do
    let(:specialist) { create :specialist }

    context 'when deleting its account' do
      before do
        sign_in specialist.user
        delete specialists_settings_delete_account_path
        expect(response).to have_http_status(:found)
      end

      it 'cannot login anymore' do
        post(
          user_session_path,
          'user[email]' => specialist.user.email,
          'user[password]' => 'password'
        )

        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/Invalid email or password/i)
      end

      it 'marks user as deleted' do
        user = specialist.user.reload
        expect(user.deleted_at.present?).to be_truthy
        expect(user.deleted).to be_truthy
      end
    end

    context 'with full time projects started outside 6 months' do
      let!(:project) {
        create(
          :project_full_time,
          :complete,
          specialist: specialist,
          starts_on: Time.zone.today - 7.months
        )
      }

      before do
        sign_in specialist.user
        delete specialists_settings_delete_account_path
      end

      it 'responds with a found status' do
        expect(response).to have_http_status(:found)
      end

      it 'marks user as deleted' do
        user = specialist.user.reload
        expect(user.deleted_at.present?).to be_truthy
        expect(user.deleted).to be_truthy
      end
    end

    context 'with one off projects ended within 1 week' do
      let(:business) { create(:business) }

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
        sign_in specialist.user
        delete specialists_settings_delete_account_path
      end

      it 'responds with a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with active projects' do
      let!(:project) {
        create(
          :project_one_off,
          :published,
          specialist: specialist,
          starts_on: Time.zone.today
        )
      }

      before do
        sign_in specialist.user
        delete specialists_settings_delete_account_path
      end

      it 'responds with a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
