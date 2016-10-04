# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::UponCompletion, type: :model do
  before(:all) do
    @specialist = create :specialist
  end

  describe 'a fixed-budget project with upon-completion pay' do
    before do
      @project = create :project_one_off_fixed,
                        payment_schedule: Project.payment_schedules[:upon_completion],
                        fixed_budget: 10_000,
                        starts_on: Date.new(2016, 1, 1),
                        ends_on: Date.new(2016, 6, 18)
      @job_application = create :job_application, project: @project, specialist: @specialist
    end

    it 'creates a single estimated charge at end of project' do
      JobApplication::Accept.(@job_application)
      expect(@project.charges.estimated.count).to eq(1)
      charge = @project.charges.estimated.first
      expect(charge.amount).to eq(10_000)
      process_after = charge.process_after.in_time_zone(@project.business.tz)
      expect(process_after).to eq(@project.business.tz.local(2016, 6, 21, 0, 1))
    end

    context 'when project is extended' do
      before do
        JobApplication::Accept.(@job_application)
        @project.update_attribute :ends_on, Date.new(2016, 6, 22)
      end

      it 'reschedules payment' do
        PaymentCycle.for(@project).reschedule!
        expect(@project.charges.estimated.count).to eq(1)
        charge = @project.charges.estimated.first
        process_after = charge.process_after.in_time_zone(@project.business.tz)
        expect(process_after).to eq(@project.business.tz.local(2016, 6, 23, 0, 1))
      end
    end
  end
end
