# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::BiWeekly, type: :model do
  describe 'a fixed-budget project with bi-weekly pay' do
    let(:business) { create(:business, :with_payment_profile) }
    let(:specialist) { create(:specialist) }
    let(:ends_on) { Date.new(2016, 3, 24) }

    before do
      Timecop.freeze(business.tz.local(2015, 12, 25)) do
        @project = create(
          :project_one_off_fixed,
          business: business,
          payment_schedule: Project.payment_schedules[:bi_weekly],
          fixed_budget: 10_000,
          starts_on: Date.new(2016, 1, 1),
          ends_on: ends_on,
          role_details: 'role_details',
          est_budget: 5000
        )

        @job_application = create(
          :job_application,
          project: @project,
          specialist: specialist
        )

        Project::Form.find(@project.id).post!
        JobApplication::Accept.call(@job_application)
      end
    end

    it 'creates estimated charges every other week' do
      expect(@project.charges.estimated.count).to eq(6)

      expected_dates = [
        @project.business.tz.local(2016, 1, 15).end_of_day.to_i,
        @project.business.tz.local(2016, 1, 29).end_of_day.to_i,
        @project.business.tz.local(2016, 2, 12).end_of_day.to_i,
        @project.business.tz.local(2016, 2, 26).end_of_day.to_i,
        @project.business.tz.local(2016, 3, 11).end_of_day.to_i,
        @project.business.tz.local(2016, 3, 24).end_of_day.to_i
      ]

      dates = @project.charges.pluck(:process_after).sort.map do |date|
        date.in_time_zone(@project.business.tz).to_i
      end
      expect(dates).to eq(expected_dates)

      amounts = @project.charges.order(:date).pluck(:amount_in_cents)
      expected_amounts = [166_667, 166_667, 166_667, 166_667, 166_667, 166_665]
      expect(amounts).to eq(expected_amounts)
    end

    context 'in the middle of project with already paid work' do
      before do
        Timecop.freeze(@project.starts_on + 2.weeks + 1.day) do
          PaymentCycle.for(@project).create_charges_and_reschedule!
        end
      end

      it 'creates first real charge two weeks after start' do
        expect(@project.charges.real.count).to eq(1)
        charge = @project.charges.real.first
        expect(charge.amount).to eq(1666.67)

        expect(
          charge.process_after.in_time_zone(business.tz).to_i
        ).to eq(@project.business.tz.local(2016, 1, 15).end_of_day.to_i)
      end

      it 'creates remaining estimated charges' do
        expect(@project.charges.estimated.count).to eq(5)

        expected_dates = [
          @project.business.tz.local(2016, 1, 29).end_of_day.to_i,
          @project.business.tz.local(2016, 2, 12).end_of_day.to_i,
          @project.business.tz.local(2016, 2, 26).end_of_day.to_i,
          @project.business.tz.local(2016, 3, 11).end_of_day.to_i,
          @project.business.tz.local(2016, 3, 24).end_of_day.to_i
        ]

        dates = @project.charges.estimated.pluck(:process_after).sort.map do |date|
          date.in_time_zone(@project.business.tz).to_i
        end

        expect(dates).to eq(expected_dates)
      end
    end

    context 'when ending between periods' do
      let(:ends_on) { Date.new(2016, 1, 22) }

      it 'creates the first biweekly estimated charge and another estimated upon completion charge' do
        expect(@project.charges.estimated.count).to eq(2)

        expected_dates = [
          @project.business.tz.local(2016, 1, 15).end_of_day.to_i,
          @project.business.tz.local(2016, 1, 22).end_of_day.to_i
        ]

        dates = @project.charges.pluck(:process_after).sort.map do |date|
          date.in_time_zone(@project.business.tz).to_i
        end
        expect(dates).to eq(expected_dates)

        amounts = @project.charges.order(:date).pluck(:amount_in_cents)
        expected_amounts = [636_364, 363_636]
        expect(amounts).to eq(expected_amounts)
      end

      it 'schedules and processes charges' do
        Timecop.freeze(@project.starts_on + 2.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(1)
          expect(@project.charges.scheduled.last.amount_in_cents).to eq(636_364)
        end

        Timecop.freeze(@project.ends_on + 2.days) do
          EndProjectsJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(2)
          expect(@project.charges.scheduled.last.amount_in_cents).to eq(363_636)
        end

        Timecop.freeze(@project.ends_on + 2.days + 30.minutes) do
          ProcessScheduledChargesJob.new.perform
          expect(@project.charges.size).to eq(2)
          expect(@project.charges.processed.size).to eq(2)
        end
      end
    end

    context 'when ended early' do
      it 'schedules charges' do
        Timecop.freeze(@project.starts_on + 2.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(1)
          expect(@project.charges.scheduled.last.amount).to eq(1666.67)
        end

        Timecop.freeze(@project.starts_on + 2.weeks + 2.days) do
          ProcessScheduledChargesJob.new.perform
          expect(@project.charges.real.size).to eq(1)
        end

        Timecop.freeze(@project.starts_on + 4.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.real.size).to eq(2)
          expect(@project.charges.scheduled.last.amount).to eq(1666.67)
        end

        Timecop.freeze(@project.starts_on + 4.weeks + 2.days) do
          ProcessScheduledChargesJob.new.perform
          expect(@project.charges.real.size).to eq(2)
        end

        new_end_date = business.tz.local(2016, 2, 10)
        Timecop.freeze(new_end_date) do
          request = ProjectEnd::Request.process!(@project)
          request.confirm!

          last_charge = @project.reload.charges.last
          expect(last_charge).to be_scheduled
          expect(last_charge.date.to_date).to eq(Date.new(2016, 2, 10))
          expect(last_charge.amount).to eq(6666.66)
        end
      end
    end

    context 'when project is ended early and on the same day' do
      it 'schedules charges' do
        Timecop.freeze(business.tz.local(2016, 1, 1, 20, 0)) do
          request = ProjectEnd::Request.process!(@project)
          request.confirm!
          last_charge = @project.reload.charges.last
          expect(last_charge).to be_scheduled
          expect(last_charge.date.to_date).to eq(Date.new(2016, 1, 1))
          expect(last_charge.amount) .to eq 10_000
        end
      end
    end

    context 'when project is extended' do
      context 'when project has a scheduled charge' do
        before do
          Timecop.freeze(business.tz.local(2016, 3, 24, 0, 15)) do
            ScheduleChargesJob.new.perform(@project.id)
            request = ProjectExtension::Request.process!(@project, ends_on: Date.new(2016, 3, 28))
            request.confirm!
          end
        end

        it 'reschedules final charge' do
          expect(@project.reload.charges.count).to eq(7)
          charge = @project.charges.estimated.last
          process_after = charge.process_after.in_time_zone(business.tz).to_i
          expect(process_after).to eq(business.tz.local(2016, 3, 28).end_of_day.to_i)
        end
      end
    end

    context 'when full billing cycle' do
      it 'schedules and processes charges' do
        Timecop.freeze(@project.starts_on + 2.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(1)
        end

        Timecop.freeze(@project.starts_on + 4.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(2)
        end

        Timecop.freeze(@project.starts_on + 6.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(3)
        end

        # check off weeks too
        Timecop.freeze(@project.starts_on + 7.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(3)
        end

        Timecop.freeze(@project.starts_on + 8.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(4)
        end

        Timecop.freeze(@project.starts_on + 10.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(5)
        end

        # check off weeks too
        Timecop.freeze(@project.starts_on + 11.weeks + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(5)
        end

        Timecop.freeze(@project.ends_on + 2.days) do
          EndProjectsJob.new.perform(@project.id)
          expect(@project.charges.scheduled.size).to eq(6)
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
