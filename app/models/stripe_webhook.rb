# frozen_string_literal: true
class StripeWebhook
  attr_reader :event

  def self.handle(event_id, connect: true)
    # TODO: Handle webhook on bg job
    new(event_id, connect: connect).handle
  end

  def initialize(event_id, connect:)
    @connect = connect
    @event = Stripe::Event.retrieve(event_id)
  end
end
