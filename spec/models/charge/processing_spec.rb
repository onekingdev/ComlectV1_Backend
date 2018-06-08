# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Charge::Processing, type: :model do
  before(:all) do
    StripeMock.start
  end

  after(:all) do
    StripeMock.stop
  end

  describe 'a set of scheduled charges' do
    let(:specialist) { create(:specialist) }

    context 'when full time project' do
      let(:project) do
        create(
          :project_full_time,
          business: business,
          payment_schedule: Project.payment_schedules[:hourly],
          starts_on: Date.new(2016, 1, 1)
        )
      end

      before do
        Timecop.freeze(business.tz.local(2015, 12, 25)) do
          job_application = create(
            :job_application,
            project: project,
            specialist: specialist
          )

          Project::Form.find(project.id).post!
          JobApplication::Accept.(job_application)
        end

        Charge::Processing.process_scheduled!
      end

      context 'when fee free' do
        let(:business) { create(:business, :with_payment_profile, :fee_free) }

        it 'sets the correct amount' do
          transaction = project.transactions.first
          expect(transaction.amount_in_cents).to eq(0)
        end
      end

      context 'when not fee free' do
        let(:business) { create(:business, :with_payment_profile) }

        it 'sets the correct amount' do
          transaction = project.transactions.first
          expect(transaction.amount_in_cents).to eq(project.annual_salary * 15)
        end
      end
    end

    context 'with disputed timesheets' do
      let!(:project) do
        create(
          :project_one_off_hourly,
          :published,
          :upon_completion_pay,
          specialist: specialist
        )
      end

      let!(:timesheet) do
        create(
          :timesheet,
          :disputed,
          project: project,
          hours: 10
        )
      end

      before do
        project.charges.create!(
          amount_in_cents: 10_000,
          status: Charge.statuses[:scheduled],
          date: 5.minutes.ago,
          process_after: 5.minutes.ago,
          description: 'Test'
        )
      end

      it 'does not process scheduled charges' do
        expect_any_instance_of(Project).to receive(:ending?).and_return(true)
        charges = Charge::Processing.process_scheduled!
        expect(charges.size).to eq(0)
      end
    end

    context 'with no disputed timesheets' do
      let(:specialist) { create :specialist }

      let(:project_1) do
        create(
          :project_one_off_hourly,
          business: business,
          specialist: specialist
        )
      end

      let(:project_2) do
        create(
          :project_one_off_hourly,
          business: business,
          specialist: specialist
        )
      end

      before do
        5.times do
          project_1.charges.create!(
            amount_in_cents: 60_000,
            status: Charge.statuses[:estimated],
            date: 5.minutes.ago,
            process_after: 5.minutes.ago,
            description: 'Test'
          )

          project_1.charges.create!(
            amount_in_cents: 10_000,
            status: Charge.statuses[:scheduled],
            date: 5.minutes.ago,
            process_after: 5.minutes.ago,
            description: 'Test'
          )

          project_2.charges.create!(
            amount_in_cents: 5000,
            date: 5.minutes.ago,
            status: Charge.statuses[:scheduled],
            process_after: 5.minutes.ago,
            description: 'Test'
          )
        end
      end

      before do
        @charges = Charge::Processing.process_scheduled!
      end

      context 'when business is fee free' do
        let(:business) { create :business, :fee_free }

        it 'creates 2 transactions' do
          expect(@charges.size).to eq(2)
        end

        it 'creates transactions per project with total amount' do
          transaction_1 = project_1.transactions.first
          transaction_2 = project_2.transactions.first
          expect(transaction_1.amount_in_cents).to eq(BigDecimal(50_000))
          expect(transaction_2.amount_in_cents).to eq(BigDecimal(25_000))
          expect(transaction_1.fee_in_cents).to eq(BigDecimal(5000))
          expect(transaction_2.fee_in_cents).to eq(BigDecimal(2500))
        end

        it 'creates associated specialist payment transactions' do
          transaction_1 = project_1.transactions.first
          transaction_2 = project_2.transactions.first
          expect(transaction_1.specialist_total).to eq(BigDecimal(450))
          expect(transaction_2.specialist_total).to eq(BigDecimal(225))
        end
      end

      context 'when business is not fee free' do
        let(:business) { create :business }

        it 'creates 2 transactions' do
          expect(@charges.size).to eq(2)
        end

        it 'creates transactions per project with total amount' do
          transaction_1 = project_1.transactions.first
          transaction_2 = project_2.transactions.first
          expect(transaction_1.amount_in_cents).to eq(BigDecimal(50_000) * (1 + Charge::COMPLECT_FEE_PCT))
          expect(transaction_2.amount_in_cents).to eq(BigDecimal(25_000) * (1 + Charge::COMPLECT_FEE_PCT))
          expect(transaction_1.fee_in_cents).to eq(BigDecimal(10_000))
          expect(transaction_2.fee_in_cents).to eq(BigDecimal(5000))
        end

        it 'creates associated specialist payment transactions' do
          transaction_1 = project_1.transactions.first
          transaction_2 = project_2.transactions.first
          expect(transaction_1.specialist_total).to eq(BigDecimal(450))
          expect(transaction_2.specialist_total).to eq(BigDecimal(225))
        end
      end
    end
  end
end
