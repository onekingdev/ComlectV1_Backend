# frozen_string_literal: true

class Timesheet::Decorator < Draper::Decorator
  decorates Timesheet
  delegate_all

  def confirm_delete
    '<br><br>Are you sure you want to delete this timesheet?'.html_safe
  end

  def total_hours
    (time_logs.map(&:hours).compact.reduce(:+) || 0.0).to_f.round(2)
  end
end
