# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::FiftyFifty, type: :model do
  describe 'a fixed budget project with fifty-fifty pay' do
    let(:business) { create(:business, :with_payment_profile) }
    let(:specialist) { create(:specialist) }

    before do
      Timecop.freeze(Date.new(2016, 1, 1).end_of_day) do
        @project = create(
          :project_one_off_fixed,
          business: business,
          payment_schedule: Project.payment_schedules[:fifty_fifty],
          fixed_budget: 10_000,
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 3, 24),
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

    it 'creates first charge and last estimate' do
      expect(@project.charges.scheduled.count).to eq(1)
      expect(@project.charges.estimated.count).to eq(1)

      dates = [
        business.tz.local(2016, 1, 1).end_of_day.to_i,
        business.tz.local(2016, 3, 24).end_of_day.to_i
      ]

      charges = @project.charges.order(date: :asc)
      expect(charges.map { |charge| charge.process_after.in_time_zone(business.tz).to_i }.sort).to eq(dates)
      expect(charges.map(&:running_balance)).to eq([5000.0, 0.0])
      expect(charges.map(&:specialist_running_balance)).to eq([5000.0, 0.0])
    end

    it 'does not duplicate charges' do
      PaymentCycle.for(@project).create_charges_and_reschedule!
      PaymentCycle.for(@project).create_charges_and_reschedule!
      expect(@project.reload.charges.count).to eq(2)

      dates = [Date.new(2016, 1, 1), Date.new(2016, 3, 24)]
      expect(
        @project.reload.charges.map { |charge| charge.date.to_date }.sort
      ).to eq(dates)
    end

    it 'creates last charge' do
      Timecop.freeze(@project.ends_on + 2.days) do
        EndProjectsJob.new.perform(@project.id)
        expect(@project.reload.charges.scheduled.size).to eq(2)
      end
    end

    context 'when project is ended early' do
      it 'reschedules charge' do
        new_end_date = business.tz.local(2016, 1, 13)
        Timecop.freeze(new_end_date) do
          request = ProjectEnd::Request.process! @project
          request.confirm!

          charges = @project.reload.charges.order(date: :asc)
          expect(charges.last.scheduled?).to be(true)
          expect(charges.last.date.to_date).to eq(new_end_date.to_date)
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
          expect(@project.reload.charges.count).to eq(2)
          charge = @project.charges.estimated.last
          process_after = charge.process_after.in_time_zone(business.tz).to_i
          expect(process_after).to eq(business.tz.local(2016, 3, 28).end_of_day.to_i)
        end
      end
    end
  end
end
