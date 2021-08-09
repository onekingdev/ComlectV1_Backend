# frozen_string_literal: true

class ProjectEnd::Request < Draper::Decorator
  decorates ProjectEnd
  delegate_all

  extend NotificationsHelper

  def self.process!(project, someone = nil)
    return if project.end_requests.any?(&:confirmed?)

    # Delete previous request if any
    pending.where(project_id: project).delete_all
    expires_at = BufferDate.for(project.business.tz.now, time_zone: project.business.tz)
    obj = new(create!(project: project, expires_at: expires_at, requester: someone.class.name))

    obj.tap do |request|
      if someone.class.name.include?('Business')
        request.confirm!
        Notification::Deliver.end_project_accepted! request
      else
        Notification::Deliver.end_project! request
      end
    end
  end

  def self.confirm_or_deny!(project, params, confirmer)
    return if project.escalated? || project.disputed_timesheets?
    end_request = project.end_request
    return false if confirmer.class.name == end_request.requester
    if params[:confirm]
      end_request.confirm!
      Notification::Deliver.end_project_accepted! end_request
    elsif params[:deny]
      end_request.deny!
      Notification::Deliver.end_project_denied! end_request
    end
  end
end
