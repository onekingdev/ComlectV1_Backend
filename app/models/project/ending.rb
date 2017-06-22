# frozen_string_literal: true
class Project::Ending < Project
  def self.process!(project)
    project.complete!
    project.timesheets.pending.destroy_all
    PaymentCycle.for(project).create_charges_and_reschedule!
    Notification::Deliver.project_ended!(project)
  end

  def self.ends_in_24!(project)
    return if project.ends_in_24
    project.update(ends_in_24: true)
    Notification::Deliver.ends_in_24!(project)
  end
end
