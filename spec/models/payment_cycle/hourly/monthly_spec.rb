# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Hourly::Monthly, type: :model do
  include TimesheetSpecHelper

  describe 'an hourly project with monthly pay' do
    let(:business) { create(:business, :with_payment_profile) }
    let(:specialist) { create(:specialist) }

    before do
      Timecop.freeze(business.tz.local(2015, 12, 25)) do
        @project = create(
          :project_one_off_hourly,
          business: business,
          payment_schedule: Project.payment_schedules[:monthly],
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 6, 7),
          hourly_rate: 100,
          estimated_hours: 50
        )

        @job_application = create(
          :job_application,
          project: @project,
          specialist: specialist
        )

        Project::Form.find(@project.id).post!
        JobApplication::Accept.(@job_application)
      end
    end

    it 'creates estimated charges every month' do
      expect(@project.charges.estimated.count).to eq(6)

      dates = @project.charges.estimated.pluck(:process_after).sort.map do |date|
        date.in_time_zone(@project.business.tz).to_i
      end

      expected_dates = [
        @project.business.tz.local(2016, 2, 2).end_of_day.to_i,
        @project.business.tz.local(2016, 3, 2).end_of_day.to_i,
        @project.business.tz.local(2016, 4, 4).end_of_day.to_i,
        @project.business.tz.local(2016, 5, 2).end_of_day.to_i,
        @project.business.tz.local(2016, 6, 2).end_of_day.to_i,
        @project.business.tz.local(2016, 6, 8).end_of_day.to_i
      ]

      expect(dates).to eq(expected_dates)
    end

    it 'removes past estimates' do
      first_charge = @project.charges.estimated.first

      Timecop.freeze(first_charge.process_after + 2.days) do
        PaymentCycle.for(@project).create_charges_and_reschedule!
        estimated = @project.charges.estimated.order(date: :asc)
        expect(estimated.sum(:amount_in_cents)).to eq(500_000)
        expect(estimated.count).to eq(5)
        process_after = estimated.first.process_after.in_time_zone(business.tz)
        expect(process_after.to_i).to eq(business.tz.local(2016, 3, 2).end_of_day.to_i)
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
        aggregate_failures do
          expect(@project.charges.real.count).to eq(1)
          charge = @project.charges.real.first
          expect(charge.amount).to eq(5 * @project.hourly_rate)
          expect(
            charge.process_after.in_time_zone(business.tz).to_i
          ).to eq(@project.business.tz.local(2016, 2, 2).end_of_day.to_i)
          expect(charge.business_fee_in_cents).to eq(1674)
          expect(charge.specialist_fee_in_cents).to eq(charge.amount_in_cents * Charge::COMPLECT_FEE_PCT)
        end
      end

      it 'creates remaining estimated charges' do
        expect(@project.charges.estimated.count).to eq(5)

        # $5000 total - $500 paid = $4500, $4500 / 5 remaining payments = $900
        expect(@project.charges.estimated.map(&:amount).uniq).to eq([900])

        expected_dates = [
          @project.business.tz.local(2016, 3, 2).end_of_day.to_i,
          @project.business.tz.local(2016, 4, 4).end_of_day.to_i,
          @project.business.tz.local(2016, 5, 2).end_of_day.to_i,
          @project.business.tz.local(2016, 6, 2).end_of_day.to_i,
          @project.business.tz.local(2016, 6, 8).end_of_day.to_i
        ]

        process_after = @project.charges.estimated.map do |charge|
          charge.process_after.in_time_zone(business.tz).to_i
        end.sort

        expect(process_after).to eq(expected_dates)
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

    context 'when project is ended early' do
      before do
        Timecop.freeze(business.tz.local(2016, 1, 26, 5)) do
          request = ProjectEnd::Request.process!(@project)
          request.confirm!
        end
      end

      it 'reschedules payment' do
        expect(@project.reload.charges.size).to eq(1)
        charge = @project.charges.first
        process_after = charge.process_after.in_time_zone(business.tz).to_i
        expect(process_after).to eq(business.tz.local(2016, 1, 27).end_of_day.to_i)
      end
    end

    context 'when project is extended' do
      context 'when project has a scheduled charge' do
        before do
          Timecop.freeze(business.tz.local(2016, 6, 7, 0, 15)) do
            log_timesheet @project, hours: 5
            ScheduleChargesJob.new.perform(@project.id)
            request = ProjectExtension::Request.process!(@project, Date.new(2016, 6, 15))
            request.confirm!
          end
        end

        it 'reschedules payment' do
          expect(@project.charges.count).to eq(1)
          charge = @project.charges.scheduled.first
          process_after = charge.process_after.in_time_zone(business.tz).to_i
          expect(process_after).to eq(business.tz.local(2016, 6, 16).end_of_day.to_i)
        end
      end
    end
  end
end
