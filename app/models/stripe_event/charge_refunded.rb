# frozen_string_literal: true

class StripeEvent::ChargeRefunded < StripeEvent
  # def handle; end

  def handle
    charge = event.data.object
    profile = PaymentProfile.find_by(stripe_customer_id: charge.customer)&.business
    profile ||= Specialist::PaymentSource.find_by(stripe_customer_id: charge.customer)&.specialist
    return unless profile

    profile.invoices.create!(invoice_attrs(charge).merge(stripe_event_type: 'refund'))
  end

  private

  def invoice_attrs(charge)
    attrs = {
      currency: charge.currency,
      price: charge.amount,
      invoice_pdf: charge.receipt_url,
      stripe_charge_id: charge.id,
      date: Time.at(charge.created).utc,
      stripe_customer_id: charge.customer,
      name: charge.description,
      hosted_invoice_url: charge.receipt_url,
      invoice_type: 'project'
    }

    if charge.invoice
      attrs[:invoice_type] = 'plan'
      subscription_invoice = Invoice.find_by(stripe_invoice_id: charge.invoice)
      attrs[:name] = subscription_invoice ? subscription_invoice.name : charge.description
    end

    attrs
  end
end
