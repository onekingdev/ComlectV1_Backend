# frozen_string_literal: true

# https://devcenter.heroku.com/articles/forked-pg-connections#sidekiq
Sidekiq.configure_server do |config|
  if (database_url = ENV['DATABASE_URL'])
    ENV['DATABASE_URL'] = "#{database_url}?pool=#{ENV['SIDEKIQ_CONCURRENCY'] || 25}"
    ActiveRecord::Base.establish_connection
  end

  config.redis = { size: (ENV['REDIS_CONNECTIONS'] || 27).to_i }
end

Sidekiq.configure_client do |config|
  # 1 connection per Rails process
  config.redis = { size: (ENV['REDIS_CLIENT_CONNECTIONS'] || 1).to_i }
end

schedule_file = Rails.root.join('config/schedule.yml')
if File.exist?(schedule_file) && Sidekiq.server?
  schedule = YAML.load_file(schedule_file)
  Sidekiq::Cron::Job.load_from_hash schedule
end
