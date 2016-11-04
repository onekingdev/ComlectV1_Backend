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
      total_in_cents = charges.map(&:total_with_fee_in_cents).reduce(:+)
      specialist_amount = charges.map(&:specialist_amount_in_cents).reduce(:+)
      business_transaction = create_business_transaction(total_in_cents)
      create_specialist_payment business_transaction, specialist_amount
      Charge.where(id: charges.map(&:id)).update_all(
        transaction_id: business_transaction.id,
        status: Charge.statuses[:processed]
      )
    end
  end

  private

  def create_business_transaction(amount_in_cents)
    Transaction::BusinessCharge.create!(project_id: project.id, amount_in_cents: amount_in_cents)
  end

  def create_specialist_payment(parent_transaction, amount_in_cents)
    # Specialists don't get directly paid for full time roles:
    return if project.full_time?
    Transaction::SpecialistPayment.create!(amount_in_cents: amount_in_cents, parent_transaction: parent_transaction)
  end
end
