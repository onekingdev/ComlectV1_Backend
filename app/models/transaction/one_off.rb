# frozen_string_literal: true

class Transaction::OneOff < Transaction
  belongs_to :payment_target, class_name: 'StripeAccount'

  def process!
    super do
      raise 'Specialist does not have a managed account' unless specialist.stripe_account
      transfer = create_stripe_transfer
      self.stripe_id = transfer.id
      self.payment_target_id = specialist.stripe_account.id
      true
    end
  end

  private

  def create_stripe_transfer
    stripe_customer_id = business.payment_profile.stripe_customer_id

    Stripe::Charge.create(
      amount: amount_in_cents,
      currency: 'usd',
      customer: stripe_customer_id,
      application_fee: fee_in_cents,
      destination: specialist.stripe_account.stripe_id,
      description: "Project: #{project.title}"
    )
  end
end
