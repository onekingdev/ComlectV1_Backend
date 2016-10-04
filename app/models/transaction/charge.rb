# frozen_string_literal: true
class Transaction::Charge < Transaction
  belongs_to :charge_source, class_name: 'PaymentSource'
  has_many :charges, dependent: :nullify
end
