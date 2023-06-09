# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentCycle::Fixed::UponCompletion, type: :model do
  describe 'a fixed-budget project with upon-completion pay' do
    let(:business) { create(:business, :with_payment_profile) }
    let(:specialist) { create(:specialist) }

    before do
      Timecop.freeze(Date.new(2015, 12, 25)) do
        @project = create(
          :project_one_off_fixed,
          business: business,
          payment_schedule: Project.payment_schedules[:upon_completion],
          fixed_budget: 10_000,
          starts_on: Date.new(2016, 1, 1),
          ends_on: Date.new(2016, 2, 1),
          role_details: 'role_details',
          est_budget: 5000
        )

        @job_application = create(
          :job_application,
          project: @project,
          specialist: specialist
        )

        Project::Form.find(@project.id).post!

        expect(@project.charges.estimated.count).to be_zero

        JobApplication::Accept.call(@job_application)
      end
    end

    context 'creates a single estimated charge at end of project' do
      let(:charge) { @project.charges.estimated.first }
      let(:process_after) { charge.process_after.in_time_zone(business.tz) }

      it { expect(charge.amount).to eq(10_000) }
      it { expect(@project.charges.estimated.count).to eq(1) }
      it { expect(charge.specialist_fee_in_cents).to be_zero }
      it { expect(process_after.to_i).to eq(business.tz.local(2016, 2, 1).end_of_day.to_i) }
    end

    context 'when project is ended early' do
      before do
        Timecop.freeze(business.tz.local(2016, 1, 16)) do
          request = ProjectEnd::Request.process!(@project)
          request.confirm!
        end
      end

      it 'reschedules charge' do
        expect(@project.reload.charges.count).to eq(1)
        charge = @project.reload.charges.first
        expect(charge.amount).to eq(@project.fixed_budget)
        process_after = charge.process_after.in_time_zone(business.tz).to_i
        expect(process_after).to eq(business.tz.local(2016, 1, 16).end_of_day.to_i)
      end
    end

    context 'when project is extended' do
      context 'when project has a scheduled charge' do
        before do
          Timecop.freeze(business.tz.local(2016, 2, 1, 0, 15)) do
            ScheduleChargesJob.new.perform(@project.id)
            request = ProjectExtension::Request.process!(@project, ends_on: Date.new(2016, 2, 10))
            request.confirm!
          end
        end

        it 'reschedules charge' do
          expect(@project.reload.charges.count).to eq(1)
          charge = @project.charges.estimated.first
          expect(charge.amount).to eq(@project.fixed_budget)
          process_after = charge.process_after.in_time_zone(business.tz).to_i
          expect(process_after).to eq(business.tz.local(2016, 2, 10).end_of_day.to_i)
        end
      end
    end
  end
end
