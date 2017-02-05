# frozen_string_literal: true
class Project::Starting
  def self.process!(project)
    project.update(starts_in_48: true)
    Notification::Deliver.starts_in_48!(project)
  end
end
