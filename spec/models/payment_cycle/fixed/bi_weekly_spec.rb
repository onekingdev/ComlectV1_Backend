# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::BiWeekly, type: :model do
  before(:all) do
    StripeMock.start
    @specialist = create(:specialist)
  end

  after(:all) do
    StripeMock.stop
  end

  describe 'a fixed-budget project with bi-weekly pay' do
    before do
      Timecop.freeze(Date.new(2015, 12, 25)) do
        @business = create(
          :business,
          :with_payment_profile,
          time_zone: 'Pacific Time (US & Canada)'
        )

        @project = create(
          :project_one_off_fixed,
          business: @business,
          payment_schedule: Project.payment_schedules[:bi_weekly],
          fixed_budget: 10_000,
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 3, 24)
        )

        @job_application = create(
          :job_application,
          project: @project,
          specialist: @specialist
        )

        Project::Form.find(@project.id).post!
      end
    end

    it 'creates estimated charges every other week' do
      Timecop.freeze(@project.starts_on) do
        JobApplication::Accept.(@job_application)
        PaymentCycle.for(@project).reschedule!

        expect(@project.charges.estimated.count).to eq(6)

        expected_dates = [
          @project.business.tz.local(2016, 1, 15, 0, 1),
          @project.business.tz.local(2016, 1, 29, 0, 1),
          @project.business.tz.local(2016, 2, 12, 0, 1),
          @project.business.tz.local(2016, 2, 26, 0, 1),
          @project.business.tz.local(2016, 3, 11, 0, 1),
          @project.business.tz.local(2016, 3, 24, 0, 1)
        ]

        dates = @project.charges.pluck(:process_after).sort.map do |date|
          date.in_time_zone(@project.business.tz)
        end

        expect(dates).to eq(expected_dates)
        amounts = @project.charges.order(:date).pluck(:amount_in_cents)
        expected_amounts = [166_667, 166_667, 166_667, 166_667, 166_667, 166_665]
        expect(amounts).to eq(expected_amounts)
      end
    end

    context 'in the middle of project with already paid work' do
      before do
        Timecop.freeze(@project.starts_on) do
          JobApplication::Accept.(@job_application)
        end

        Timecop.freeze(@project.starts_on + 2.weeks + 1.day) do
          PaymentCycle.for(@project).create_charges_and_reschedule!
        end
      end

      it 'creates first real charge two weeks after start' do
        expect(@project.charges.real.count).to eq(1)
        charge = @project.charges.real.first
        expect(charge.amount).to eq(1666.67)
        expect(charge.process_after).to eq(@project.business.tz.local(2016, 1, 15, 0, 1))
      end

      it 'creates remaining estimated charges' do
        expect(@project.charges.estimated.count).to eq(5)

        expected_dates = [
          @project.business.tz.local(2016, 1, 29, 0, 1),
          @project.business.tz.local(2016, 2, 12, 0, 1),
          @project.business.tz.local(2016, 2, 26, 0, 1),
          @project.business.tz.local(2016, 3, 11, 0, 1),
          @project.business.tz.local(2016, 3, 24, 0, 1)
        ]

        dates = @project.charges.estimated.pluck(:process_after).sort.map do |date|
          date.in_time_zone(@project.business.tz)
        end

        expect(dates).to eq(expected_dates)
      end
    end

    context 'when full billing cycle' do
      before do
        Timecop.freeze(@project.starts_on) do
          JobApplication::Accept.(@job_application)
        end
      end

      it 'creates, schedules, and processes charges' do
        Timecop.freeze(@project.starts_on + 2.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(1)
        end

        Timecop.freeze(@project.starts_on + 4.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(2)
        end

        Timecop.freeze(@project.starts_on + 6.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(3)
        end

        # check off weeks too
        Timecop.freeze(@project.starts_on + 7.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(3)
        end

        Timecop.freeze(@project.starts_on + 8.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(4)
        end

        Timecop.freeze(@project.starts_on + 10.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(5)
        end

        # check off weeks too
        Timecop.freeze(@project.starts_on + 11.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(5)
        end

        Timecop.freeze(@project.ends_on + 2.days) do
          EndProjectsJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(6)
        end

        Timecop.freeze(@project.ends_on + 2.days + 30.minutes) do
          ProcessScheduledChargesJob.new.perform
          expect(@project.charges.size).to eq(6)
          expect(@project.charges.processed.size).to eq(6)
        end
      end
    end
  end
end
