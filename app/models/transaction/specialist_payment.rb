# frozen_string_literal: true
class Transaction::SpecialistPayment < Transaction
  belongs_to :payment_target, class_name: 'StripeAccount'
  belongs_to :parent_transaction, class_name: 'Transaction::BusinessCharge'
  has_many :charges, through: :parent_transaction

  validates :parent_transaction, presence: true

  delegate :project, :specialist, to: :parent_transaction

  def process!
    super do
      if parent_transaction.processed?
        transfer = create_stripe_transfer
        self.stripe_id = transfer.id
        self.payment_target_id = specialist.stripe_account_id
        true
      else
        false
      end
    end
  end

  private

  def create_stripe_transfer
    Stripe::Transfer.create(
      amount: amount_in_cents,
      currency: 'usd',
      destination: specialist.stripe_account.stripe_id
    )
  end
end
