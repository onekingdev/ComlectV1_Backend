# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Hourly project end scenarios', type: :request do
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
          put business_project_timesheet_path(project, timesheet), xhr: true, params: { timesheet: { approve: '1' } }
          expect(response).to have_http_status(:ok)
          project.reload
        end

        it 'allows time before ending project' do
          expect(project.complete?).to be_falsey
        end
      end

      context 'business disputes timesheet' do
        before do
          sign_in business.user
          put business_project_timesheet_path(project, timesheet), params: { timesheet: { dispute: '1' } }, xhr: true
          expect(response).to have_http_status(:ok)
          sign_out
          sign_in specialist.user
        end

        it 'specialist can add more timesheets' do
          expect do
            post(
              project_timesheets_path(project), params: {
                timesheet: {
                  save: '1',
                  time_logs_attributes: [attributes_for(:time_log)]
                }
              },
                                                xhr: true
            )

            expect(response).to have_http_status(:created)
          end.to change { project.timesheets.count }
        end

        it 'specialist can edit disputed timesheet' do
          log = timesheet.time_logs.last

          put(
            project_timesheet_path(project, timesheet), params: {
              timesheet: {
                submit: '1',
                time_logs_attributes: [{ id: log.id, hours: 2 }]
              }
            },
                                                        xhr: true
          )

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
          post(
            project_timesheets_path(project), params: {
              timesheet: {
                save: '1',
                time_logs_attributes: [{ description: 'Dummy', hours: 5 }]
              }
            },
                                              xhr: true
          )

          expect(response).to have_http_status(:forbidden)
        end.to_not change { project.timesheets.count }
      end
    end
  end

  context 'payment upon completion' do
    let(:business) { create(:business) }
    let(:specialist) { create(:specialist) }

    # Hourly rate: $100, estimated hours: 50
    let(:project) do
      create(
        :project_one_off_hourly,
        :published,
        :upon_completion_pay,
        business: business,
        specialist: specialist
      )
    end

    let(:first_timesheet) do
      create(
        :timesheet,
        :approved,
        project: project,
        hours: 10
      )
    end

    before do
      Timecop.freeze(project.starts_on + 2.days) { first_timesheet } # Trigger creation
      Timecop.freeze(project.ends_on.in_time_zone(business.tz) + 12.hours)
      PaymentCycle.for(project).create_charges_and_reschedule!
    end

    after do
      Timecop.return
    end

    context 'specialist submits last timesheet' do
      let(:last_timesheet) do
        create(
          :timesheet,
          :submitted,
          project: project,
          hours: 5
        )
      end

      context 'business disputes timesheet' do
        before do
          sign_in business.user

          put business_project_timesheet_path(
            project,
            last_timesheet
          ), params: {
            timesheet: { dispute: '1' }
          },
             xhr: true
          expect(response).to have_http_status(:ok)

          sign_out
          sign_in specialist.user
        end

        it 'does not generate any real payments' do
          expect do
            PaymentCycle.for(project).create_charges_and_reschedule!
          end.to_not change { Charge.real.count }
        end
      end

      context 'business approves timesheet' do
        before do
          sign_in business.user

          put business_project_timesheet_path(project, last_timesheet),
              params: { timesheet: { approve: '1' } }, xhr: true
          expect(response).to have_http_status(:ok)

          project.reload
        end

        it 'creates final charges' do
          Project::Ending.process!(project)
          charges = project.reload.charges
          expect(charges.size).to eq(2)
          expect(charges.map(&:status).uniq).to eq(['scheduled'])
          expect(charges.map(&:amount).reduce(:+)).to eq(1500)
        end
      end
    end
  end
end
