# frozen_string_literal: true

module TimesheetSpecHelper
  def log_timesheet(project, hours:, status: Timesheet.statuses[:approved])
    build(:timesheet, project: project, status: status).tap do |timesheet|
      timesheet.time_logs << build(:time_log, timesheet: timesheet, hours: hours)
      timesheet.save!
    end
  end
end
