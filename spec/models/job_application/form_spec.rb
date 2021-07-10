# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobApplication::Form do
  describe 'validations' do
    describe 'enough_experience?' do
      let!(:industry) { create(:industry) }
      let!(:jurisdiction) { create(:jurisdiction) }

      let!(:specialist) {
        create(
          :specialist,
          industry_ids: [industry.id],
          jurisdiction_ids: [jurisdiction.id]
        )
      }

      # context 'when project is rfp' do
      #   let!(:project) {
      #     create(
      #       :project,
      #       :rfp,
      #       industry_ids: [industry.id],
      #       jurisdiction_ids: [jurisdiction.id],
      #       minimum_experience: 10
      #     )
      #   }
      #
      #   let(:application) {
      #     JobApplication::Form.new(
      #       project: project,
      #       specialist: specialist,
      #       message: 'This is my proposal',
      #       key_deliverables: 'reports',
      #       hourly_rate: 100,
      #       estimated_hours: 10,
      #       starts_on: Time.zone.today,
      #       ends_on: Time.zone.today + 30.days,
      #       hourly_payment_schedule: 'upon_completion'
      #     )
      #   }
      #
      #   it 'is valid' do
      #     expect_any_instance_of(Specialist).to receive_message_chain(
      #       :stripe_account,
      #       :verified?
      #     ).and_return(true)
      #
      #     expect(application).to be_valid
      #   end
      # end
      #
      # context 'when project is custom' do
      #   let!(:project) {
      #     create(
      #       :project_one_off,
      #       industry_ids: [industry.id],
      #       jurisdiction_ids: [jurisdiction.id],
      #       minimum_experience: 10
      #     )
      #   }
      #
      #   it 'is valid' do
      #     expect_any_instance_of(Specialist).to receive_message_chain(
      #       :stripe_account,
      #       :verified?
      #     ).and_return(true)
      #
      #     application = JobApplication::Form.new(
      #       project: project,
      #       specialist: specialist
      #     )
      #
      #     expect(application).to be_valid
      #   end
      # end
    end
  end

  describe '.apply!' do
    let(:specialist) {
      create(
        :specialist,
        industry_ids: project.industry_ids,
        jurisdiction_ids: project.jurisdiction_ids
      )
    }

    let(:params) { attributes_for(:job_application) }
    let(:form) { described_class.apply!(specialist, project, params) }

    before do
      allow_any_instance_of(Specialist).to receive_message_chain(
        :stripe_account,
        :verified?
      ).and_return(true)
    end

    context 'when auto matching applicants' do
      let(:project) { create(:project_one_off_hourly, :auto_match, minimum_experience: 0) }

      it 'receives the correct messages' do
        expect(Notification::Deliver).not_to receive(:project_application!)
        expect(JobApplication::Accept).to receive(:call)
        form
      end
    end

    context 'when interviewing applicants' do
      let(:project) { create(:project_one_off_hourly, :interview, minimum_experience: 0) }

      it 'receives the correct messages' do
        expect(Notification::Deliver).to receive(:project_application!)
        expect(JobApplication::Accept).not_to receive(:call)
        form
      end
    end
  end
end
