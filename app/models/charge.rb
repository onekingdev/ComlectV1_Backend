# frozen_string_literal: true
class Charge < ActiveRecord::Base
  belongs_to :project
  belongs_to :payment_source

  enum status: { scheduled: 'scheduled', processed: 'processed', error: 'error' }

  def amount
    return unless amount_in_cents
    amount_in_cents / 100
  end
end
