# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :business, optional: true
  belongs_to :specialist, optional: true

  enum invoice_type: { plan: 'plan', project: 'project' }
  enum stripe_event_type: { charge: 'charge', refund: 'refund', payout: 'payout', refund_reversed: 'refund_reversed' }

  validates \
    :stripe_customer_id, :name,
    :invoice_pdf, :date, :price, presence: true
end
