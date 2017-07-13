# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::Monthly, type: :model do
  before(:all) do
    StripeMock.start
    @specialist = create(:specialist)
  end

  after(:all) do
    StripeMock.stop
  end

  describe 'a fixed-budget project with monthly pay' do
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
          payment_schedule: Project.payment_schedules[:monthly],
          fixed_budget: 100_000,
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 6, 17)
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
      Timecop.freeze(@project.starts_on + 1.day) do
        PaymentCycle.for(@project).create_charges_and_reschedule!
      end

      expect(@project.charges.estimated.count).to eq(6)

      dates = []
      amounts = []
      balances = []

      @project.charges.estimated.each do |charge|
        dates << charge.process_after.in_time_zone(@project.business.tz)
        amounts << BigDecimal.new(charge.amount_in_cents) / 100.0
        balances << [charge.running_balance, charge.specialist_running_balance]
      end

      expected_dates = [
        @project.business.tz.local(2016, 2, 1, 0, 1),
        @project.business.tz.local(2016, 3, 1, 0, 1),
        @project.business.tz.local(2016, 4, 1, 0, 1),
        @project.business.tz.local(2016, 5, 1, 0, 1),
        @project.business.tz.local(2016, 6, 1, 0, 1),
        @project.business.tz.local(2016, 6, 17, 0, 1)
      ]

      expected_amounts = [
        18_343.20,
        17_159.76,
        18_343.20,
        17_751.48,
        18_343.20,
        10_059.16
      ]

      expect(dates.sort).to eq(expected_dates)
      expect(amounts.map(&:to_f)).to eq(expected_amounts)
      expect(amounts.reduce(:+)).to eq(@project.fixed_budget)

      expect(balances).to eq(
        [
          [89_822.48, 73_491.12],
          [70_946.74, 58_047.332727272726],
          [50_769.22, 41_538.45272727272],
          [31_242.59, 25_562.119090909087],
          [11_065.07, 9053.23909090909],
          [0.0, 0.0]
        ]
      )
    end

    context 'in the middle of project with already paid work' do
      before do
        Timecop.freeze(@project.starts_on + 1.month + 5.days) do
          PaymentCycle.for(@project).create_charges_and_reschedule!
        end
      end

      it 'creates real charge for first month' do
        expect(@project.charges.real.count).to eq(1)
        charge = @project.charges.real.first
        expect(charge.process_after).to eq(@project.business.tz.local(2016, 2, 1, 0, 1))
      end

      it 'creates remaining estimated charges' do
        PaymentCycle.for(@project).reschedule!
        expect(@project.charges.estimated.count).to eq(5)
        expected_amounts = [17_159.76, 18_343.19, 17_751.48, 10_059.18]
        expect(@project.charges.estimated.map(&:amount).uniq).to eq(expected_amounts)

        dates = [
          @project.business.tz.local(2016, 3, 1, 0, 1),
          @project.business.tz.local(2016, 4, 1, 0, 1),
          @project.business.tz.local(2016, 5, 1, 0, 1),
          @project.business.tz.local(2016, 6, 1, 0, 1),
          @project.business.tz.local(2016, 6, 17, 0, 1)
        ]
        expect(@project.charges.estimated.map(&:process_after).sort).to eq(dates)
      end
    end

    context 'when project is ended early' do
      it 'reschedules charge' do
        Timecop.freeze(@project.starts_on + 1.month + 1.day) do
          ScheduleChargesJob.new.perform(@project.id)
          first_charge = @project.charges.first
          expect(first_charge.status).to eq('scheduled')
          expect(first_charge.process_after).to eq(@project.business.tz.local(2016, 2, 1, 0, 1))
          expect(first_charge.amount).to eq(18_343.20)
          ProcessScheduledChargesJob.new.perform
        end

        new_end_date = @project.business.tz.local(2016, 2, 13)
        Timecop.freeze(new_end_date) do
          request = ProjectEnd::Request.process!(@project)
          request.confirm!

          last_charge = @project.reload.charges.last
          expect(last_charge.scheduled?).to be(true)
          expect(last_charge.date.to_date).to eq(new_end_date.to_date)
          expect(last_charge.amount).to eq(81_656.80)
        end
      end
    end
  end
end
