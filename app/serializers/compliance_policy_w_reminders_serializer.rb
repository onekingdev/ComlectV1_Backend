# frozen_string_literal: true

class CompliancePolicyWRemindersSerializer < CompliancePolicySerializer
  include RemindersFetcher

  def reminders
    tasks_for_object(object)
  end
end
