# frozen_string_literal: true
class Transaction < ActiveRecord::Base
  belongs_to :project
  has_one :business, through: :project
  has_one :specialist, through: :project
  has_many :charges, foreign_key: 'transaction_id', dependent: :nullify

  enum status: { pending: nil, processed: 'processed', error: 'error' }

  scope :pending_or_errored, -> { where(status: [Transaction.statuses[:pending], Transaction.statuses[:error]]) }
  scope :not_escalated, -> { joins(:project).where(project: Project.not_escalated) }
  scope :ready, -> { pending.not_escalated }
  scope :one_off, -> { joins(:project).where(project: Project.one_off) }

  def self.process_pending!
    pending_or_errored.find_each(&:process!)
  end

  def amount
    BigDecimal.new(amount_in_cents) / 100.0
  end

  def fee
    @_fee ||= charges.map(&:fee).reduce(:+) || 0
  end

  def subtotal
    BigDecimal.new(charges.map(&:amount_in_cents).reduce(:+) || 0) / 100.0
  end

  def specialist_total
    subtotal - fee
  end

  def process!
    self.class.transaction do
      return nil unless yield
      self.processed_at = Time.zone.now
      self.status_detail = nil
      processed!
      save!
    end
  rescue => e
    self.status_detail = e.message
    error!
    save!
  end
end
