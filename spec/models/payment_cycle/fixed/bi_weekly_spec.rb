# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::BiWeekly, type: :model do
  before(:all) { @specialist = create(:specialist) }

  describe 'a fixed-budget project with bi-weekly pay' do
    before do
      @project = create(
        :project_one_off_fixed,
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

    context 'when project ends' do
      before do
        Timecop.freeze(@project.starts_on) do
          JobApplication::Accept.(@job_application)
        end

        Timecop.freeze(@project.ends_on + 1.day) do
          PaymentCycle.for(@project).create_charges_and_reschedule!
        end

        Timecop.freeze(@project.ends_on + 1.day + 30.minutes) do
          ProcessScheduledChargesJob.new.perform
        end
      end

      it 'creates a scheduled charge and processes it' do
        expect(@project.charges.processed.size).to eq(1)
      end
    end
  end
end
