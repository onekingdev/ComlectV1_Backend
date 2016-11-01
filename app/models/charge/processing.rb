# frozen_string_literal: true
class Charge::Processing
  attr_reader :charges, :project

  def self.process_scheduled!
    Charge.includes(:project).scheduled.for_processing.group_by(&:project).map do |project, charges|
      new(charges, project).process!
    end
  end

  def initialize(charges, project)
    @charges = charges
    @project = project
  end

  def process!
    ActiveRecord::Base.transaction do
      amount_in_cents = charges.map(&:amount_in_cents).reduce(:+)
      business_transaction = create_business_transaction(amount_in_cents)
      # Specialists don't get directly paid for full time roles:
      create_specialist_payment business_transaction, amount_in_cents unless project.full_time?
      Charge.where(id: charges.map(&:id)).update_all(
        transaction_id: business_transaction.id,
        status: Charge.statuses[:processed]
      )
    end
  end

  private

  def create_business_transaction(amount_in_cents)
    # Don't overcharge for full-time roles since the amount is already the fee
    fee_multiplier = project.full_time? ? 1.0 : 1.15
    Transaction::BusinessCharge.create!(
      project_id: project.id,
      # 15 percent service fee (BigDecimal to avoid floating point issues)
      amount_in_cents: BigDecimal.new(amount_in_cents) * fee_multiplier
    )
  end

  def create_specialist_payment(parent_transaction, amount_in_cents)
    Transaction::SpecialistPayment.create!(
      amount_in_cents: amount_in_cents,
      parent_transaction: parent_transaction
    )
  end
end
