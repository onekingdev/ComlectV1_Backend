# frozen_string_literal: true

class Charge::Processing
  attr_reader :charges, :project, :business, :specialist

  def self.process_scheduled!
    result = []

    Charge.includes(:project).scheduled.for_processing.group_by(&:project).each do |project, charges|
      next if !project.full_time? && project.ending? && project.disputed_timesheets?
      result << new(charges, project).process!
    end

    result
  end

  def initialize(charges, project)
    @charges = charges
    @project = project
    @business = project.business
    @specialist = project.specialist
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
    common = {
      project_id: project.id,
      amount_in_cents: amount_in_cents,
      business_credit_in_cents: business_credit_in_cents,
      date: charges.first.date
    }

    if project.full_time?
      Business::Credit.for(business).redeem!(business_credit_in_cents) unless business.fee_free
      Transaction::FullTime.create!(common)
    else
      additional = {
        fee_in_cents: total_fees_in_cents,
        specialist_credit_in_cents: specialist_credit_in_cents
      }

      Business::Credit.for(business).redeem!(business_credit_in_cents)
      Specialist::Credit.for(specialist).redeem!(specialist_credit_in_cents)
      Transaction::OneOff.create!(common.merge(additional))
    end
  end

  def total_fees_in_cents
    (business_fee_in_cents - business_credit_in_cents) + (specialist_fee_in_cents - specialist_credit_in_cents)
  end

  def business_fee_in_cents
    @business_fee_in_cents ||= amount_with_business_fee(amount_without_fee_in_cents / 100) - amount_without_fee_in_cents
  end

  def specialist_fee_in_cents
    @specialist_fee_in_cents ||= charges.map(&:specialist_fee_in_cents).reduce(:+)
  end

  def business_credit_in_cents
    return @business_credit_in_cents if @business_credit_in_cents
    credit = Business::Credit.for(business)

    @business_credit_in_cents = if business_fee_in_cents >= credit.amount_in_cents
      credit.amount_in_cents
    else
      business_fee_in_cents
    end
  end

  def specialist_credit_in_cents
    return @specialist_credit_in_cents if @specialist_credit_in_cents
    credit = Specialist::Credit.for(specialist)

    @specialist_credit_in_cents = if specialist_fee_in_cents >= credit.amount_in_cents
      credit.amount_in_cents
    else
      specialist_fee_in_cents
    end
  end

  def amount_in_cents
    # Do not include fee if business is fee free
    return charges.map(&:amount_in_cents).reduce(:+) if project.business.fee_free

    if project.full_time?
      charges.map(&:total_with_fee_in_cents).reduce(:+) - business_credit_in_cents
    else
      amount_with_business_fee(amount_without_fee_in_cents / 100) - business_credit_in_cents
    end
  end

  def amount_with_business_fee(amount)
    return 0 if business.fee_free || project.business_fee_free

    Charge.amount_with_stripe_fee(amount, :usd, business.payment_source_type) + Charge::COMPLECT_ADMIN_FEE_CENTS
  end

  def amount_without_fee_in_cents
    charges.map(&:amount_in_cents).reduce(:+)
  end
end
