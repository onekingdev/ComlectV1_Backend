# frozen_string_literal: true
Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV.fetch('SIDEKIQ_USERNAME') && password == ENV.fetch('SIDEKIQ_PASSWORD')
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  devise_for :admin_users, ActiveAdmin::Devise.config
  begin
    ActiveAdmin.routes(self)
  rescue ActiveRecord::StatementInvalid, PG::UndefinedTable => e
    Rails.logger.info "ActiveAdmin could not load: #{e.message}"
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  } do
  end

  devise_scope :user do
    get 'users/sign_out/force' => 'users/sessions#destroy'
  end

  # LetsEncrypt Verification TODO: Remove after purchasing SSL cert
  get '/.well-known/acme-challenge/:id' => 'home#page', page: 'letsencrypt'

  root to: 'landing_page#show'
  get 'info/:page' => 'home#page', as: :page
  get 'app_config' => 'home#app_config', format: 'js'

  get 'specialist_sso' => 'discourse#specialist_sso'
  get 'business_sso' => 'discourse#business_sso'

  resources :businesses, only: %i(index new create show)
  resource :business, only: %i(edit) do
    patch '/' => 'businesses#update', as: :update
  end
  get '/business' => 'business_dashboard#show', as: :business_dashboard

  concern :favoriteable do
    resources :favorites, only: [] do
      post :toggle, on: :collection
    end
  end

  namespace :business do
    resource :settings, only: :show do
      resource :password
      resource :key_contact
      resource :delete_account
      resources :payment_settings, as: :payment, path: 'payment' do
        patch :make_primary
      end
      resources :notification_settings, as: :notifications, path: 'notifications', only: %i(index update)
    end
    resources :specialists, only: :index
    concerns :favoriteable
    resources :messages
    resources :financials do
      get :invoice, on: :member
    end

    get 'projects/:project_id/dashboard' => 'project_dashboard#show', as: :project_dashboard

    scope 'projects/:project_id' do
      resources :project_messages, path: 'messages'
      resources :project_ends, path: 'end'
      resources :project_extensions, path: 'extension'
      resource :project_rating, path: 'rating'
      resource :project_overview, path: 'overview'
    end

    resources :projects do
      post :post, on: :member
      get :copy, on: :member

      resources :job_applications, path: 'applications'
      resources :hires
      resources :documents
      resources :answers, only: :create
      resources :flags, only: :create
      resources :timesheets
      resources :project_issues, path: 'issues'
    end

    resources :job_applications do
      post :shortlist
      post :hide
    end
  end

  namespace :specialists, path: 'specialist' do
    get '/' => 'dashboard#show', as: :dashboard
    resource :settings, only: :show do
      resource :password
      resource :delete_account
      resource :payment_setting, as: :payment, path: 'payment'
      resources :notification_settings, as: :notifications, path: 'notifications', only: %i(index update)
    end
    resources :projects, path: 'my-projects'
    concerns :favoriteable
    resources :messages
    resources :financials do
      get :invoice, on: :member
    end
  end

  resources :specialists, only: %i(index new create show)
  resource :specialist, only: %i(edit) do
    patch '/' => 'specialists#update', as: :update
  end

  resources :project_invites, path: 'invite'

  resources :projects, only: %i(index show) do
    scope module: 'projects' do
      resources :job_applications, path: 'applications'
      resource :dashboard, only: :show
      resources :messages
      resources :documents
      resources :questions, only: :create
      resources :flags, only: :create
      resources :timesheets
      resources :issues
      resources :shares
      resource :project_end, path: 'end', as: :end
      resource :project_extension, path: 'extension', as: :extension
      resource :rating
      resource :overview, only: :show
    end
  end

  resources :notifications
  resources :email_threads, path: 'email', only: :create

  namespace :stripe do
    resources :webhooks, only: :create
  end

  namespace :api do
    resources :skills, only: :index
  end
end
