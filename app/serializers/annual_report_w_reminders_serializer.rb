# frozen_string_literal: true

class AnnualReportWRemindersSerializer < AnnualReportSerializer
  include RemindersFetcher

  def reminders
    tasks_for_object(object)
  end
end
