# frozen_string_literal: true

class ProcessScheduledChargesJob < ApplicationJob
  queue_as :payments

  def perform
    Charge::Processing.process_scheduled!
  end
end
