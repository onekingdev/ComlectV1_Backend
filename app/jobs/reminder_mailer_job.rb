# frozen_string_literal: true

class ReminderMailerJob < ApplicationJob
  include RemindersFetcher
  queue_as :mailers

  def perform(remindable = nil)
    return process_all if remindable.nil?
    remindable.update(reminders_mailed_at: Time.zone.now.in_time_zone(remindable.time_zone))
    calendar_grid = tasks_calendar_grid(remindable, Time.zone.now.in_time_zone(remindable.time_zone).beginning_of_month
    .to_date)
    todays = projectdel(reminders_today(remindable, calendar_grid)).collect(&:body)
    past_dues = projectdel(reminders_past(remindable)).collect(&:body)
    tsize = todays.length + past_dues.length
    ReminderMailer.deliver_later(:send_today, remindable, past_dues.to_json, todays.to_json) if tsize.positive?
  end

  private

  def process_all
    (Business.where(ria_dashboard: true) + Specialist.where(dashboard_unlocked: true)).each do |remindable|
      if remindable.reminders_mailed_at.nil? || ((remindable.reminders_mailed_at.in_time_zone(remindable.time_zone) +
        1.day).change(hour: 8) < Time.zone.now.in_time_zone(remindable.time_zone))
        self.class.perform_later(remindable)
      end
    end
  end

  def projectdel(tasks_arr)
    tasks_arr.delete_if { |p| p.class.name == 'Project' && p.status == 'complete' }
  end
end
