# frozen_string_literal: true
class Charge < ActiveRecord::Base
  belongs_to :project
  has_one :business, through: :project
  has_one :specialist, through: :project

  COMPLECT_FEE_PCT = 0.10

  scope :for_one_off_projects, -> { joins(:project).where(project: Project.one_off) }
  scope :real, -> { where(status: [Charge.statuses[:scheduled], Charge.statuses[:processed], Charge.statuses[:error]]) }
  scope :upcoming, -> { where.not(status: Charge.statuses[:processed]) }
  scope :after, -> (date) { where('date >= ?', date.to_date) }
  scope :before, -> (date) { where('date < ?', date.to_date) }
  scope :for_processing, -> { where('process_after <= ?', Time.zone.now) }

  before_create :calculate_fee

  enum status: { estimated: 'estimated', scheduled: 'scheduled', processed: 'processed', error: 'error' }

  def amount
    return unless amount_in_cents
    amount_in_cents / 100.0
  end

  def fee
    return unless fee_in_cents
    fee_in_cents / 100.0
  end

  def total_amount
    return unless total_with_fee_in_cents
    total_with_fee_in_cents / 100.0
  end

  def specialist_payment
    return unless specialist_amount_in_cents
    specialist_amount_in_cents / 100.0
  end

  def running_balance
    return unless running_balance_in_cents
    running_balance_in_cents / 100.0
  end

  def specialist_running_balance
    return unless running_balance_in_cents
    # Remove fee charged to business and fee kept by Complect for specialist
    balance = (running_balance_in_cents / 100.0) / (1 + COMPLECT_FEE_PCT)
    balance - (balance * COMPLECT_FEE_PCT)
  end

  private

  def calculate_fee
    self.fee_in_cents ||= amount_in_cents * COMPLECT_FEE_PCT
    self.total_with_fee_in_cents = amount_in_cents + fee_in_cents
    self.running_balance_in_cents *= (1 + COMPLECT_FEE_PCT) if running_balance_in_cents
    if project.one_off?
      self.specialist_amount_in_cents = amount_in_cents - fee_in_cents
    end
    true
  end
end
