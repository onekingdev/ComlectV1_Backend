# frozen_string_literal: true
class Transaction::BusinessCharge < Transaction
  belongs_to :charge_source, class_name: 'PaymentSource'
  has_many :charges, dependent: :nullify
  has_one :specialist_payment, class_name: 'Transaction::SpecialistPayment', foreign_key: 'parent_transaction_id'

  scope :current, -> { where(status: nil) }
  scope :current_for, -> (project_id) do
    current.where(project_id: project_id)
  end

  def process!
    super do
      charge, source = create_stripe_charge
      self.stripe_id = charge.id
      self.charge_source_id = source.id
      true
    end
  end

  private

  def create_stripe_charge
    last_error = nil # For re-raising in case the last payment source failed
    business.payment_sources.primary_first.each do |source|
      begin
        charge = Stripe::Charge.create(amount: amount_in_cents, currency: 'usd', customer: source.stripe_id)
        return [charge, source]
      rescue Stripe::StripeError => e
        last_error = e
        next
      rescue
        raise
      end
    end
    raise last_error
  end
end
