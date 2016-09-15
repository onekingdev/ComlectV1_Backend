# frozen_string_literal: true
class ProjectExtension::Request < Draper::Decorator
  decorates ProjectExtension
  delegate_all

  # TODO: Schedule expiring stale requests

  def self.process!(project, new_end_date)
    expires_at = 1.business_day.after(project.business.tz.now)
    # Delete previous request if any
    pending.where(project_id: project).delete_all
    new(create!(project: project, expires_at: expires_at, new_end_date: new_end_date)).tap do |request|
      ProjectMailer.deliver_later :extension_request, request.project
    end
  end

  def self.confirm_or_deny!(project, params)
    if params[:confirm]
      extension = project.extension
      extension.confirm!
      project.update_attribute :ends_on, extension.new_end_date
    elsif params[:deny]
      project.end_request.deny!
    end
  end
end
