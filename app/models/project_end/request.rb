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
end
