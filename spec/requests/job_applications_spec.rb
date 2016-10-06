# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "JobApplications", type: :request do
  include SessionsHelper

  describe "DELETE /job_applications" do
    let(:project) { create :project_full_time, :published }
    let(:job_application) { create :job_application, project: project }

    before { sign_in job_application.user }

    it "sends confirmation email to specialist" do
      expect do
        delete project_job_application_path(project, job_application)
        expect(response).to have_http_status(302)
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
