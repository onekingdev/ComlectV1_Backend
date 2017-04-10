# frozen_string_literal: true
class ProjectEnd::Request < Draper::Decorator
  decorates ProjectEnd
  delegate_all

  extend NotificationsHelper

  def self.process!(project)
    # Delete previous request if any
    pending.where(project_id: project).delete_all
    expires_at = 1.business_day.after(project.business.tz.now)
    new(create!(project: project, expires_at: expires_at)).tap do |request|
      Notification::Deliver.end_project! request
    end
  end

  def self.confirm_or_deny!(project, params)
    return if project.escalated? || project.disputed_timesheets?
    end_request = project.end_request
    if params[:confirm]
      end_request.confirm!
      Notification::Deliver.end_project_accepted! end_request
    elsif params[:deny]
      end_request.deny!
      Notification::Deliver.end_project_denied! end_request
    end
  end
end
