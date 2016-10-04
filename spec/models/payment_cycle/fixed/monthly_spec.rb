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
                        starts_on: Date.new(2016, 1, 1),
                        ends_on: Date.new(2016, 6, 1)
      @job_application = create :job_application, project: @project, specialist: @specialist
    end

    it 'creates estimated charges every month' do
      JobApplication::Accept.(@job_application)
      expect(@project.charges.estimated.count).to eq(5)
      dates = @project.charges.estimated.pluck(:process_after).sort.map do |date|
        date.in_time_zone(@project.business.tz)
      end
      expected_dates = [
        @project.business.tz.local(2016, 2, 2, 0, 1),
        @project.business.tz.local(2016, 3, 2, 0, 1),
        @project.business.tz.local(2016, 4, 4, 0, 1),
        @project.business.tz.local(2016, 5, 3, 0, 1),
        @project.business.tz.local(2016, 6, 2, 0, 1)
      ]

      expect(dates).to eq(expected_dates)
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
        expect(charge.amount).to eq(2000)
        expect(charge.process_after).to eq(@project.business.tz.local(2016, 2, 2, 0, 1))
      end

      it 'creates remaining estimated charges' do
        expect(@project.charges.estimated.count).to eq(4)
        # $10,000 total - $2,000 paid = $8,000, $8,000 / 4 remaining payments = $2,000
        expect(@project.charges.estimated.map(&:amount).uniq).to eq([2000])
        dates = [
          @project.business.tz.local(2016, 3, 2, 0, 1),
          @project.business.tz.local(2016, 4, 4, 0, 1),
          @project.business.tz.local(2016, 5, 3, 0, 1),
          @project.business.tz.local(2016, 6, 2, 0, 1)
        ]
        expect(@project.charges.estimated.map(&:process_after).sort).to eq(dates)
      end
    end
  end
end
