# frozen_string_literal: true

class Timesheet::Decorator < Draper::Decorator
  decorates Timesheet
  delegate_all

  def total_hours
    (time_logs.map(&:hours).compact.reduce(:+) || 0.0).to_f.round(2)
  end
end
