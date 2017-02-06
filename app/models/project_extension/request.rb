# frozen_string_literal: true
class ProjectExtension::Request < Draper::Decorator
  decorates ProjectExtension
  delegate_all

  include NotificationsHelper

  # TODO: Schedule expiring stale requests

  def self.process!(project, new_end_date)
    expires_at = 1.business_day.after(project.business.tz.now)
    # Delete previous request if any
    pending.where(project_id: project).delete_all
    new(create!(project: project, expires_at: expires_at, new_end_date: new_end_date)).tap do |request|
      Notification::Deliver.extend_project! request
    end
  end

  def self.confirm_or_deny!(project, params)
    extension = project.extension
    if params[:confirm]
      extension.confirm!
      project.update_attributes(ends_on: extension.new_end_date, ends_in_24: false)
      Notification::Deliver.extension_accepted! extension
    elsif params[:deny]
      extension.deny!
      Notification::Deliver.extension_denied! extension
    end
  end
end
