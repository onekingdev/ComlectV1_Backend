# frozen_string_literal: true

class StripeEvent::InvoiceSucceeded < StripeEvent
  def handle
    invoice = event.data.object

    profile = PaymentProfile.find_by(stripe_customer_id: invoice.customer)&.business
    profile ||= Specialist::PaymentSource.find_by(stripe_customer_id: invoice.customer)&.specialist

    return unless profile

    attrs = {
      currency: invoice.currency,
      price: invoice.amount_paid,
      stripe_invoice_id: invoice.id,
      invoice_pdf: invoice.invoice_pdf,
      stripe_charge_id: invoice.charge,
      date: Time.at(invoice.created).utc,
      stripe_customer_id: invoice.customer,
      name: invoice.lines.data[0].description,
      hosted_invoice_url: invoice.hosted_invoice_url
    }

    profile.invoices.create!(attrs)
  end

  # def handle
  #   return if event.data.object.charge.nil?
  #   fs = PaymentProfile.find_by(stripe_customer_id: event.data.object.customer).business.forum_subscription
  #   sub = SubscriptionCharge.where(stripe_charge_id: event.data.object.charge, forum_subscription: fs).first_or_create
  #   sub.update(forum_subscription: fs, status: 1, amount: event.data.object.amount_paid)
  #   # fs.business.update(qna_lvl: fs[:level])
  # end
end
