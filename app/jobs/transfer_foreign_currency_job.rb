# frozen_string_literal: true

class TransferForeignCurrencyJob < ApplicationJob
  queue_as :default

  def perform
    # Stripe doesn't handle EUR/etc. automatically so we go through each
    # balance and create a payout into the USD bank account
    Stripe::Balance.retrieve.available.each do |balance|
      next if balance.currency == 'usd' || balance.amount.zero?

      Stripe::Payout.create(
        amount: balance.amount,
        currency: balance.currency
      )
    end
  end
end
