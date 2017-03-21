# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Project end scenarios", type: :request do
  include SessionsHelper

  context 'project lapses' do
    let(:business) { create :business }
    let(:specialist) { create :specialist }
    # Hourly rate: $100, estimated hours: 50
    let(:project) { create :project_one_off_hourly, :published, business: business, specialist: specialist }
    let(:first_timesheet) { create :timesheet, :approved, project: project, hours: 10 }

    before do
      Timecop.freeze(project.starts_on + 2.days) { first_timesheet } # Trigger creation
      Timecop.freeze project.ends_on.in_time_zone(business.tz) + 12.hours
    end

    after do
      Timecop.return
    end

    context 'specialist submits last timesheet' do
      let(:timesheet) { create(:timesheet, :submitted, project: project, hours: 5) }

      context 'business approves timesheet' do
        before do
          sign_in business.user
          put business_project_timesheet_path(project, timesheet, format: :js, timesheet: { approve: '1' })
          expect(response).to have_http_status(:ok)
          project.reload
        end

        it 'completes project immediately' do
          expect(project.complete?).to be_truthy
        end

        it 'triggers final payment' do
          expect(project.charges.count).to eq(2)
          expect(project.charges.sum(:amount_in_cents)).to eq(150_000)
          expect(project.charges.last.running_balance).to eq(0)
        end
      end

      context 'business disputes timesheet' do
        before do
          sign_in business.user
          put business_project_timesheet_path(project, timesheet, timesheet: { dispute: '1' }, format: :js)
          expect(response).to have_http_status(:ok)
          sign_out
          sign_in specialist.user
        end

        it 'specialist can add more timesheets' do
          expect do
            post project_timesheets_path(project),
                 timesheet: { save: '1', time_logs_attributes: [{ description: 'Dummy', hours: 5 }] },
                 format: :js
            expect(response).to have_http_status(:created)
          end.to change { project.timesheets.count }
        end

        it 'specialist can edit disputed timesheet' do
          log = timesheet.time_logs.last
          put project_timesheet_path(project, timesheet),
              timesheet: { submit: '1', time_logs_attributes: [{ id: log.id, hours: 2 }] },
              format: :js
          expect(response).to have_http_status(:ok)
          expect(log.reload.hours).to eq(2)
        end

        it 'project remains active' do
          project.reload
          expect(project.active?).to be_truthy
        end

        it 'allows one business day to re-submit' do
          previous_end = project.ends_on
          project.reload
          expect(project.ends_on - previous_end).to eq(1)
        end
      end
    end

    context 'no last timesheet is submitted' do
      before do
        Timecop.freeze project.hard_ends_on + 1.minute
      end

      it 'can no longer add timesheets' do
        sign_in specialist.user
        expect do
          post project_timesheets_path(project),
               timesheet: { save: '1', time_logs_attributes: [{ description: 'Dummy', hours: 5 }] },
               format: :js
          expect(response).to have_http_status(:forbidden)
        end.to_not change { project.timesheets.count }
      end
    end
  end
end
