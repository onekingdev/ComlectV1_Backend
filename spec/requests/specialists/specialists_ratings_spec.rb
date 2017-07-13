# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Specialist::Ratings', type: :request do
  include SessionsHelper

  describe 'when a specialist rates a business' do
    let(:specialist) { create :specialist }
    let(:project) { create :project_one_off_hourly, :complete, specialist: specialist }
    let(:business) { project.business }

    before do
      sign_in specialist.user
    end

    subject do
      post(
        project_rating_path(project),
        rating: { value: 5, review: 'Nice working with them' },
        format: :js
      )
    end

    it 'creates a rating' do
      expect do
        is_expected
        expect(response).to have_http_status(:created)
      end.to change { project.business.ratings_received.count }.by(1)
    end

    context 'business wants notification' do
      before do
        business.settings(:notifications).update_attributes! got_rated: true
      end

      it 'sends notification to business' do
        expect { is_expected }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'business does not want notification' do
      before do
        business.settings(:notifications).update_attributes! got_rated: false
      end

      it 'does not send notification to business' do
        expect { is_expected }.to_not change { ActionMailer::Base.deliveries.count }
      end
    end
  end
end
