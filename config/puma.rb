# frozen_string_literal: true

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count
worker_timeout 3500 unless ENV['RAILS_ENV'] == 'production'

preload_app!

before_fork do
  @sidekiq_pid ||= spawn('bundle exec sidekiq -C config/sidekiq.yml') # unless ENV['HEROKU_BRANCH'] == 'master'
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

on_restart do
  Sidekiq.redis.shutdown(&:close) # unless ENV['HEROKU_BRANCH'] == 'master'
end

rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

plugin :tmp_restart
