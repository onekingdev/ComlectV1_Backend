# frozen_string_literal: true

Bugsnag.configure do |config|
  config.notify_release_stages = %w[staging production]
  config.release_stage = ENV['BUGSNAG_RELEASE_STAGE'] || ENV['RAILS_ENV']
end
