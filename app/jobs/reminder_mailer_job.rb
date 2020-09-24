# frozen_string_literal: true

class ReminderMailerJob < ApplicationJob
  include RemindersFetcher
  queue_as :mailers

  def perform(remindable_id = nil, remindable_class = nil)
    return process_all if remindable_id.nil?
    remindable = remindable_class == 'Business' ? Business.find(remindable_id) : Specialist.find(remindable_id)
    remindable.update(reminders_mailed_at: Time.zone.today.in_time_zone(remindable.time_zone).to_date)
    calendar_grid = tasks_calendar_grid(remindable, Time.zone.today.in_time_zone(remindable.time_zone).to_date)
    todays = reminders_today(remindable, calendar_grid)
    past_dues = reminders_past(remindable)
    ReminderMailer.send_today(remindable, past_dues, todays) if (todays.length + past_dues.length).positive?
  end

  private

  def process_all
    (Business.all + Specialist.all).each do |remindable|
      if remindable.reminders_mailed_at.nil? || ((remindable.reminders_mailed_at.in_time_zone(remindable.time_zone) +
        1.day).change(hour: 8) < Time.now.in_time_zone(remindable.time_zone))
        self.class.perform_later(remindable.id, remindable.class.name)
      end
    end
  end
end
