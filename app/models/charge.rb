# frozen_string_literal: true
class Charge < ActiveRecord::Base
  belongs_to :project
  has_one :business, through: :project
  has_one :specialist, through: :project

  scope :real, -> { where(status: [Charge.statuses[:scheduled], Charge.statuses[:processed]]) }
  scope :upcoming, -> { where(status: [Charge.statuses[:estimated], Charge.statuses[:scheduled]]) }
  scope :after, -> (date) { where('date >= ?', date) }

  enum status: { estimated: 'estimated', scheduled: 'scheduled', processed: 'processed', error: 'error' }

  def amount
    return unless amount_in_cents
    amount_in_cents / 100.0
  end
end
