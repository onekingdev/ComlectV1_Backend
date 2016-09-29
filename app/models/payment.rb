# frozen_string_literal: true
class Payment < ActiveRecord::Base
  belongs_to :project

  enum status: { scheduled: 'scheduled', processed: 'processed', error: 'error' }

  scope :after, -> (date) { where('process_after >= ?', date) }

  def amount
    return unless amount_in_cents
    amount_in_cents / 100
  end
end
