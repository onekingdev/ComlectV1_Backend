# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::Monthly, type: :model do
  before(:all) do
    @specialist = create :specialist
  end

  describe 'a fixed-budget project with monthly pay' do
    before do
      @project = create :project_one_off_fixed,
                        payment_schedule: Project.payment_schedules[:monthly],
                        fixed_budget: 100_000,
                        starts_on: Date.new(2016, 1, 1),
                        ends_on: Date.new(2016, 6, 17)
      @job_application = create :job_application, project: @project, specialist: @specialist
    end

    it 'creates estimated charges every month' do
      JobApplication::Accept.(@job_application)
      expect(@project.charges.estimated.count).to eq(6)
      dates = []
      amounts = []
      @project.charges.estimated.each do |charge|
        dates << charge.process_after.in_time_zone(@project.business.tz)
        amounts << BigDecimal.new(charge.amount_in_cents) / 100.0
      end
      expected_dates = [
        @project.business.tz.local(2016, 2, 2, 0, 1),
        @project.business.tz.local(2016, 3, 2, 0, 1),
        @project.business.tz.local(2016, 4, 4, 0, 1),
        @project.business.tz.local(2016, 5, 3, 0, 1),
        @project.business.tz.local(2016, 6, 2, 0, 1),
        @project.business.tz.local(2016, 6, 20, 0, 1)
      ]
      expected_amounts = [18_934.91, 17_159.76, 18_343.20, 17_751.48, 18_343.20, 9_467.45]
      expect(dates.sort).to eq(expected_dates)
      expect(amounts.reduce(:+)).to eq(@project.fixed_budget)
      expect(amounts.map(&:to_f)).to eq(expected_amounts)
    end

    context 'in the middle of project with already paid work' do
      before do
        JobApplication::Accept.(@job_application)
        Timecop.freeze @project.starts_on + 1.month + 5.days
        PaymentCycle.for(@project).create_charges_and_reschedule!
      end

      after do
        Timecop.return
      end

      it 'creates real charge for first month' do
        expect(@project.charges.real.count).to eq(1)
        charge = @project.charges.real.first
        expect(charge.process_after).to eq(@project.business.tz.local(2016, 2, 2, 0, 1))
      end

      it 'creates remaining estimated charges' do
        expect(@project.charges.estimated.count).to eq(5)
        expected_amounts = [17_159.76, 18_343.2, 17_751.48, 9_467.45]
        expect(@project.charges.estimated.map(&:amount).uniq).to eq(expected_amounts)
        dates = [
          @project.business.tz.local(2016, 3, 2, 0, 1),
          @project.business.tz.local(2016, 4, 4, 0, 1),
          @project.business.tz.local(2016, 5, 3, 0, 1),
          @project.business.tz.local(2016, 6, 2, 0, 1),
          @project.business.tz.local(2016, 6, 20, 0, 1)
        ]
        expect(@project.charges.estimated.map(&:process_after).sort).to eq(dates)
      end
    end
  end
end
