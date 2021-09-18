# frozen_string_literal: true

# inclde SimpleCov
# https://github.com/simplecov-ruby/simplecov
require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
if Rails.env.production? || Rails.env.staging?
  abort('The Rails environment is running in production mode!')
end

require 'spec_helper'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  config.include ModelHelper, type: :model
  config.include ControllerHelper, type: :controller

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::Test::ControllerHelpers, type: :controller

  # include factory_bot_rails
  # https://github.com/thoughtbot/factory_bot_rails
  config.include FactoryBot::Syntax::Methods
end

# including shoulda-matchers
# https://github.com/thoughtbot/shoulda-matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
