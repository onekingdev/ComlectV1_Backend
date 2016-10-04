# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PaymentCycle::Hourly::Monthly, type: :model do
  before(:all) do
    @specialist = create :specialist
  end

  describe 'an hourly project with bi-weekly pay' do
    before do
      @project = create :project_one_off_hourly,
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
      pending 'it creates remaining estimated charges'
    end
  end
end
