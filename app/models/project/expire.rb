# frozen_string_literal: true
class Project::Expire
  def self.call(project)
    project.job_applications.delete_all
    project.draft!
  end
end
