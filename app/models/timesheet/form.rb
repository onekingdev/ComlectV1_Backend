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
      if form.save && attributes[:submit]
        form.submitted!
        Notification::Deliver.timesheet_submitted! timesheet
      end
    end
  end

  def self.process(timesheet, process)
    new(timesheet).tap do |form|
      form.dispute! if process[:dispute] == '1'
      form.approve! if process[:approve] == '1'
    end
  end

  def dispute!
    update_attribute :status, Timesheet.statuses[:disputed]
    Notification::Deliver.specialist_timesheet_disputed! self
    # Allow another day for specialists to edit the timesheet if project is ending
    project.update_attribute :ends_on, project.ends_on + 1.day if project.past_ends_on?
  end

  def approve!
    self.class.transaction do
      update_attributes status: Timesheet.statuses[:approved], status_changed_at: Time.zone.now
      update_static_attributes
      PaymentCycle.for(project).reschedule!
      Project::Ending.process!(project) if project.past_ends_on? && !project.escalated?
    end
  end

  def add_link(f)
    data = { association_insertion_node: '#js-form-timesheet-add-log-before' }
    h.link_to_add_association f, :time_logs, data: data do
      h.content_tag :i, '', class: 'fa fa-plus text-muted', title: "Add another", "data-toggle" => "tooltip"
    end
  end

  private

  def update_static_attributes
    time_logs.update_all hourly_rate: project.hourly_rate
    time_logs.update_all 'total_amount = hourly_rate * hours'
  end
end
