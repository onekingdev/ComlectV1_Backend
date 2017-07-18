# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Hourly::Monthly, type: :model do
  include TimesheetSpecHelper

  before(:all) do
    StripeMock.start
    @specialist = create(:specialist)
  end

  after(:all) do
    StripeMock.stop
  end

  describe 'an hourly project with monthly pay' do
    let(:business) { create(:business, :with_payment_profile) }

    before do
      Timecop.freeze(business.tz.local(2015, 12, 25)) do
        @project = create(
          :project_one_off_hourly,
          business: business,
          payment_schedule: Project.payment_schedules[:monthly],
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 6, 1),
          hourly_rate: 100,
          estimated_hours: 50
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

    it 'creates estimated charges every month' do
      Timecop.freeze(@project.starts_on) do
        PaymentCycle.for(@project).create_charges_and_reschedule!
      end

      expect(@project.charges.estimated.count).to eq(5)

      dates = @project.charges.estimated.pluck(:process_after).sort.map do |date|
        date.in_time_zone(@project.business.tz)
      end

      expected_dates = [
        @project.business.tz.local(2016, 2, 2, 0, 1),
        @project.business.tz.local(2016, 3, 2, 0, 1),
        @project.business.tz.local(2016, 4, 4, 0, 1),
        @project.business.tz.local(2016, 5, 2, 0, 1),
        @project.business.tz.local(2016, 6, 2, 0, 1)
      ]

      expect(dates).to eq(expected_dates)
    end

    it 'removes past estimates' do
      Timecop.freeze(@project.starts_on) do
        PaymentCycle.for(@project).create_charges_and_reschedule!
      end

      first_charge = @project.charges.estimated.first
      Timecop.freeze(first_charge.process_after + 2.days) do
        PaymentCycle.for(@project).create_charges_and_reschedule!
        estimated = @project.charges.estimated.order(date: :asc)
        expect(estimated.sum(:amount_in_cents)).to eq(500_000)
        expect(estimated.count).to eq(4)
        expect(estimated.first.process_after).to eq(@project.business.tz.local(2016, 3, 2, 0, 1))
      end
    end

    context 'in the middle of project with already paid work' do
      before do
        Timecop.freeze(@project.starts_on + 5.days) do
          log_timesheet @project, hours: 5
          PaymentCycle.for(@project).create_charges_and_reschedule!
        end
      end

      it 'creates real charge for first month' do
        expect(@project.charges.real.count).to eq(1)
        charge = @project.charges.real.first
        expect(charge.amount).to eq(5 * @project.hourly_rate)
        expect(charge.process_after).to eq(@project.business.tz.local(2016, 2, 2, 0, 1))
      end

      it 'creates remaining estimated charges' do
        expect(@project.charges.estimated.count).to eq(4)

        # $5000 total - $500 paid = $4500, $4500 / 4 remaining payments = $1,125
        expect(@project.charges.estimated.map(&:amount).uniq).to eq([1125])

        dates = [
          @project.business.tz.local(2016, 3, 2, 0, 1).utc,
          @project.business.tz.local(2016, 4, 4, 0, 1).utc,
          @project.business.tz.local(2016, 5, 2, 0, 1).utc,
          @project.business.tz.local(2016, 6, 2, 0, 1).utc
        ]

        expect(@project.charges.estimated.map(&:process_after).sort).to eq(dates)
      end
    end

    context 'when more than full amount paid' do
      before do
        Timecop.freeze(@project.starts_on + 5.days) do
          log_timesheet @project, hours: @project.estimated_hours + 10
          PaymentCycle.for(@project).create_charges_and_reschedule!
        end
      end

      it 'sets running balance at 0' do
        charge = @project.charges.scheduled.first
        expect(charge.running_balance_in_cents).to eq(0)
      end

      it 'does not add estimated charges' do
        expect(@project.charges.estimated.count).to eq(0)
      end
    end
  end
end
