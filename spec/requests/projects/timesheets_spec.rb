# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects::TimesheetsController', type: :request do
  include SessionsHelper

  describe 'DELETE /projects/:project_id/timesheets/:id' do
    let(:specialist) { create(:specialist) }

    let(:project) {
      create(
        :project_one_off_hourly,
        :published,
        specialist: specialist
      )
    }

    subject {
      delete project_timesheet_path(
        id: timesheet.id,
        project_id: project.id
      )
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

        it 'redirects to the project dashboard' do
          url = project_dashboard_url(
            project_id: project.id,
            anchor: 'project-timesheets'
          )

          expect(subject).to redirect_to(url)
        end

        it 'displays a flash message' do
          expect(flash[:notice]).to eq('Timesheet deleted.')
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

        it 'redirects to the project dashboard' do
          url = project_dashboard_url(
            project_id: project.id,
            anchor: 'project-timesheets'
          )

          expect(subject).to redirect_to(url)
        end

        it 'displays a flash message' do
          expect(flash[:notice]).to eq('Unable to delete timesheet.')
        end
      end
    end
  end
end
