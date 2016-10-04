# frozen_string_literal: true
class Transaction::Payment < Transaction
  belongs_to :payment_target, class_name: 'StripeAccount'
  has_many :payments, dependent: :nullify
end
