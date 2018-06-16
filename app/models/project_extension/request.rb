# frozen_string_literal: true

class ProjectExtension::Request < Draper::Decorator
  decorates ProjectExtension
  delegate_all

  include NotificationsHelper

  def self.process!(project, new_end_date)
    return if project.end_requests.any?(&:confirmed?)

    # Delete previous request if any
    pending.where(project_id: project).delete_all
    expires_at = BufferDate.for(project.business.tz.now, time_zone: project.business.tz)
    new(create!(project: project, expires_at: expires_at, new_end_date: new_end_date)).tap do |request|
      Notification::Deliver.extend_project! request
    end
  end

  def self.confirm_or_deny!(project, params)
    extension = project.extension
    if params[:confirm]
      extension.confirm!
      Notification::Deliver.extension_accepted! extension
    elsif params[:deny]
      extension.deny!
      Notification::Deliver.extension_denied! extension
    end
  end
end
