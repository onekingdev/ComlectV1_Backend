# frozen_string_literal: true
class TransferForeignCurrencyJob < ActiveJob::Base
  queue_as :default

  def perform
    # Stripe doesn't handle EUR/etc. automatically so we go through each
    # balance and make a transfer into the USD bank account
    Stripe::Balance.retrieve.available.each do |balance|
      next if balance.currency == 'usd'
      Stripe::Transfer.create(amount: balance.amount, currency: balance.currency, destination: 'default_for_currency')
    end
  end
end
