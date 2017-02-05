# frozen_string_literal: true
class Project::Ending
  def self.process!(project)
    project.complete!
    project.timesheets.pending.destroy_all
    Notification::Deliver.project_ended!(project)
  end

  def self.ends_in_24(project)
    project.update(ends_in_24: true)
    Notification::Deliver.ends_in_24!(project)
  end
end
