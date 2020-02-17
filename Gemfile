# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.7'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# conversion fun
gem 'imgkit'

# Capistrano deploy
group :development do
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-sidekiq'
  gem 'capistrano3-unicorn'
  gem 'rvm1-capistrano3', require: false
end

# concurrent server
gem 'unicorn'

# doc to pdf
gem 'libreconv'
gem 'pdfjs_viewer-rails', git: 'https://github.com/MattFenelon/pdfjs_viewer-rails.git'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# calendar
gem 'simple_calendar', '~> 2.0'

# captcha
gem 'bcrypt'
gem 'recaptcha', require: 'recaptcha/rails'

# Rails
gem 'font_assets'
gem 'rails', '4.2.10'
gem 'webpacker'

# ActiveRecord
gem 'auto_strip_attributes'
gem 'deep_pluck'
gem 'faker'
gem 'pg', '0.20.0'
gem 'pg_search'
gem 'scenic'
gem 'where-or'

# Orchestration
gem 'dotenv-rails'
gem 'foreman'
gem 'puma'

# Auth
gem 'devise'
gem 'pretender'
gem 'pundit'

# Admin
gem 'activeadmin', '~> 1.2.1'
gem 'best_in_place', git: 'https://github.com/bernat/best_in_place.git'

# Asset processing
gem 'coffee-rails'
gem 'non-stupid-digest-assets'
gem 'rack-cors', require: 'rack/cors'
gem 'sassc-rails'
gem 'sprockets', '~>3.0'
gem 'uglifier'

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

# Assets
gem 'imagesLoaded_rails'
gem 'jquery-mousewheel-rails'
gem 'jquery-rails'
gem 'jquery-slick-rails'
gem 'js_cookie_rails'

# Mail
gem 'postmark-rails'

# Mailchimp
gem 'gibbon'

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
gem 'activejob-traffic_control'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-scheduler'
gem 'sinatra', require: nil

# Payments
gem 'plaid-legacy'
gem 'stripe'

# Logging
gem 'lograge'

# Sitemap
gem 'fog-aws'
gem 'sitemap_generator'

# Other
gem 'hubspot-ruby'

group :development, :test do
  # Logging
  gem 'quiet_assets'

  # Debugging
  gem 'byebug'

  # Testing
  gem 'factory_bot_rails', '~> 4.10.0'
  gem 'rspec-rails'

  # Code Quality
  gem 'rubocop', '~> 0.58.1', require: false
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
