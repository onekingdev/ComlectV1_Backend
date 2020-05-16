# frozen_string_literal: true

class Charge < ApplicationRecord
  belongs_to :project
  belongs_to :stripe_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :referenceable, polymorphic: true
  has_one :business, through: :project
  has_one :specialist, through: :project

  COMPLECT_FEE_PCT = 0.10
  COMPLECT_ADMIN_FEE_CENTS = 150
  STRIPE_FEES = {
    usd: { percent: 2.9, fixed: 0.30, ach: 0.8 },
    cad: { percent: 2.9, fixed: 0.30 }
  }.freeze

  scope :for_rfp_or_one_off_projects, -> { joins(:project).where(project: Project.one_off.or(Project.rfp)) }
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

  def total_with_estimated_fee
    BigDecimal(Charge.amount_with_stripe_fee(
      amount,
      :usd,
      business.payment_source_type
    ) + COMPLECT_ADMIN_FEE_CENTS) / 100
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

  def self.amount_with_stripe_fee(amount, currency = :usd, source_type = :card)
    f_fixed = STRIPE_FEES[currency.to_s.downcase.to_sym][:fixed]
    f_percent = BigDecimal(STRIPE_FEES[currency.to_s.downcase.to_sym][:percent].to_s) / 100

    if source_type == :ach
      f_fixed = 0
      f_percent = BigDecimal(STRIPE_FEES[:usd][:ach].to_s) / 100
    end

    ((BigDecimal((amount + f_fixed).to_s) / (1 - f_percent)) * 100).round
  end

  private

  def calculate_fee
    calculate_business_fee # here 0 - We do that in Transaction
    calculate_specialist_fee

    self.total_with_fee_in_cents = amount_in_cents + business_fee_in_cents

    unless project.full_time?
      self.running_balance_in_cents *= (1 + COMPLECT_FEE_PCT) if running_balance_in_cents
      self.specialist_amount_in_cents = amount_in_cents - specialist_fee_in_cents if specialist
    end

    true
  end

  def calculate_business_fee
    self.business_fee_in_cents ||= 0 # we calculate it in transaction
  end

  def calculate_specialist_fee
    return unless specialist

    self.specialist_fee_in_cents ||= amount_in_cents * COMPLECT_FEE_PCT
  end
end
