# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Hourly::BiWeekly, type: :model do
  before(:all) do
    StripeMock.start
    @specialist = create(:specialist)
  end

  after(:all) do
    StripeMock.stop
  end

  describe 'an hourly project with bi-weekly pay' do
    let(:business) { create(:business, :with_payment_profile) }

    before do
      Timecop.freeze(business.tz.local(2015, 12, 25)) do
        @project = create(
          :project_one_off_hourly,
          business: business,
          payment_schedule: Project.payment_schedules[:bi_weekly],
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 3, 26)
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

    it 'creates estimated charges every other week' do
      Timecop.freeze(@project.starts_on) do
        PaymentCycle.for(@project).create_charges_and_reschedule!
      end

      expect(@project.charges.estimated.count).to eq(7)

      expected_dates = [
        # Not the 15th since that's a friday so we charge on monday
        @project.business.tz.local(2016, 1, 18).end_of_day.to_i,
        @project.business.tz.local(2016, 2, 1).end_of_day.to_i,
        @project.business.tz.local(2016, 2, 15).end_of_day.to_i,
        @project.business.tz.local(2016, 2, 29).end_of_day.to_i,
        @project.business.tz.local(2016, 3, 14).end_of_day.to_i,
        # the final bi-weekly and upon completion charge both fall in the buffer zone
        @project.business.tz.local(2016, 3, 28).end_of_day.to_i,
        @project.business.tz.local(2016, 3, 28).end_of_day.to_i
      ]

      process_after_dates = @project.charges.estimated.map do |charge|
        charge.process_after.in_time_zone(business.tz).to_i
      end.sort

      expect(process_after_dates).to eq(expected_dates)
    end

    context 'in the middle of project with already paid work' do
      include TimesheetSpecHelper

      before do
        Timecop.freeze(@project.starts_on + 1.week) do
          log_timesheet @project, hours: 5
          PaymentCycle.for(@project).create_charges_and_reschedule!
        end
      end

      it 'creates first real charge two weeks after start' do
        expect(@project.charges.real.count).to eq(1)
        charge = @project.charges.real.first
        expect(charge.amount).to eq(5 * @project.hourly_rate)
        process_after = charge.process_after.in_time_zone(business.tz).to_i
        expect(process_after).to eq(business.tz.local(2016, 1, 18).end_of_day.to_i)
      end

      it 'creates remaining estimated charges' do
        expect(@project.charges.estimated.count).to eq(6)

        # $5000 total - $500 paid = $4500, $4500 / 6 remaining payments = $900
        expect(@project.charges.estimated.map(&:amount).uniq).to eq([750])

        expected_dates = [
          @project.business.tz.local(2016, 2, 1).end_of_day.to_i,
          @project.business.tz.local(2016, 2, 15).end_of_day.to_i,
          @project.business.tz.local(2016, 2, 29).end_of_day.to_i,
          @project.business.tz.local(2016, 3, 14).end_of_day.to_i,
          @project.business.tz.local(2016, 3, 28).end_of_day.to_i,
          @project.business.tz.local(2016, 3, 28).end_of_day.to_i
        ]

        process_after_dates = @project.charges.estimated.map do |charge|
          charge.process_after.in_time_zone(business.tz).to_i
        end.sort

        expect(process_after_dates).to eq(expected_dates)
      end
    end
  end
end
