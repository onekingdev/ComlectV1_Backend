# frozen_string_literal: true
class Timesheet < ActiveRecord::Base
  belongs_to :project
  has_one :business, through: :project
  has_one :specialist, through: :project
  has_one :charge, as: :referenceable
  has_many :time_logs, dependent: :destroy

  scope :sorted, -> { order(created_at: :desc) }
  scope :not_pending, -> { where.not(status: Timesheet.statuses[:pending]) }
  scope :expired, -> { where.not(status: Timesheet.statuses[:approved]).where('expires_at <= ?', Time.zone.now) }
  scope :pending_charge, -> {
    joins("LEFT OUTER JOIN charges c ON c.referenceable_id = timesheets.id AND c.referenceable_type = 'Timesheet'")
      .where(c: { id: nil })
  }

  enum status: { pending: 'pending',
                 submitted: 'submitted',
                 approved: 'approved',
                 disputed: 'disputed',
                 charged: 'charged' }

  accepts_nested_attributes_for :time_logs, allow_destroy: true

  before_save -> { self.status_changed_at = Time.zone.now }, if: :status_changed?
  before_save -> { self.last_submitted_at = Time.zone.now }, if: -> { status_changed? && submitted? }
  before_save -> { self.first_submitted_at = Time.zone.now }, if: -> { first_submitted_at.nil? && submitted? }
  before_save :set_expiration, if: -> { submitted? && status_changed? }

  validates :time_logs, presence: true
  validate :validate_project_is_active

  def total_due
    if errors.any?
      # Count new records too when there are errors
      (time_logs.map(&:total_amount).compact.reduce(:+) || 0)
    else
      time_logs.sum :total_amount
    end
  end

  def approved_or_charged?
    approved? || charged?
  end

  def expired?
    !expires_at.blank? && expires_at.past? # negate blank? instead of using present? for clarity (present? && past?)
  end

  private

  def set_expiration
    expires_at = status_changed_at.in_time_zone(business.tz).tomorrow
    expires_at = expires_at.next_week unless expires_at.weekday?
    self.expires_at = expires_at.end_of_day
  end

  def validate_project_is_active
    return if changed == %w(status) # Allow changing timesheet status
    changes = self.changes.any? || time_logs.any? { |log| log.changes.any? }
    errors.add :base, 'Cannot add/update on complete projects' if changes && project.complete?
  end
end
