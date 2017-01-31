# frozen_string_literal: true
# otherwise Notification::Deliver.path_and_url acts incorrect with anchor argumet
Rails.application.routes.default_url_options[:host] = ENV.fetch('DEFAULT_URL_HOST')
