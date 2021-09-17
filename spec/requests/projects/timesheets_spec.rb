# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects::TimesheetsController', type: :request do
  include SessionsHelper

  describe 'DELETE /api/projects/:project_id/timesheets/:id' do
    let(:specialist) { create(:specialist) }

    let(:project) {
      create(
        :project_one_off_hourly,
        :published,
        specialist: specialist
      )
    }

    subject {
      delete api_specialist_project_timesheet_path(
        id: timesheet.id,
        project_id: project.id
      ), headers: authenticated_header(project.specialist.user)
    }

    context 'when authenticated' do
      before do
        sign_in project.specialist.user
        subject
      end

      context 'when timesheet is disputed' do
        let(:timesheet) {
          create(
            :timesheet,
            :disputed,
            project: project,
            hours: 5
          )
        }

        it 'returns id on delete' do
          url = project_dashboard_url(
            project_id: project.id,
            anchor: 'project-timesheets'
          )
          subject
          expect(json[:id].present?).to be true
        end
      end

      context 'when timesheet is approved' do
        let(:timesheet) {
          create(
            :timesheet,
            :approved,
            project: project,
            hours: 5
          )
        }

        it 'forbids to delete' do
          url = project_dashboard_url(
            project_id: project.id,
            anchor: 'project-timesheets'
          )
          subject
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
