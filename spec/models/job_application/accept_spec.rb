# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobApplication::Accept, type: :model do
  describe '.call' do
    let(:specialist) { create :specialist }

    let(:job_application) {
      create(
        :job_application,
        project: project,
        specialist: specialist
      )
    }

    before { JobApplication::Accept.(job_application) }

    context 'when full time upfront fee project' do
      let(:project) { create :project_full_time, business: business }

      context 'when business is fee free' do
        let(:business) { create :business, :fee_free }

        it 'does not schedule charges' do
          expect(project.reload.charges.size).to be_zero
        end
      end

      context 'when business is not fee free' do
        let(:business) { create :business }

        it 'schedules charges' do
          expect(project.reload.charges.size).to eq 1
        end
      end
    end

    context 'when full time monthly fee project' do
      let(:project) { create :project_full_time, :monthly_fee, business: business }

      context 'when business is fee free' do
        let(:business) { create :business, :fee_free }

        it 'does not schedule charges' do
          expect(project.reload.charges.size).to be_zero
        end
      end

      context 'when business is not fee free' do
        let(:business) { create :business }

        it 'schedules charges' do
          expect(project.reload.charges.size).to eq 6
        end
      end
    end
  end
end
