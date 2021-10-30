# frozen_string_literal: true

class StripeEvent::TransferReversed < StripeEvent
  def handle
    transfer = event.data.object
    specialist = StripeAccount.find_by(stripe_id: transfer.destination)&.specialist
    return unless specialist

    payout_invoice = Invoice.find_by(stripe_transfer_id: transfer.id, stripe_event_type: :payout)
    return unless payout_invoice

    attrs = {
      currency: transfer.currency,
      price: transfer.amount,
      stripe_transfer_id: transfer.id,
      date: Time.at(transfer.created).utc,
      stripe_customer_id: payout_invoice.stripe_customer_id,
      name: payout_invoice.name,
      hosted_invoice_url: payout_invoice.hosted_invoice_url,
      invoice_pdf: payout_invoice.hosted_invoice_url,
      invoice_type: 'project',
      stripe_event_type: 'refund_reversed'
    }
    specialist.invoices.create!(attrs)
  end
end
