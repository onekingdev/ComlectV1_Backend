# frozen_string_literal: true
class Project::Expire
  def self.call(project)
    project.job_applications.delete_all
    project.draft!
    Notification::Deliver.start_date_lapsed! project
  end
end
