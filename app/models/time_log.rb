# frozen_string_literal: true
class TimeLog < ActiveRecord::Base
  belongs_to :timesheet
  has_one :project, through: :timesheet

  scope :approved, -> { joins(:timesheet).where(timesheets: { status: Timesheet.statuses[:approved] }) }

  validates :date, :description, :hours, presence: true
  validates :hours, numericality: { greater_than: 0 }

  after_validation -> { self.hours = hours.round(2) }, if: -> { hours.present? }
  before_save -> do
    self.hourly_rate = project.hourly_rate
    self.total_amount = hours * hourly_rate if hourly_rate && hours
  end

  def total_amount
    hours * hourly_rate
  rescue
    0
  end
end
