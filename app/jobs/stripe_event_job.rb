# frozen_string_literal: true
class StripeEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, account_id, connect)
    StripeEvent.handle(event_id, account_id, connect: connect)
  end
end
