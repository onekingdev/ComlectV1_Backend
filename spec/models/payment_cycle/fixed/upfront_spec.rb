# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::Upfront, type: :model do
  describe 'a fixed-budget project with upfront fee pay' do
    let(:business) { create(:business, :with_payment_profile) }
    let(:specialist) { create(:specialist) }

    before do
      Timecop.freeze(Date.new(2015, 12, 25)) do
        @project = create(
          :project_one_off_fixed,
          business: business,
          payment_schedule: Project.payment_schedules[:upfront],
          fixed_budget: 10_000,
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 2, 1)
        )

        @job_application = create(
          :job_application,
          project: @project,
          specialist: specialist
        )

        Project::Form.find(@project.id).post!
        JobApplication::Accept.(@job_application)
      end
    end

    it 'creates a charge' do
      expect(@project.charges.scheduled.count).to eq(1)
      expect(@project.charges.estimated.count).to eq(0)

      charge = @project.charges.first
      expect(charge.process_after.in_time_zone(business.tz).to_i).to eq(
        business.tz.local(2016, 1, 1).end_of_day.to_i
      )
      expect(charge.running_balance).to eq 0.0
      expect(charge.specialist_running_balance).to eq 0.0
    end

    it 'does not duplicate charges' do
      PaymentCycle.for(@project).create_charges_and_reschedule!
      PaymentCycle.for(@project).create_charges_and_reschedule!

      expect(@project.reload.charges.count).to eq(1)

      charge = @project.charges.first
      expect(charge.date.to_date).to eq Date.new(2016, 1, 1)
    end

    context 'when project is ended early' do
      it 'does not reschedule charge' do
        new_end_date = business.tz.local(2016, 1, 13)
        Timecop.freeze(new_end_date) do
          request = ProjectEnd::Request.process! @project
          request.confirm!

          charges = @project.reload.charges.order(date: :asc)
          expect(charges.count).to eq 1
          expect(charges.first.date.to_date).to eq Date.new(2016, 1, 1)
        end
      end
    end

    context 'when project is extended' do
      before do
        Timecop.freeze(business.tz.local(2016, 3, 24, 0, 15)) do
          ScheduleChargesJob.new.perform(@project.id)
          request = ProjectExtension::Request.process!(@project, Date.new(2016, 3, 28))
          request.confirm!
        end
      end

      it 'does not reschedule charge' do
        charges = @project.reload.charges.order(date: :asc)
        expect(charges.count).to eq 1
        expect(charges.first.date.to_date).to eq Date.new(2016, 1, 1)
      end
    end
  end
end
