# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Hourly::UponCompletion, type: :model do
  before(:all) do
    @specialist = create :specialist
  end

  describe 'an hourly project with upon-completion pay' do
    before do
      @project = create(
        :project_one_off_hourly,
        payment_schedule: Project.payment_schedules[:upon_completion],
        starts_on: Date.new(2016, 1, 1),
        ends_on: Date.new(2016, 6, 18)
      )

      @job_application = create(
        :job_application,
        project: @project,
        specialist: @specialist
      )

      Timecop.freeze Date.new(2016, 1, 1)
    end

    after do
      Timecop.return
    end

    it 'creates a single estimated charge at end of project' do
      JobApplication::Accept.(@job_application)
      PaymentCycle.for(@project).reschedule!
      expect(@project.charges.estimated.count).to eq(1)
      charge = @project.charges.estimated.first
      process_after = charge.process_after.in_time_zone(@project.business.tz)
      expect(process_after).to eq(@project.business.tz.local(2016, 6, 21, 0, 1))
    end

    context 'when project is extended' do
      before do
        JobApplication::Accept.(@job_application)
        @project.update_attribute :ends_on, Date.new(2016, 6, 22)
      end

      it 'reschedules payment' do
        PaymentCycle.for(@project).reschedule!
        expect(@project.charges.estimated.count).to eq(1)
        charge = @project.charges.estimated.first
        process_after = charge.process_after.in_time_zone(@project.business.tz)
        expect(process_after).to eq(@project.business.tz.local(2016, 6, 23, 0, 1))
      end
    end

    context 'a timesheet is approved during the grace period' do
      before do
        Timecop.freeze @project.hard_ends_on - 12.hours
        @timesheet = create :timesheet, :approved, project: @project, specialist: @specialist, hours: 5
      end

      after do
        Timecop.return
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
