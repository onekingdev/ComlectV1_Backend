# frozen_string_literal: true
class Charge::Processing
  attr_reader :charges, :project_id

  def self.process_scheduled!
    Charge.scheduled.where('process_after <= ?', Time.zone.now).group_by(&:project_id).map do |project_id, charges|
      new(charges, project_id).process!
    end
  end

  def initialize(charges, project_id)
    @charges = charges
    @project_id = project_id
  end

  def process!
    ActiveRecord::Base.transaction do
      amount_in_cents = charges.map(&:amount_in_cents).reduce(:+)
      business_transaction = Transaction::BusinessCharge.create!(
        project_id: project_id,
        # 15 percent service fee (BigDecimal to avoid floating point issues)
        amount_in_cents: BigDecimal.new(amount_in_cents) * 1.15
      )
      create_specialist_payment business_transaction, amount_in_cents
      Charge.where(id: charges.map(&:id)).update_all(
        transaction_id: business_transaction.id,
        status: Charge.statuses[:processed]
      )
    end
  end

  private

  def create_specialist_payment(parent_transaction, amount_in_cents)
    Transaction::SpecialistPayment.create!(
      amount_in_cents: amount_in_cents,
      parent_transaction: parent_transaction
    )
  end
end
