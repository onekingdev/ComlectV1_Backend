# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Charge::Processing, type: :model do
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

        it 'does not create a transaction' do
          expect(project.transactions.size).to be_zero
        end
      end

      context 'when not fee free' do
        context 'with credit' do
          let(:business) { create(:business, :with_payment_profile, :credit) }

          it 'sets the correct amount' do
            transaction = project.transactions.first

            amount = (project.annual_salary * 15) - transaction.business_credit_in_cents
            expect(transaction.amount_in_cents).to eq(amount)

            expect(business.reload.credits_in_cents).to be_zero
          end
        end

        context 'without credit' do
          let(:business) { create(:business, :with_payment_profile) }

          it 'sets the correct amount' do
            transaction = project.transactions.first
            expect(transaction.amount_in_cents).to eq(project.annual_salary * 15)
          end
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

    context 'when project is business fee free' do
      let(:business) { create :business, :with_payment_profile }
      let(:specialist) { create :specialist }

      let(:project) do
        create(
          :project_one_off_fixed,
          :upfront_pay,
          :business_fee_free,
          business: business,
          specialist: specialist
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

        @charges = Charge::Processing.process_scheduled!
      end

      it 'creates 1 transaction' do
        expect(@charges.size).to eq 1
      end

      it 'creates transaction with total amount' do
        transaction = project.transactions.first
        expect(transaction.amount_in_cents).to eq BigDecimal(10_000)
        expect(transaction.fee_in_cents).to eq BigDecimal(1000)
      end

      it 'creates associated specialist payment transaction' do
        transaction = project.transactions.first
        expect(transaction.specialist_total).to eq BigDecimal(90)
      end
    end

    context 'with no disputed timesheets' do
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
        context 'with credits' do
          let(:specialist) { create :specialist, :platinum_rewards, :credit }
          let(:business) { create :business, :fee_free, :gold_rewards, :credit }

          it 'creates 2 transactions' do
            expect(@charges.size).to eq(2)
          end

          it 'creates transactions per project with total amount' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first
            expect(transaction_1.amount_in_cents).to eq(BigDecimal(50_000))
            expect(transaction_2.amount_in_cents).to eq(BigDecimal(25_000))
            expect(transaction_1.fee_in_cents).to be_zero
            expect(transaction_2.fee_in_cents).to be_zero
          end

          it 'creates associated specialist payment transactions' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first
            expect(transaction_1.specialist_total).to eq(BigDecimal(465))
            expect(transaction_2.specialist_total).to eq(BigDecimal('232.50'))
          end
        end

        context 'without credits' do
          let(:specialist) { create :specialist, :platinum_rewards }
          let(:business) { create :business, :fee_free, :gold_rewards }

          it 'creates 2 transactions' do
            expect(@charges.size).to eq(2)
          end

          it 'creates transactions per project with total amount' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first
            expect(transaction_1.amount_in_cents).to eq(BigDecimal(50_000))
            expect(transaction_2.amount_in_cents).to eq(BigDecimal(25_000))
            expect(transaction_1.fee_in_cents).to eq(BigDecimal(3500))
            expect(transaction_2.fee_in_cents).to eq(BigDecimal(1750))
          end

          it 'creates associated specialist payment transactions' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first
            expect(transaction_1.specialist_total).to eq(BigDecimal(465))
            expect(transaction_2.specialist_total).to eq(BigDecimal('232.50'))
          end
        end
      end

      context 'when business is not fee free' do
        context 'with credits' do
          let(:specialist) { create :specialist, :platinum_rewards, :credit }
          let(:business) { create :business, :credit }

          it 'creates 2 transactions' do
            expect(@charges.size).to eq(2)
          end

          it 'creates transactions per project with total amount' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first

            amount = BigDecimal(50_000) * (1 + Charge::COMPLECT_FEE_PCT) - transaction_1.business_credit_in_cents
            expect(transaction_1.amount_in_cents).to eq(amount)

            amount = BigDecimal(25_000) * (1 + Charge::COMPLECT_FEE_PCT)
            expect(transaction_2.amount_in_cents).to eq(amount)

            amount = BigDecimal(8500) - transaction_1.business_credit_in_cents - transaction_1.specialist_credit_in_cents
            expect(transaction_1.fee_in_cents).to eq(amount)

            expect(transaction_2.fee_in_cents).to eq BigDecimal(4250) - transaction_2.specialist_credit_in_cents
          end

          it 'creates associated specialist payment transactions' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first
            expect(transaction_1.specialist_total).to eq(BigDecimal(465))
            expect(transaction_2.specialist_total).to eq(BigDecimal('232.50'))
          end

          it 'redeems credit balance' do
            expect(business.reload.credits_in_cents).to be_zero
          end
        end

        context 'without credits' do
          let(:specialist) { create :specialist, :platinum_rewards }
          let(:business) { create :business }

          it 'creates 2 transactions' do
            expect(@charges.size).to eq(2)
          end

          it 'creates transactions per project with total amount' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first
            expect(transaction_1.amount_in_cents).to eq(BigDecimal(50_000) * (1 + Charge::COMPLECT_FEE_PCT))
            expect(transaction_2.amount_in_cents).to eq(BigDecimal(25_000) * (1 + Charge::COMPLECT_FEE_PCT))
            expect(transaction_1.fee_in_cents).to eq(BigDecimal(8500))
            expect(transaction_2.fee_in_cents).to eq(BigDecimal(4250))
          end

          it 'creates associated specialist payment transactions' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first
            expect(transaction_1.specialist_total).to eq(BigDecimal(465))
            expect(transaction_2.specialist_total).to eq(BigDecimal('232.50'))
          end
        end
      end
    end
  end
end
