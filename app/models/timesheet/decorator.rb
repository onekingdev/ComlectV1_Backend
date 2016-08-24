# frozen_string_literal: true
class Timesheet::Decorator < Draper::Decorator
  decorates Timesheet
  delegate_all

  def business_button
    label, url = case status
                 # when Timesheet.statuses[:submitted]
                 #   ['Confirm', h.business_project_timesheet_path(project, self)]
                 when Timesheet.statuses[:disputed]
                   %w(Disputed #)
                 else
                   ['View', h.business_project_timesheet_path(project, self)]
                 end

    h.link_to label, url, remote: true, class: "btn btn-primary #{'disabled' if disputed?}"
  end

  def specialist_button
    label, url = case status
                 when Timesheet.statuses[:approved]
                   ['View', h.project_timesheet_path(project, self)]
                 when Timesheet.statuses[:submitted]
                   %w(Pending #)
                 else
                   ['Edit', h.edit_project_timesheet_path(project, self)]
                 end

    h.link_to label, url, remote: true, class: "btn btn-primary #{'disabled' if submitted?}"
  end

  def total_hours
    (time_logs.map(&:hours).compact.reduce(:+) || 0.0).to_f.round(2)
  end
end
