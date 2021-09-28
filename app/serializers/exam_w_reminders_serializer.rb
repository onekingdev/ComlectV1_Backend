# frozen_string_literal: true

class ExamWRemindersSerializer < ExamSerializer
  include RemindersFetcher

  def reminders
    tasks_for_object(object)
  end
end
