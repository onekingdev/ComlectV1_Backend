# frozen_string_literal: true
class ProjectIssue::Create
  def self.call(project, attributes)
    ProjectIssue.new(attributes.merge(project: project)).tap do |issue|
      ProjectMailer.escalate(issue).deliver_later if issue.save
    end
  end
end
