# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Hourly::UponCompletion, type: :model do
  include TimesheetSpecHelper

  before(:all) do
    StripeMock.start
    @specialist = create(:specialist)
  end

  after(:all) do
    StripeMock.stop
  end

  describe 'an hourly project with upon-completion pay' do
    let(:business) { create(:business, :with_payment_profile) }

    before do
      Timecop.freeze(business.tz.local(2015, 12, 25)) do
        @project = create(
          :project_one_off_hourly,
          business: business,
          payment_schedule: Project.payment_schedules[:upon_completion],
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 1, 15)
        )

        @job_application = create(
          :job_application,
          project: @project,
          specialist: @specialist
        )

        Project::Form.find(@project.id).post!
        JobApplication::Accept.(@job_application)
      end
    end

    it 'creates a single estimated charge at end of project' do
      expect(@project.charges.estimated.count).to eq(1)
      charge = @project.charges.estimated.first
      process_after = charge.process_after.in_time_zone(@project.business.tz).to_i
      expect(process_after).to eq(@project.business.tz.local(2016, 1, 18).end_of_day.to_i)
    end

    context 'when project is extended' do
      context 'when project has a scheduled charge' do
        before do
          Timecop.freeze(business.tz.local(2016, 1, 15, 0, 15)) do
            log_timesheet @project, hours: 5
            ScheduleChargesJob.new.perform(@project.id)
            request = ProjectExtension::Request.process!(@project, Date.new(2016, 1, 25))
            request.confirm!
          end
        end

        it 'reschedules payment' do
          expect(@project.charges.count).to eq(1)
          charge = @project.charges.scheduled.first
          process_after = charge.process_after.in_time_zone(business.tz).to_i
          expect(process_after).to eq(business.tz.local(2016, 1, 26).end_of_day.to_i)
        end
      end
    end

    context 'when project is ended early' do
      before do
        Timecop.freeze(business.tz.local(2016, 1, 10, 5)) do
          request = ProjectEnd::Request.process!(@project)
          request.confirm!
        end
      end

      it 'reschedules payment' do
        expect(@project.charges.size).to eq(1)
        charge = @project.charges.first
        process_after = charge.process_after.in_time_zone(business.tz).to_i
        expect(process_after).to eq(business.tz.local(2016, 1, 11).end_of_day.to_i)
      end
    end

    context 'a timesheet is approved during the grace period' do
      before do
        Timecop.freeze(@project.hard_ends_on - 12.hours) do
          @timesheet = create(
            :timesheet,
            :approved,
            project: @project,
            specialist: @specialist,
            hours: 5
          )
        end
      end

      it 'generates payment after the fact' do
        Project::Ending.process!(@project)
        ScheduleChargesJob.new.perform(@project.id)
        Timecop.freeze(@project.hard_ends_on + 1.day) { ScheduleChargesJob.new.perform(@project.id) }
        expect(@project.reload.charges.count).to eq(1)
      end

      it 'does not generate duplicate payment later' do
        Project::Ending.process!(@project)
        ScheduleChargesJob.new.perform(@project.id)
        Timecop.freeze(@project.hard_ends_on + 1.day) { ScheduleChargesJob.new.perform(@project.id) }
        expect(@project.reload.charges.count).to eq(1)
      end
    end
  end
end
