# frozen_string_literal: true

class LocalProjectWRemindersSerializer < LocalProjectSerializer
  include RemindersFetcher

  def reminders
    tasks_for_object(object)
  end
end
