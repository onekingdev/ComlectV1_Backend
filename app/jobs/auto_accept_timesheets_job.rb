# frozen_string_literal: true

class AutoAcceptTimesheetsJob < ApplicationJob
  queue_as :default

  def perform(timesheet_id = nil)
    return process_all if timesheet_id.nil?
    timesheet = Timesheet::Form.new(Timesheet.find(timesheet_id))
    return unless timesheet.expired?
    timesheet.approve!
  end

  private

  def process_all
    Timesheet.expired.each do |timesheet|
      self.class.perform_later timesheet.id
    end
  end
end
