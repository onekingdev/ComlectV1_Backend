# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Charge::Processing, type: :model do
  describe 'a set of scheduled charges' do
    let(:specialist) { create(:specialist) }

    context 'when full time project' do
      let(:business) { create(:business, :with_payment_profile) }
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
            expected_credits = business.credits_in_cents - transaction.business_credit_in_cents

            aggregate_failures do
              expect(transaction.amount_in_cents).to eq(amount)
              expect(business.reload.credits_in_cents).to eq(expected_credits)
            end
          end
        end

        context 'without credit' do
          # let(:business) { create(:business, :with_payment_profile) }

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
            amount_in_cents: 100_000,
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

      # TODO: completely remove "fee free" feature
      # context 'when business is fee free' do
      #   context 'with credits' do
      #     let(:specialist) { create :specialist, :credit }
      #     let(:business) { create :business, :fee_free, :credit }
      #
      #     it 'creates 2 transactions' do
      #       expect(@charges.size).to eq(2)
      #     end
      #
      #     it 'creates transactions per project with total amount' do
      #       transaction_1 = project_1.transactions.first
      #       transaction_2 = project_2.transactions.first
      #
      #       ap transaction_2.amount_in_cents
      #       ap transaction_2.fee_in_cents
      #       ap transaction_2.fee_in_cents.zero?
      #
      #       expect(transaction_1.amount_in_cents).to eq(BigDecimal(50_000))
      #       expect(transaction_2.amount_in_cents).to eq(BigDecimal(25_000))
      #       expect(transaction_1.fee_in_cents).to be_zero
      #       expect(transaction_2.fee_in_cents).to be_zero
      #     end
      #
      #     it 'creates associated specialist payment transactions' do
      #       transaction_1 = project_1.transactions.first
      #       transaction_2 = project_2.transactions.first
      #
      #       expect(transaction_1.specialist_total).to eq(BigDecimal(450))
      #       expect(transaction_2.specialist_total).to eq(BigDecimal(225))
      #     end
      #   end
      #
      #   context 'without credits' do
      #     let(:specialist) { create :specialist }
      #     let(:business) { create :business, :fee_free }
      #
      #     it 'creates 2 transactions' do
      #       expect(@charges.size).to eq(2)
      #     end
      #
      #     it 'creates transactions per project with total amount' do
      #       transaction_1 = project_1.transactions.first
      #       transaction_2 = project_2.transactions.first
      #
      #       expect(transaction_1.amount_in_cents).to eq(BigDecimal(50_000))
      #       expect(transaction_2.amount_in_cents).to eq(BigDecimal(25_000))
      #       expect(transaction_1.fee_in_cents).to eq(BigDecimal(5000))
      #       expect(transaction_2.fee_in_cents).to eq(BigDecimal(2500))
      #     end
      #
      #     it 'creates associated specialist payment transactions' do
      #       transaction_1 = project_1.transactions.first
      #       transaction_2 = project_2.transactions.first
      #
      #       expect(transaction_1.specialist_total).to eq(BigDecimal(450))
      #       expect(transaction_2.specialist_total).to eq(BigDecimal(225))
      #     end
      #   end
      # end

      context 'when business is not fee free' do
        context 'with credits' do
          let(:specialist) { create :specialist, :credit }
          let(:business) { create :business, :credit }

          it 'creates 2 transactions' do
            expect(@charges.size).to eq(2)
          end

          it 'creates transactions per project with total amount' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first

            amount_1 = transaction_1.charges.map(&:amount_in_cents).reduce(:+) / 100
            amount_in_cents_1 = amount_with_stripe_fee_card(amount_1) +
                                Charge::COMPLECT_ADMIN_FEE_CENTS -
                                transaction_1.business_credit_in_cents
            amount_2 = transaction_2.charges.map(&:amount_in_cents).reduce(:+) / 100
            amount_in_cents_2 = amount_with_stripe_fee_card(amount_2) +
                                Charge::COMPLECT_ADMIN_FEE_CENTS -
                                transaction_2.business_credit_in_cents

            aggregate_failures do
              expect(transaction_1.amount_in_cents).to eq(amount_in_cents_1)
              expect(transaction_2.amount_in_cents).to eq(amount_in_cents_2)

              # amount = BigDecimal(8500) - transaction_1.business_credit_in_cents - transaction_1.specialist_credit_in_cents
              # expect(transaction_1.fee_in_cents).to eq(amount)

              # expect(transaction_2.fee_in_cents).to eq amount_fees_by_charge_2.reduce(:+) - transaction_2.specialist_credit_in_cents
            end
          end

          it 'creates associated specialist payment transactions' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first

            expect(transaction_1.specialist_total).to eq(BigDecimal(4500))
            expect(transaction_2.specialist_total).to eq(BigDecimal(225))
          end

          it 'redeems credit balance' do
            expect(business.reload.credits_in_cents).to be_zero
          end
        end

        context 'without credits' do
          let(:specialist) { create :specialist }
          let(:business) { create :business }

          it 'creates 2 transactions' do
            expect(@charges.size).to eq(2)
          end

          it 'creates transactions per project with total amount' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first

            amount_1 = transaction_1.charges.map(&:amount_in_cents).reduce(:+) / 100
            amount_in_cents_1 = amount_with_stripe_fee_card(amount_1) +
                                Charge::COMPLECT_ADMIN_FEE_CENTS -
                                transaction_1.business_credit_in_cents
            amount_2 = transaction_2.charges.map(&:amount_in_cents).reduce(:+) / 100
            amount_in_cents_2 = amount_with_stripe_fee_card(amount_2) +
                                Charge::COMPLECT_ADMIN_FEE_CENTS -
                                transaction_2.business_credit_in_cents
            amount_without_fee_1 = transaction_1.charges.map(&:amount_in_cents).reduce(:+)
            amount_without_fee_2 = transaction_2.charges.map(&:amount_in_cents).reduce(:+)
            specialist_fee_1 = (transaction_1.charges.map(&:amount_in_cents).reduce(:+) * Charge::COMPLECT_FEE_PCT).to_i
            specialist_fee_2 = (transaction_2.charges.map(&:amount_in_cents).reduce(:+) * Charge::COMPLECT_FEE_PCT).to_i

            aggregate_failures do
              expect(transaction_1.amount_in_cents).to eq(amount_in_cents_1)
              expect(transaction_2.amount_in_cents).to eq(amount_in_cents_2)
              expect(transaction_1.fee_in_cents).to eq(transaction_1.amount_in_cents - amount_without_fee_1 + specialist_fee_1)
              expect(transaction_2.fee_in_cents).to eq(transaction_2.amount_in_cents - amount_without_fee_2 + specialist_fee_2)
            end
          end

          it 'creates associated specialist payment transactions' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first
            total_amount_1 = transaction_1.charges.map(&:amount_in_cents).reduce(:+)
            total_amount_2 = transaction_2.charges.map(&:amount_in_cents).reduce(:+)
            total_specialist_fee_1 = Charge::COMPLECT_FEE_PCT * total_amount_1
            total_specialist_fee_2 = Charge::COMPLECT_FEE_PCT * total_amount_2

            aggregate_failures do
              expect(transaction_1.specialist_total).to eq(BigDecimal((total_amount_1 - total_specialist_fee_1).to_s) / 100)
              expect(transaction_2.specialist_total).to eq(BigDecimal((total_amount_2 - total_specialist_fee_2).to_s) / 100)
            end
          end
        end

        context 'when ACH payment' do
          let(:business) { create(:business, :with_payment_profile_bank) }

          it 'is charge %0.8 stripe fees' do
            transaction_1 = project_1.transactions.first
            transaction_2 = project_2.transactions.first

            expected_amount_1 = 500_000 + stripe_fee_bank(5000) + Charge::COMPLECT_ADMIN_FEE_CENTS
            expected_amount_2 = 25_000 + stripe_fee_bank(250) + Charge::COMPLECT_ADMIN_FEE_CENTS
            expected_fees_1 = expected_amount_1 - 500_000
            expected_fees_2 = expected_amount_2 - 25_000

            aggregate_failures do
              expect(transaction_1.amount_in_cents).to eq(expected_amount_1)
              expect(transaction_1.business_fee).to eq(expected_fees_1)
              expect(transaction_2.amount_in_cents).to eq(expected_amount_2)
              expect(transaction_2.business_fee).to eq(expected_fees_2)
            end
          end
        end
      end
    end
  end
end
