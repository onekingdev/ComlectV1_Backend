# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::FiftyFifty, type: :model do
  before(:all) do
    @specialist = create :specialist
  end

  describe 'a fixed budget project with fifty-fifty pay' do
    before do
      @project = create :project_one_off_fixed,
                        payment_schedule: Project.payment_schedules[:fifty_fifty],
                        fixed_budget: 10_000,
                        starts_on: Date.new(2016, 1, 1),
                        ends_on: Date.new(2016, 3, 26)
      @job_application = create :job_application, project: @project, specialist: @specialist
    end

    it 'creates first charge and last estimate' do
      JobApplication::Accept.(@job_application)
      PaymentCycle.for(@project).reschedule!
      expect(@project.charges.estimated.count).to eq(1)
      dates = [
        @project.business.tz.local(2016, 1, 4, 0, 1),  # Not the 1st since that's a friday so we charge on monday
        @project.business.tz.local(2016, 3, 29, 0, 1), # ditto...
      ]
      charges = @project.charges.order(date: :asc)
      expect(charges.map(&:process_after).sort).to eq(dates)
      expect(charges.map(&:running_balance)).to eq([5500, 0])
      expect(charges.map(&:specialist_running_balance)).to eq([4500, 0])
    end

    it 'does not duplicate charges' do
      JobApplication::Accept.(@job_application)
      PaymentCycle.for(@project).create_charges_and_reschedule!
      PaymentCycle.for(@project).create_charges_and_reschedule!
      expect(@project.charges.count).to eq(2)
      dates = [Date.new(2016, 1, 1), Date.new(2016, 3, 26)]
      expect(@project.reload.charges.map { |ch| ch.date.to_date }.sort).to eq(dates)
    end

    context 'project ended early' do
      it 'reschedules charge' do
        new_end_date = @project.business.tz.local(2016, 1, 13, 12)
        JobApplication::Accept.(@job_application)
        Timecop.freeze(new_end_date) do
          request = ProjectEnd::Request.process! @project
          request.confirm!
          charges = @project.reload.charges.order(date: :asc)
          expect(charges.last.scheduled?).to be_truthy
          expect(charges.last.date.to_date).to eq(new_end_date.to_date)
        end
      end
    end
  end
end
