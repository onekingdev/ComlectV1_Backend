# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.2'

# Rails
gem 'rails', '4.2.10'

# ActiveRecord
gem 'auto_strip_attributes'
gem 'deep_pluck'
gem 'faker'
gem 'pg', '~> 0.15'
gem 'pg_search', '~> 1.0.6'
gem 'scenic'

# Orchestration
gem 'dotenv-rails'
gem 'foreman'
gem 'puma'

# Auth
gem 'devise', '~> 4.1.1'
gem 'pretender'
gem 'pundit'

# Admin
gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin.git'
gem 'best_in_place', git: 'https://github.com/bernat/best_in_place.git'

# Asset processing
gem 'coffee-rails', '~> 4.1.0'
gem 'non-stupid-digest-assets'
gem 'rack-cors', require: 'rack/cors'
gem 'sassc-rails', '~> 1.3'
gem 'uglifier', '>= 1.3.0'

# Views
gem 'cocoon'
gem 'country_select'
gem 'draper'
gem 'iso_country_codes'
gem 'simple_form'
gem 'slim-rails'

# Misc
gem 'bugsnag'
gem 'business_time'
gem 'ice_cube'
gem 'ledermann-rails-settings'
gem 'pry-rails'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# Discourse
gem 'discourse_api'

# Assets
gem 'imagesLoaded_rails'
gem 'jquery-mousewheel-rails'
gem 'jquery-rails'
gem 'jquery-slick-rails'

# Mail
gem 'postmark-rails'

# Image uploads
gem 'aws-sdk', '~> 2.3.12'
gem 'fastimage', '~> 2.0.0'
gem 'image_processing', '~> 0.3.0'
gem 'mini_magick', '~> 4.5.1'
gem 'roda', '~> 2.14.0'
gem 'shrine', '~> 2.4.0'

# API builder
gem 'jbuilder', '~> 2.0'

# Background jobs
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-failures'
gem 'sidekiq-unique-jobs'
gem 'sinatra', require: nil

# Payments
gem 'plaid-legacy'
gem 'stripe'

# Logging
gem 'lograge'

group :development, :test do
  # Logging
  gem 'quiet_assets'

  # Debugging
  gem 'byebug'

  # Testing
  gem 'factory_girl_rails'
  gem 'rspec-rails'

  # Code Quality
  gem 'rubocop', require: false
end

group :development do
  # Debugging
  gem 'mailcatcher'
  gem 'web-console'

  # Preloading
  gem 'spring'
  gem 'spring-commands-rspec'

  # Testing
  gem 'meta_request'
  gem 'overcommit', require: false
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'mocha'
  gem 'poltergeist'
  gem 'stripe-ruby-mock', require: 'stripe_mock'
  gem 'test_after_commit'
  gem 'timecop'
  gem 'webmock'
end

gem 'rails_12factor', group: :production
