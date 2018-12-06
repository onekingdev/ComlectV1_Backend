# frozen_string_literal: true

class StripeEvent
  attr_reader :event, :account

  HANDLERS = {
    'invoice.created' => StripeEvent::InvoiceCreated,
    'invoice.finalized' => StripeEvent::InvoiceFinalized,
    'invoice.payment_succeeded' => StripeEvent::InvoiceSucceeded,
    'customer.subscription.created' => StripeEvent::SubscriptionCreated,
    'account.updated' => StripeEvent::AccountUpdated,
    'charge.failed' => StripeEvent::ChargeFailed,
    'payout.failed' => StripeEvent::PayoutFailed,
    'transfer.failed' => StripeEvent::TransferFailed
  }.freeze

  def self.handle(event_id, account_id, connect: true)
    account = StripeAccount.find_by(stripe_id: account_id) if connect
    args = {}
    args[:api_key] = account.secret_key if connect && account
    return nil if connect && account.nil? # We don't have the account on record (probably a dev account)
    event = Stripe::Event.retrieve(event_id, args)
    handler = HANDLERS[event.type]
    return nil unless handler
    handler.new(event, account: account, connect: connect).handle
  end

  def initialize(event, account:, connect:)
    @connect = connect
    @account = account
    @event = event
  end

  def connect?
    @connect
  end
end
