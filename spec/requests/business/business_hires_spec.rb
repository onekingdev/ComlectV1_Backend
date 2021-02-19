# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hiring a specialist', type: :request do
  include SessionsHelper

  let(:specialist) { create :specialist }
  let(:project) { create :project_one_off_hourly, :published }
  let(:job_application) { create :job_application, project: project, specialist: specialist }
  let(:business) { project.business }

  before do
    sign_in business.user
  end

  describe 'project with several applications' do
    before do
      5.times { create :job_application, project: project }
    end

    context 'when accepting an application' do
      subject(:accept_application) do
        post business_project_hires_path(
          project,
          job_application_id: job_application.id
        ), format: :js
      end

      it 'notifies specialists not hired' do
        accept_application
        expect(response).to have_http_status(:ok)
        notifications = ActionMailer::Base.deliveries.find_all { |m| m.body =~ /their loss/i }
        expect(notifications.size).to eq(5)
      end
    end
  end
end
