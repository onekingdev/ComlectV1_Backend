# frozen_string_literal: true

class StripeEvent::ChargeSucceeded < StripeEvent
  # def handle; end

  def handle
    charge = event.data.object
    return if charge.invoice
    profile = PaymentProfile.find_by(stripe_customer_id: charge.customer)&.business
    profile ||= Specialist::PaymentSource.find_by(stripe_customer_id: charge.customer)&.specialist

    return unless profile

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

    profile.invoices.create!(attrs)
  end
end
