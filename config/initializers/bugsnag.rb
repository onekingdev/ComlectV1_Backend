# frozen_string_literal: true

Bugsnag.configure do |config|
  config.notify_release_stages = %w[staging production]
end
