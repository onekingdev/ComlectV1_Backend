# frozen_string_literal: true

class InvoiceSerializer < ApplicationSerializer
  attributes \
    :id,
    :date,
    :name,
    :price,
    :currency,
    :invoice_pdf,
    :invoice_type,
    :price_in_cents,
    :hosted_invoice_url

  def date
    object.date.strftime('%d/%m/%Y')
  end

  def price_in_cents
    object.price
  end

  def price
    if object.currency == 'usd'
      "$#{object.price / 100}"
    else
      object.price
    end
  end
end
