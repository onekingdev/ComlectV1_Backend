# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :business, optional: true
  belongs_to :specialist, optional: true

  enum invoice_type: { plan: 'plan', project: 'project' }

  validates \
    :stripe_customer_id, :name,
    :invoice_pdf, :date, :price, presence: true
end
