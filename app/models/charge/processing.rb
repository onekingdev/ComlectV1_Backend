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
      transaction = create_transaction
      Charge.where(id: charges.map(&:id)).update_all(
        transaction_id: transaction.id,
        status: Charge.statuses[:processed]
      )
    end
  end

  private

  def create_transaction
    amount_in_cents = charges.map(&:total_with_fee_in_cents).reduce(:+)
    fee_in_cents = charges.map(&:fee_in_cents).reduce(:+)
    common = { project_id: project.id, amount_in_cents: amount_in_cents }
    if project.full_time?
      Transaction::FullTime.create!(common)
    else
      # (*2) because we take 10% off business and 10% off specialists
      Transaction::OneOff.create!(common.merge(fee_in_cents: fee_in_cents * 2))
    end
  end
end
