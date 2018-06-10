# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'mocha/test_unit'
require 'webmock/minitest'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

class Minitest::Test
  def before_setup
    super
    DatabaseCleaner.start
  end

  def after_teardown
    DatabaseCleaner.clean
    super
  end
end

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :poltergeist
  config.javascript_driver = :poltergeist
  config.app_host = 'http://localhost:3000'
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  def sign_in(user, password = 'password')
    post(
      user_session_path,
      'user[email]' => user.email,
      'user[password]' => password
    )

    assert_response 302
  end

  def sign_out
    delete destroy_user_session_path
    assert_response 302
  end
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def create_business_with_valid_payment_source(attributes = {})
    create(:business, attributes).tap do |business|
      profile = build :payment_profile, business: business
      profile.expects :create_stripe_customer
      profile.save!
      source = build :payment_source, payment_profile: profile
      source.expects :create_source
      source.save!
    end
  end
end
