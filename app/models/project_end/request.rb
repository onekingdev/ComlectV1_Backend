# frozen_string_literal: true
class ProjectEnd::Request < Draper::Decorator
  decorates ProjectEnd
  delegate_all

  def self.process!(project)
    expires_at = 1.business_day.after(project.business.tz.now)
    # Delete previous request if any
    pending.where(project_id: project).delete_all
    new(create!(project: project, expires_at: expires_at)).tap do |request|
      ProjectMailer.deliver_later :end_request, request.project
    end
  end

  def self.confirm_or_deny!(project, params)
    if params[:confirm]
      project.end_request.confirm!
      project.complete!
    elsif params[:deny]
      project.end_request.deny!
      # TODO: Send notification to business?
    end
  end
end
