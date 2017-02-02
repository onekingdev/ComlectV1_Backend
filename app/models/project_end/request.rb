# frozen_string_literal: true
class ProjectEnd::Request < Draper::Decorator
  decorates ProjectEnd
  delegate_all

  extend NotificationsHelper

  # TODO: Schedule expiring stale requests

  def self.process!(project)
    expires_at = 1.business_day.after(project.business.tz.now)
    # Delete previous request if any
    pending.where(project_id: project).delete_all
    new(create!(project: project, expires_at: expires_at)).tap do |request|
      Notification::Deliver.end_project! request
    end
  end

  def self.confirm_or_deny!(project, params)
    end_request = project.end_request
    if params[:confirm]
      end_request.confirm!
      Project::Ending.process! project
      Notification::Deliver.end_project_accepted! end_request
    elsif params[:deny]
      end_request.deny!
      Notification::Deliver.end_project_denied! end_request
    end
  end
end
