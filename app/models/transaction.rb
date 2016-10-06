# frozen_string_literal: true
class Transaction < ActiveRecord::Base
  belongs_to :project
  has_one :business, through: :project
  has_one :specialist, through: :project

  enum status: { pending: nil, processed: 'processed', error: 'error' }

  scope :pending_or_errored, -> { where(status: [Transaction.statuses[:pending], Transaction.statuses[:error]]) }

  def self.process_pending!
    pending_or_errored.find_each(&:process!)
  end

  def amount
    BigDecimal.new(amount_in_cents) / 100.0
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
