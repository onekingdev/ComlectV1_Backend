# frozen_string_literal: true

class ProjectIssue::Create
  def self.call(project, attributes)
    ProjectIssue.new(attributes.merge(project: project)).tap do |issue|
      if issue.save
        EscalatedProjectMailer.deliver_later :email_to_support, issue
        EscalatedProjectMailer.deliver_later :email_to_user, issue
        Notification::Deliver.escalated! issue
      end
    end
  end
end
