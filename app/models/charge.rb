# frozen_string_literal: true
class Charge < ActiveRecord::Base
  belongs_to :project

  scope :real, -> { where(status: [Charge.statuses[:scheduled], Charge.statuses[:processed]]) }

  enum status: { estimated: 'estimated', scheduled: 'scheduled', processed: 'processed', error: 'error' }

  def amount
    return unless amount_in_cents
    amount_in_cents / 100
  end
end
