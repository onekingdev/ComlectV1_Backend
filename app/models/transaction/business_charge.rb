# frozen_string_literal: true
class Transaction::BusinessCharge < Transaction
  belongs_to :charge_source, class_name: 'PaymentSource'
  has_many :charges, dependent: :nullify
  has_one :specialist_payment, class_name: 'Transaction::SpecialistPayment', foreign_key: 'parent_transaction_id'

  scope :current, -> { where(status: nil) }
  scope :current_for, -> (project_id) do
    current.where(project_id: project_id)
  end
end
