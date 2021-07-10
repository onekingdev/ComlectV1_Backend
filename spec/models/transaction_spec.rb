# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction do
  describe '.by_year' do
    let(:project) { create(:project) }

    let!(:transaction) do
      Timecop.freeze(Date.new(2017, 12, 14)) do
        create(
          :transaction,
          :processed,
          project: project,
          processed_at: Time.zone.today - 14.days
        )
      end
    end

    it 'returns transactions' do
      expect(Transaction.processed.by_year(2017).size).to eq 1
      expect(Transaction.processed.by_year(2016).size).to eq 0
    end
  end
end
