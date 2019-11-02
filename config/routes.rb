# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == ENV.fetch('SIDEKIQ_USERNAME') && password == ENV.fetch('SIDEKIQ_PASSWORD')
    end
  end
  mount Sidekiq::Web => '/sidekiq'
  mount PdfjsViewer::Rails::Engine => '/pdfjs', as: 'pdfjs'

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
    get '/squarespace' => 'users/sessions#squarespace'
    get '/squarespace_destroy' => 'users/sessions#squarespace_destroy'
  end

  root to: 'landing_page#show'
  get 'info/:page' => 'home#page', as: :page
  get 'app_config' => 'home#app_config', format: 'js'
  get 'partnerships' => 'home#partnerships'
  get 'press' => 'home#press'
  get 'r/:token' => 'referrals#show', as: :referrals

  namespace :partners, only: [] do
    resources :ima, only: %i[index create]
  end

  get '/ask-a-specialist/search' => 'forum_questions#search', as: :forum_search
  resources :forum_questions, path: 'ask-a-specialist', param: :url
  resources :forum_answers, only: :create
  get '/ask-a-specialist/upvote/:id' => 'forum_votes#upvote'
  get '/ask-a-specialist/downvote/:id' => 'forum_votes#downvote'
  get '/forum_subscriptions/create' => 'forum_subscriptions#create'
  get '/forum_subscriptions/upgrade' => 'forum_subscriptions#upgrade'
  get '/forum_subscriptions/cancel' => 'forum_subscriptions#cancel'

  get '/notifications_settings' => 'notifications#route'

  resources :turnkey_pages, only: %i[index show create new], path: 'turnkey'
  #  resources :turnkey_solutions # , only: :create
  post '/turnkey/:id' => 'turnkey_pages#create'
  patch '/turnkey/:id' => 'turnkey_pages#update'

  resources :feedback_requests, only: %i[create new]
  resources :businesses, only: %i[new create show]
  resource :business, only: %i[edit] do
    patch '/' => 'businesses#update', as: :update
  end
  get '/business' => 'business_dashboard#show', as: :business_dashboard

  concern :favoriteable do
    resources :favorites, only: [] do
      post :toggle, on: :collection
    end
  end
  resources :flags, only: %i[new create]

  namespace :business do
    get '/personalize' => 'personalize#quiz'
    post '/personalize' => 'personalize#quiz'
    resources :compliance_policies, only: %i[new update create edit show]
    resource :settings, only: :show do
      resource :password
      resource :key_contact
      resource :referrals, only: :show
      resource :delete_account
      resources :payment_settings, as: :payment, path: 'payment' do
        patch :make_primary
      end
      resources :notification_settings, as: :notifications, path: 'notifications', only: %i[index update]
      resources :subscription_settings, as: :subscriptions, path: 'subscriptions', only: %i[index update]
    end
    resources :specialists, only: :index
    concerns :favoriteable
    resources :messages
    resources :financials do
      get :invoice, on: :member
    end

    get 'projects/:project_id/interview/:specialist_username' => 'project_dashboard#show', as: :project_dashboard_interview
    get 'projects/:project_id/dashboard' => 'project_dashboard#show', as: :project_dashboard

    scope 'projects/:project_id' do
      resources :project_messages, path: 'messages(/:specialist_username)'
      resources :project_ends, path: 'end'
      resources :project_extensions, path: 'extension'
      resource :project_rating, path: 'rating'
      resource :project_overview, path: 'overview(/:specialist_username)', only: :show
    end

    resources :projects do
      post :post, on: :member
      get :copy, on: :member

      resources :job_applications, path: 'applications'
      resources :hires
      resources :documents, path: 'documents(/:specialist_username)'
      resources :answers, only: :create
      resources :flags, only: %i[new create]
      resources :timesheets
      resources :project_issues, path: 'issues'
    end

    resources :job_applications do
      post :shortlist
      post :hide
    end
  end

  resources :tos_agreement, only: %i[create]

  namespace :specialists, path: 'specialist' do
    get '/' => 'dashboard#show', as: :dashboard
    resource :settings, only: :show do
      resource :password
      resource :contact_information, only: %i[show update]
      resource :referrals, only: :show
      resource :delete_account
      resources :delete_managed_accounts, only: :destroy
      resource :payment_settings, as: :payment, path: 'payment'
      resource :team

      resources :bank_accounts do
        patch :make_primary
      end
      resources :notification_settings, as: :notifications, path: 'notifications', only: %i[index update]
    end

    resources :invitations, only: %i[create destroy]
    resources :projects, path: 'my-projects'
    concerns :favoriteable
    resources :messages
    resources :financials do
      get :invoice, on: :member
    end
  end

  resources :specialists, only: %i[index new create show]
  resource :specialist, only: %i[edit] do
    patch '/' => 'specialists#update', as: :update
  end

  resources :project_invites, path: 'invite'

  resources :projects, only: %i[index show] do
    scope module: 'projects' do
      resources :job_applications, path: 'applications'
      resource :dashboard, only: :show
      resources :messages
      resources :documents
      resources :questions, only: :create
      resources :flags, only: %i[new create]
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
