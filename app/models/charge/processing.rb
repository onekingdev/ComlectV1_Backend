# frozen_string_literal: true

class Charge::Processing
  attr_reader :charges, :project

  def self.process_scheduled!
    result = []

    Charge.includes(:project).scheduled.for_processing.group_by(&:project).each do |project, charges|
      next if project.one_off? && project.ending? && project.disputed_timesheets?
      result << new(charges, project).process!
    end

    result
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
    business_fee_in_cents = charges.map(&:business_fee_in_cents).reduce(:+)
    specialist_fee_in_cents = charges.map(&:specialist_fee_in_cents).reduce(:+)
    total_fees_in_cents = business_fee_in_cents + specialist_fee_in_cents

    common = {
      project_id: project.id,
      amount_in_cents: amount_in_cents,
      date: charges.first.date
    }

    if project.full_time?
      Transaction::FullTime.create!(common)
    else
      Transaction::OneOff.create!(common.merge(fee_in_cents: total_fees_in_cents))
    end
  end

  def amount_in_cents
    # Do not include fee if business is fee free
    return charges.map(&:amount_in_cents).reduce(:+) if project.business.fee_free

    charges.map(&:total_with_fee_in_cents).reduce(:+)
  end
end
