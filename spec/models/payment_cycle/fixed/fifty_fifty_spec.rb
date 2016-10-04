# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::FiftyFifty, type: :model do
  before(:all) do
    @specialist = create :specialist
  end

  describe 'an fixed budget project with fifty-fifty pay' do
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
      expect(@project.charges.estimated.count).to eq(1)
      dates = [
        @project.business.tz.local(2016, 1, 4, 0, 1),  # Not the 1st since that's a friday so we charge on monday
        @project.business.tz.local(2016, 3, 29, 0, 1), # ditto...
      ]
      expect(@project.charges.map(&:process_after).sort).to eq(dates)
    end
  end
end
