# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/test_unit'
require 'webmock/minitest'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :poltergeist
  config.javascript_driver = :poltergeist
  config.app_host = 'http://localhost:3000'
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
