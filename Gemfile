# frozen_string_literal: true
source 'https://rubygems.org'
ruby '2.3.1'

# Rails
gem 'rails', '4.2.6'

# ActiveRecord
gem 'pg', '~> 0.15'

# Orchestration
gem 'puma', '~> 3.4.0'
gem 'foreman', '~> 0.80.1'
gem 'dotenv-rails', '~> 2.0.2'

# Asset processing
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'non-stupid-digest-assets'

# Views
gem 'slim-rails', '~> 3.0.1'
gem 'simple_form', '~> 3.2'

# Assets
gem 'jquery-rails'
gem 'turbolinks'

# API builder
gem 'jbuilder', '~> 2.0'

# Background jobs
gem 'sidekiq'

# Logging
gem 'lograge'

group :development, :test do
  # Logging
  gem 'quiet_assets'

  # Debugging
  gem 'byebug'

  # Testing
  gem 'factory_girl_rails'
  gem 'faker'

  # Code Quality
  gem 'rubocop', require: false
end

group :development do
  # Debugging
  gem 'web-console', '~> 2.0'

  # Preloading
  gem 'spring'

  # Testing
  gem 'letter_opener'
  gem 'meta_request'
  gem 'overcommit', require: false
end

group :test do
  # Testing
  gem 'mocha'
  gem 'webmock'
  gem 'capybara'
  gem 'poltergeist'
end
