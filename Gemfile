# frozen_string_literal: true
source 'https://rubygems.org'
ruby '2.3.1'

# Rails
gem 'rails', '4.2.7'

# ActiveRecord
gem 'pg', '~> 0.15'
gem 'pg_search', '~> 1.0.6'
gem 'scenic'
gem 'faker'

# Orchestration
gem 'puma', '~> 3.4.0'
gem 'foreman', '~> 0.80.1'
gem 'dotenv-rails', '~> 2.0.2'

# Auth
gem 'devise', '~> 4.1.1'
gem 'pundit'

# Admin
gem 'activeadmin', github: 'activeadmin'
gem 'best_in_place', github: 'bernat/best_in_place'

# Asset processing
gem 'sassc-rails', '~> 1.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'non-stupid-digest-assets'

# Views
gem 'slim-rails', '~> 3.0.1'
gem 'simple_form', '~> 3.2'
gem 'country_select'
gem 'draper'
gem 'cocoon'
gem 'iso_country_codes'

# Misc
gem 'business_time'

# Assets
gem 'jquery-rails'

# Mail
gem 'postmark-rails'

# Image uploads
gem 'fastimage', '~> 2.0.0'
gem 'image_processing', '~> 0.3.0'
gem 'mini_magick', '~> 4.5.1'
gem 'aws-sdk', '~> 2.3.12'
gem 'shrine', '~> 2.0.1'
gem 'roda', '~> 2.14.0'

# API builder
gem 'jbuilder', '~> 2.0'

# Background jobs
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-failures'
gem 'sidekiq-unique-jobs'
gem 'sinatra', require: nil

# Payments
gem 'stripe'
gem 'plaid'

# Logging
gem 'lograge'
gem 'appsignal'

group :development, :test do
  # Logging
  gem 'quiet_assets'

  # Debugging
  gem 'byebug'

  # Testing
  gem 'factory_girl_rails'

  # Code Quality
  gem 'rubocop', require: false
end

group :development do
  # Debugging
  gem 'web-console', '~> 2.0'
  gem 'letter_opener'

  # Preloading
  gem 'spring'

  # Testing
  gem 'meta_request'
  gem 'overcommit', require: false
end

group :test do
  # Testing
  gem 'mocha'
  gem 'webmock'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
end

gem 'rails_12factor', group: :production
