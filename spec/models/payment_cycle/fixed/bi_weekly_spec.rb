# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::BiWeekly, type: :model do
  before(:all) do
    @specialist = create :specialist
  end

  describe 'a fixed-budget project with bi-weekly pay' do
    before do
      @project = create :project_one_off_fixed,
                        payment_schedule: Project.payment_schedules[:bi_weekly],
                        fixed_budget: 10_000,
                        starts_on: Date.new(2016, 1, 1),
                        ends_on: Date.new(2016, 3, 24)
      @job_application = create :job_application, project: @project, specialist: @specialist
    end

    it 'creates estimated charges every other week' do
      JobApplication::Accept.(@job_application)
      PaymentCycle.for(@project).reschedule!
      expect(@project.charges.estimated.count).to eq(6)
      expected_dates = [
        @project.business.tz.local(2016, 1, 18, 0, 1), # Not the 15th since that's a friday so we charge on monday
        @project.business.tz.local(2016, 2, 1, 0, 1),  # and so on...
        @project.business.tz.local(2016, 2, 15, 0, 1),
        @project.business.tz.local(2016, 2, 29, 0, 1),
        @project.business.tz.local(2016, 3, 14, 0, 1),
        @project.business.tz.local(2016, 3, 25, 0, 1)
      ]
      dates = @project.charges.estimated.pluck(:process_after).sort.map do |date|
        date.in_time_zone(@project.business.tz)
      end
      expect(dates).to eq(expected_dates)
      amounts = @project.charges.estimated.order(:date).pluck(:amount_in_cents)
      expected_amounts = [166_667, 166_667, 166_667, 166_667, 166_667, 166_665]
      expect(amounts).to eq(expected_amounts)
    end

    context 'in the middle of project with already paid work' do
      include TimesheetSpecHelper

      before do
        JobApplication::Accept.(@job_application)
        Timecop.freeze @project.starts_on + 2.weeks + 1.day
        log_timesheet @project, hours: 5
        PaymentCycle.for(@project).create_charges_and_reschedule!
      end

      after do
        Timecop.return
      end

      it 'creates first real charge two weeks after start' do
        expect(@project.charges.real.count).to eq(1)
        charge = @project.charges.real.first
        expect(charge.amount).to eq(1666.67)
        expect(charge.process_after).to eq(@project.business.tz.local(2016, 1, 18, 0, 1))
      end

      it 'creates remaining estimated charges' do
        expect(@project.charges.estimated.count).to eq(5)
        expected_dates = [
          @project.business.tz.local(2016, 2, 1, 0, 1),
          @project.business.tz.local(2016, 2, 15, 0, 1),
          @project.business.tz.local(2016, 2, 29, 0, 1),
          @project.business.tz.local(2016, 3, 14, 0, 1),
          @project.business.tz.local(2016, 3, 25, 0, 1)
        ]
        dates = @project.charges.estimated.pluck(:process_after).sort.map do |date|
          date.in_time_zone(@project.business.tz)
        end
        expect(dates).to eq(expected_dates)
      end
    end
  end
end
