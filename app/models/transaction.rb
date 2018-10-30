# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :project
  has_one :business, through: :project
  has_one :specialist, through: :project
  has_many :charges, foreign_key: 'transaction_id', dependent: :nullify

  enum status: {
    pending: 'pending',
    processed: 'processed',
    error: 'error'
  }

  scope :pending_or_errored, -> { where(status: [Transaction.statuses[:pending], Transaction.statuses[:error]]) }
  scope :not_escalated, -> { joins(:project).where(project: Project.not_escalated) }
  scope :ready, -> {
    not_escalated.where(
      '(transactions.status = ?) OR (transactions.status = ? AND last_try_at < ?)',
      Transaction.statuses[:pending],
      Transaction.statuses[:error],
      24.hours.ago
    )
  }
  scope :one_off, -> { joins(:project).where(project: Project.one_off) }
  scope :by_year, ->(year) { where('EXTRACT(year FROM processed_at) = ?', year) }

  def self.process_pending!
    pending_or_errored.find_each(&:process!)
  end

  def amount
    BigDecimal(amount_in_cents) / 100.0
  end

  def fee
    if charges.size.positive?
      @_fee ||= charges.map(&:fee).reduce(:+)
    else
      (BigDecimal(fee_in_cents) / 2) / 100.0
    end
  end

  def business_fee
    if charges.size.positive?
      @specialist_fee ||= charges.map(&:business_fee).reduce(:+)
    else
      (BigDecimal(fee_in_cents) / 2) / 100.0
    end
  end

  def specialist_fee
    if charges.size.positive?
      @specialist_fee ||= charges.map(&:specialist_fee).reduce(:+)
    else
      (BigDecimal(fee_in_cents) / 2) / 100.0
    end
  end

  def subtotal
    if charges.size.positive?
      BigDecimal(charges.sum(:amount_in_cents)) / 100.0
    else
      subtotal_in_cents = BigDecimal(amount_in_cents) - (business_fee * 100.0)
      subtotal_in_cents / 100.0
    end
  end

  def specialist_total
    subtotal - specialist_fee
  end

  def process!
    self.class.transaction do
      return nil unless yield
      self.processed_at = Time.zone.now
      self.status_detail = nil
      processed!
      save!
      Notification::Deliver.transaction_processed!(self)
    end
  rescue StandardError => e
    self.status_detail = e.message
    self.last_try_at = Time.zone.now
    error!
    save!
    Bugsnag.notify(e)

    if e.respond_to?(:json_body) && e.json_body[:error][:type] == 'card_error'
      self.stripe_id = e.json_body[:error][:charge]
      save!
    end
  end
end
