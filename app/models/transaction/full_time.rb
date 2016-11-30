# frozen_string_literal: true
class Transaction::FullTime < Transaction
  belongs_to :charge_source, class_name: 'PaymentSource'
  has_many :charges, dependent: :nullify

  scope :current, -> { where(status: nil) }
  scope :current_for, -> (project_id) do
    current.where(project_id: project_id)
  end

  def process!
    super do
      charge, source_id = create_stripe_charge
      self.stripe_id = charge.id
      self.charge_source_id = source_id
      true
    end
  end

  private

  def create_stripe_charge
    stripe_customer_id = business.payment_profile.stripe_customer_id
    charge = Stripe::Charge.create(
      amount: amount_in_cents,
      currency: 'usd',
      customer: stripe_customer_id
    )
    [charge, stripe_customer_id]
  end
end
