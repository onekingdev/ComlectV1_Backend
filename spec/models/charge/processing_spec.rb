# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Charge::Processing, type: :model do
  describe 'a set of scheduled charges' do
    let(:specialist) { create :specialist }
    let(:project_1) { create :project_one_off_hourly, specialist: specialist }
    let(:project_2) { create :project_one_off_hourly, specialist: specialist }

    before do
      5.times do
        project_1.charges.create! amount_in_cents: 60_000,
                                  status: Charge.statuses[:estimated],
                                  date: 5.minutes.ago,
                                  process_after: 5.minutes.ago,
                                  description: 'Test'
        project_1.charges.create! amount_in_cents: 10_000,
                                  status: Charge.statuses[:scheduled],
                                  date: 5.minutes.ago,
                                  process_after: 5.minutes.ago,
                                  description: 'Test'
        project_2.charges.create! amount_in_cents: 5000,
                                  date: 5.minutes.ago,
                                  status: Charge.statuses[:scheduled],
                                  process_after: 5.minutes.ago,
                                  description: 'Test'
      end
    end

    before do
      @charges = Charge::Processing.process_scheduled!
    end

    it('creates 2 transactions') { expect(@charges.size).to eq(2) }

    it 'creates transactions per project with total amount' do
      transaction_1 = project_1.transactions.first
      transaction_2 = project_2.transactions.first
      expect(transaction_1.amount_in_cents).to eq(BigDecimal.new(50_000) * 1.15)
      expect(transaction_2.amount_in_cents).to eq(BigDecimal.new(25_000) * 1.15)
    end

    it 'creates associated specialist payment transactions' do
      transaction_1 = project_1.transactions.first.specialist_payment
      transaction_2 = project_2.transactions.first.specialist_payment
      expect(transaction_1.amount_in_cents).to eq(BigDecimal.new(50_000))
      expect(transaction_2.amount_in_cents).to eq(BigDecimal.new(25_000))
    end
  end
end
