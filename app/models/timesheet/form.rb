# frozen_string_literal: true
class Timesheet::Form < Timesheet::Decorator
  decorates Timesheet
  delegate_all

  def self.new_for(project)
    new project.timesheets.new(time_logs: [TimeLog.new])
  end

  def self.create(project, attributes)
    new(project.timesheets.new(attributes.except(:save, :submit))).tap do |form|
      form.status = Timesheet.statuses[:submitted] if attributes[:submit]
      form.notify_business! if form.save && form.submitted?
    end
  end

  def self.update(timesheet, attributes)
    new(timesheet).tap do |form|
      form.assign_attributes attributes.except(:submit, :save)
      form.status = Timesheet.statuses[:submitted] if attributes[:submit]
      form.notify_business! if form.save && form.submitted?
    end
  end

  def notify_business!
    # TODO: Send notification to business
  end
end
