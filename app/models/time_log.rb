# frozen_string_literal: true
class TimeLog < ActiveRecord::Base
  belongs_to :timesheet

  scope :approved, -> { joins(:timesheet).where(timesheets: { status: Timesheet.statuses[:approved] }) }

  validates :description, :hours, presence: true
  validates :hours, numericality: { greater_than: 0 }

  after_validation -> { self.hours = hours.round(2) }, if: -> { hours.present? }
end
