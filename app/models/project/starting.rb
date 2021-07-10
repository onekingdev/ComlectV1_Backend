# frozen_string_literal: true

class Project::Starting
  def self.process!(project)
    project.update(starts_in_48: true)
    Notification::Deliver.starts_in_48!(project)
  end

  def self.fix_starting!(project)
    project.update(starts_in_48: false) if project.starts_on >= Time.zone.today + 2.days
  end
end
