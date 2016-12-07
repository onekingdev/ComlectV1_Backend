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

  def self.process(timesheet, process)
    new(timesheet).tap do |form|
      form.dispute! if process[:dispute] == '1'
      form.approve! if process[:approve] == '1'
    end
  end

  def dispute!
    specialist.user.notifications.create! message: 'Timesheet disputed',
                                          path: h.project_dashboard_path(project, anchor: 'project-timesheets')
    update_attribute :status, Timesheet.statuses[:disputed]
  end

  def approve!
    self.class.transaction do
      update_attributes status: Timesheet.statuses[:approved], approved_at: Time.zone.now
      time_logs.update_all hourly_rate: project.hourly_rate
      time_logs.update_all 'total_amount = hourly_rate * hours'
      PaymentCycle.for(project).reschedule!
    end
  end

  def notify_business!
    # TODO: Send notification to business
  end

  def add_link(f)
    data = { association_insertion_node: '#js-form-timesheet-add-log-before' }
    h.link_to_add_association f, :time_logs, data: data do
      h.content_tag :i, '', class: 'fa fa-plus text-muted'
    end
  end
end
