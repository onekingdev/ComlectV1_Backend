# frozen_string_literal: true

class StripeEventJob < ApplicationJob
  queue_as :default

  def perform(event_id, account_id, opts)
    StripeEvent.handle(event_id, account_id, connect: opts[:connect])
  end
end
