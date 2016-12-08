# frozen_string_literal: true
class Project::Ending
  def self.process!(project)
    project.complete!
    Notification::Deliver.project_ended!(project)
  end
end
