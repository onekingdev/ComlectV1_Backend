# frozen_string_literal: true
class Admin::TimesheetDecorator < AdminDecorator
  decorates Timesheet

  def to_s
    "Timesheet #{id}"
  end

  def status_css
    {
      'submitted' => 'blue',
      'approved'  => 'green',
      'charged'   => 'green',
      'disputed'  => 'red'
    }[status]
  end

  def total_hours
    time_logs.map(&:hours).reduce(:+)
  end

  def total_amount
    time_logs.map(&:total_amount).reduce(:+)
  end
end
