# frozen_string_literal: true
class ProcessTransactionsJob < ActiveJob::Base
  queue_as :payments

  def perform(transaction_id = nil)
    return process_all if transaction_id.nil?
    transaction = Transaction.find_by(id: transaction_id)
    transaction.process! if transaction
  end

  private

  def process_all
    Transaction.pending_or_errored.pluck(:id).each do |transaction_id|
      self.class.perform_later transaction_id
    end
  end
end
