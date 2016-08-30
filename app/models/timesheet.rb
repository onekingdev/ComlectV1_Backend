# frozen_string_literal: true
class Timesheet < ActiveRecord::Base
  belongs_to :project
  has_one :business, through: :project
  has_one :specialist, through: :project
  has_many :time_logs, dependent: :destroy

  scope :sorted, -> { order(created_at: :desc) }
  scope :not_pending, -> { where.not(status: Timesheet.statuses[:pending]) }

  enum status: { pending: 'pending', submitted: 'submitted', approved: 'approved', disputed: 'disputed' }

  accepts_nested_attributes_for :time_logs, allow_destroy: true

  validates :time_logs, presence: true
  validate :validate_project_is_active

  def total_due
    if errors.any?
      # Count new records too when there are errors
      (time_logs.map(&:hours).compact.reduce(:+) || 0) * project.hourly_rate
    else
      time_logs.sum(:hours) * project.hourly_rate
    end
  end

  private

  def validate_project_is_active
    changes = self.changes.any? || time_logs.any? { |log| log.changes.any? }
    errors.add :base, 'Cannot add/update on complete projects' if changes && project.complete?
  end
end
