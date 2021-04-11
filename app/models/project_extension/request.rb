# frozen_string_literal: true

class ProjectExtension::Request < Draper::Decorator
  decorates ProjectExtension
  delegate_all

  include NotificationsHelper

  def self.process!(project, params, someone)
    return if project.end_requests.any?(&:confirmed?)

    # Delete previous request if any
    pending.where(project_id: project).delete_all
    expires_at = BufferDate.for(project.business.tz.now, time_zone: project.business.tz)
    new(create!(project: project,
                expires_at: expires_at,
                ends_on: params[:ends_on],
                starts_on: (params[:starts_on] || project.starts_on),
                role_details: (params[:role_details] || project.role_details),
                ends_on_only: (params[:ends_on_only] || false),
                key_deliverables: (params[:key_deliverables] || project.key_deliverables),
                fixed_budget: (project.fixed_budget? ? (params[:fixed_budget] || project.fixed_budget) : nil),
                hourly_rate: (project.hourly_rate? ? (params[:hourly_rate] || project.hourly_rate) : nil),
                requester: someone.class.name)).tap do |request|
      Notification::Deliver.extend_project! request
    end
  end

  def self.confirm_or_deny!(project, params, confirmer)
    extension = project.extension
    return false if confirmer.class.name == extension.requester
    if params[:confirm]
      extension.confirm!
      Notification::Deliver.extension_accepted! extension
    elsif params[:deny]
      extension.deny!
      Notification::Deliver.extension_denied! extension
    end
  end
end
