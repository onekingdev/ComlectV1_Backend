# frozen_string_literal: true
class ProcessScheduledChargesJob < ActiveJob::Base
  queue_as :payments

  def perform
    Charge::Processing.process_scheduled!
  end
end
