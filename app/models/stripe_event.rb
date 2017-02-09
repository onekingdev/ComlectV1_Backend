# frozen_string_literal: true
class StripeEvent
  attr_reader :event, :account

  HANDLERS = {
    'account.updated' => StripeEvent::AccountUpdated,
    'charge.failed' => StripeEvent::ChargeFailed,
    'transfer.failed' => StripeEvent::TransferFailed
  }.freeze

  def self.handle(event_id, account_id, connect: true)
    args = if (account = StripeAccount.find_by(stripe_id: account_id))
             { api_key: account.secret_key }
           else
             {}
           end
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
