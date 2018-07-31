# frozen_string_literal: true

class Charge < ApplicationRecord
  belongs_to :project
  belongs_to :stripe_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :referenceable, polymorphic: true
  has_one :business, through: :project
  has_one :specialist, through: :project

  COMPLECT_FEE_PCT = 0.10
  COMPLECT_FEE_PCT_GOLD_TIER = COMPLECT_FEE_PCT - 0.02
  COMPLECT_FEE_PCT_PLATINUM_TIER = COMPLECT_FEE_PCT - 0.03
  COMPLECT_FEE_PCT_PLATINUM_HONORS_TIER = COMPLECT_FEE_PCT - 0.04

  scope :for_one_off_projects, -> { joins(:project).where(project: Project.one_off) }
  scope :real, -> { where(status: [Charge.statuses[:scheduled], Charge.statuses[:processed], Charge.statuses[:error]]) }
  scope :pending_or_errored, -> { where(status: [Charge.statuses[:scheduled], Charge.statuses[:error]]) }
  scope :upcoming, -> { where.not(status: Charge.statuses[:processed]) }
  scope :not_charged, -> {
    joins('LEFT OUTER JOIN transactions ON transaction_id = transactions.id')
      .where('transaction_id IS NULL OR transactions.status <> ?', Transaction.statuses[:processed])
  }
  scope :after, ->(date) { where('date >= ?', date.to_date) }
  scope :before, ->(date) { where('date < ?', date.to_date) }
  scope :for_processing, -> { where('process_after <= ?', Time.zone.now).order(date: :asc) }

  before_create :calculate_fee

  enum status: {
    estimated: 'estimated',
    scheduled: 'scheduled',
    processed: 'processed',
    error: 'error'
  }

  def amount
    return unless amount_in_cents
    amount_in_cents / 100.0
  end

  def amount=(value)
    self.amount_in_cents = (BigDecimal(value) * 100).to_i
  end

  def business_fee
    return unless business_fee_in_cents
    business_fee_in_cents / 100.0
  end

  def business_fee=(value)
    self.business_fee_in_cents = (BigDecimal(value) * 100).to_i
  end

  def specialist_fee
    return unless specialist_fee_in_cents
    specialist_fee_in_cents / 100.0
  end

  def specialist_fee=(value)
    self.specialist_fee_in_cents = (BigDecimal(value) * 100).to_i
  end

  def total_with_fee
    return unless total_with_fee_in_cents
    total_with_fee_in_cents / 100.0
  end

  def total_with_fee=(value)
    self.total_with_fee_in_cents = (BigDecimal(value) * 100).to_i
  end

  def running_balance
    return unless running_balance_in_cents
    running_balance_in_cents / 100.0
  end

  def running_balance=(value)
    self.running_balance_in_cents = (BigDecimal(value) * 100).to_i
  end

  def specialist_amount
    return unless specialist_amount_in_cents
    specialist_amount_in_cents / 100.0
  end

  def specialist_amount=(value)
    self.specialist_amount_in_cents = (BigDecimal(value) * 100).to_i
  end

  def amount_or_fee
    project.full_time? ? fee : amount
  end

  def specialist_running_balance
    return unless running_balance_in_cents
    # Remove fee charged to business and fee kept by Complect for specialist
    balance = (running_balance_in_cents / 100.0) / (1 + COMPLECT_FEE_PCT)
    balance - (balance * COMPLECT_FEE_PCT)
  end

  private

  def calculate_fee
    calculate_business_fee
    calculate_specialist_fee

    self.total_with_fee_in_cents = amount_in_cents + business_fee_in_cents

    if project.one_off?
      self.running_balance_in_cents *= (1 + COMPLECT_FEE_PCT) if running_balance_in_cents
      self.specialist_amount_in_cents = amount_in_cents - specialist_fee_in_cents
    end

    true
  end

  def calculate_business_fee
    return self.business_fee_in_cents = 0 if business.fee_free
    self.business_fee_in_cents ||= fee_in_cents_with_rewards(business)
  end

  def calculate_specialist_fee
    self.specialist_fee_in_cents ||= fee_in_cents_with_rewards(specialist)
  end

  def fee_in_cents_with_rewards(record)
    return amount_in_cents * COMPLECT_FEE_PCT_GOLD_TIER if record.gold?
    return amount_in_cents * COMPLECT_FEE_PCT_PLATINUM_TIER if record.platinum?
    return amount_in_cents * COMPLECT_FEE_PCT_PLATINUM_HONORS_TIER if record.platinum_honors?
    amount_in_cents * COMPLECT_FEE_PCT
  end
end
