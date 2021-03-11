# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.7'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end
gem 'bootsnap', require: false

# graphs
gem 'c3-rails'
gem 'd3-rails', '~> 3.5.17'

# conversion fun
gem 'imgkit'

# concurrent server
gem 'unicorn'

# doc to pdf
gem 'combine_pdf'
gem 'libreconv'
gem 'pdfjs_viewer-rails', git: 'https://github.com/kourindouhime/pdfjs_viewer-rails.git'
gem 'wicked_pdf'

# calendar
gem 'simple_calendar' # , '~> 2.0'

# captcha
gem 'bcrypt'
gem 'recaptcha', require: 'recaptcha/rails'

# Rails
gem 'font_assets'
gem 'rails', '6.0.3.4'
gem 'webpacker'

# ActiveRecord
gem 'auto_strip_attributes'
gem 'deep_pluck'
gem 'faker'
gem 'pg', '0.20.0'
gem 'pg_search'
gem 'rubyzip'
gem 'scenic'
gem 'zip-zip'

# Orchestration
gem 'dotenv-rails'
gem 'foreman'
gem 'puma'

# Auth
gem 'devise'
gem 'pretender'
gem 'pundit'

# Admin
gem 'activeadmin' # , '~> 1.2.1'
gem 'best_in_place', git: 'https://github.com/bernat/best_in_place.git'

# Asset processing
gem 'coffee-rails'
# gem 'non-stupid-digest-assets'
gem 'rack-cors', require: 'rack/cors'
# gem 'sassc-rails'
gem 'sprockets', '~>3.0'
gem 'uglifier'

# Views
gem 'activemodel-serializers-xml', git: 'https://github.com/rails/activemodel-serializers-xml'
gem 'cocoon'
gem 'country_select'
gem 'draper' # , '3.0.0.pre1'
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
gem 'aws-sdk' # , '~> 2.3.12'
gem 'fastimage' # , '~> 2.0.0'
gem 'image_processing' # , '~> 0.3.0'
gem 'mini_magick' # , '~> 4.5.1'
gem 'roda' # , '~> 2.14.0'
gem 'shrine', git: 'https://github.com/kourindouhime/shrine' # , '~> 2.4.0'

# API builder
gem 'jbuilder' # , '~> 2.0'

# Background jobs
gem 'activejob-traffic_control'
gem 'acts_as_list'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-scheduler'
gem 'sinatra', require: nil

# Payments
gem 'plaid', '5.0.0'
gem 'stripe'

gem 'jquery-ui-rails' # , '~> 5.0', '>= 5.0.5'
# Logging
gem 'lograge'

gem 'jwt'

# Serialization
gem 'active_model_serializers'

# Pagination
gem 'pagy'

# Sitemap
gem 'fog-aws'
gem 'sitemap_generator'

group :development, :test do
  # Logging
  gem 'awesome_print'
  # gem 'quiet_assets'

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
  gem 'overcommit' # , '~> 0.52.1', require: false

  # rails5 wants this
  gem 'listen'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'mocha'
  gem 'poltergeist'
  gem 'rails-controller-testing'
  gem 'stripe-ruby-mock', require: 'stripe_mock'
  gem 'timecop'
  gem 'webmock'
end

gem 'rails_12factor', group: :production
