# frozen_string_literal: true
class Transaction::SpecialistPayment < Transaction
  belongs_to :payment_target, class_name: 'StripeAccount'
  belongs_to :parent_transaction, class_name: 'Transaction::BusinessCharge'
  has_many :charges, through: :parent_transaction

  validates :parent_transaction, presence: true
end
