# frozen_string_literal: true

schedule_file = Rails.root.join('config/schedule.yml')
if File.exist?(schedule_file) && Sidekiq.server?
  schedule = YAML.load_file(schedule_file)
  Sidekiq::Cron::Job.load_from_hash schedule
end
