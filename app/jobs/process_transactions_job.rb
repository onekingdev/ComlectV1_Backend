# frozen_string_literal: true

class ProcessTransactionsJob < ApplicationJob
  queue_as :payments

  def perform(transaction_id = nil)
    return process_all if transaction_id.nil?
    transaction = Transaction.ready.find_by(id: transaction_id)
    transaction&.process!

    # Business::Rewards.calculate! transaction.business
    # Specialist::Rewards.calculate! transaction.specialist
  end

  private

  def process_all
    Transaction.ready.pluck(:id).each do |transaction_id|
      self.class.perform_later transaction_id
    end
  end
end
