# frozen_string_literal: true
class Project::Ending
  def self.process!(project)
    project.complete!
    project.timesheets.pending.destroy_all
    Notification::Deliver.project_ended!(project)
  end
end
