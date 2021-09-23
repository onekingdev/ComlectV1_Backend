# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :business, optional: true
  belongs_to :specialist, optional: true

  enum invoice_type: { plan: 'plan' }

  validates \
    :stripe_invoice_id, :stripe_customer_id, :name,
    :invoice_pdf, :date, :price, presence: true
end
