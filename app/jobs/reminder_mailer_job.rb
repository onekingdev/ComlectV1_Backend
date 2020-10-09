# frozen_string_literal: true

class ReminderMailerJob < ApplicationJob
  include RemindersFetcher
  queue_as :mailers
  # rubocop:disable Rails/Output
  # rubocop:disable Style/GuardClause
  def perform(remindable = nil)
    return process_all if remindable.nil?
    puts "AYYYYYY PROCESSING #{remindable}"
    remindable.update(reminders_mailed_at: Time.zone.today.in_time_zone(remindable.time_zone).to_date)
    calendar_grid = tasks_calendar_grid(remindable, Time.zone.today.in_time_zone(remindable.time_zone).beginning_of_month
    .to_date)
    todays = reminders_today(remindable, calendar_grid)
    past_dues = reminders_past(remindable)
    puts todays.length
    puts past_dues.length
    if (todays.length + past_dues.length).positive?
      ReminderMailer.send_today(remindable, past_dues, todays)
      puts 'Mail sent'
    end
  end
  # rubocop:enable Style/GuardClause
  # rubocop:enable Rails/Output

  private

  def process_all
    (Business.all + Specialist.all).each do |remindable|
      if remindable.reminders_mailed_at.nil? || ((remindable.reminders_mailed_at.in_time_zone(remindable.time_zone) +
        1.day).change(hour: 8) < Time.now.in_time_zone(remindable.time_zone))
        self.class.perform_later(remindable)
      end
    end
  end
end
