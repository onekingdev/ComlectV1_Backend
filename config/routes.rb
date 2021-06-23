# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  delete 'subscriptions/:id', to: 'subscriptions#cancel', as: 'cancel_subscription'
  delete 'ported_subscriptions/:id', to: 'subscriptions#specialist_cancel', as: 'specialist_cancel_subscription'
  put 'subscriptions/:id', to: 'subscriptions#update', as: 'update_subscription'

  if Rails.env.production? || Rails.env.staging?
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
  get 'app_config' => 'home#app_config', format: 'js'
  get 'marketplace' => 'home#marketplace'
  get 'r/:token' => 'referrals#show', as: :referrals
  get 'q-and-a-forum' => 'home#q_and_a_forum', as: :q_and_a_forum

  get '/ask-a-specialist/search' => 'forum_questions#search', as: :forum_search
  resources :forum_questions, path: 'ask-a-specialist', param: :url
  resources :forum_answers, only: :create
  get '/ask-a-specialist/upvote/:id' => 'forum_votes#upvote'
  get '/ask-a-specialist/downvote/:id' => 'forum_votes#downvote'
  get '/forum_subscriptions/create' => 'forum_subscriptions#create'
  get '/forum_subscriptions/upgrade' => 'forum_subscriptions#upgrade'
  get '/forum_subscriptions/cancel' => 'forum_subscriptions#cancel'

  get '/notifications_settings' => 'notifications#route'

  get '/exams/:uuid' => 'exams#show'

  resources :turnkey_pages, only: %i[index show create new], path: 'turnkey'
  #  resources :turnkey_solutions # , only: :create
  post '/turnkey/:id' => 'turnkey_pages#create'
  patch '/turnkey/:id' => 'turnkey_pages#update'
  get '/mute_project/:id' => 'project_mutes#toggle'

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
    get '/personalize_book' => 'personalize#book'
    get '/onboarding' => 'onboarding#index'
    post '/onboarding' => 'onboarding#subscribe'
    get '/upgrade' => 'upgrade#index'
    get '/upgrade/buy' => 'upgrade#buy'
    post '/upgrade/buy' => 'upgrade#subscribe'
    resources :risks, only: %i[index show]
    get '/reports/risks' => 'reports#risks'
    resources :file_folders, only: %i[index show]
    resources :exam_management, only: %i[index show] do
      get :portal, on: :member
    end
    resources :file_docs
    resources :upgrade
    resources :addons, only: %i[index]
    resources :seats, only: %i[index new] do
      delete :unassign
      post :assign
    end
    post '/seats/buy' => 'seats#buy'
    resources :compliance_policies, only: %i[show index] do
      get :entire, on: :collection
    end
    get 'annual_reviews/:id/:revcat', to: 'annual_reviews#revcat'
    resources :annual_reviews, only: %i[new create show destroy index edit update]
    resources :annual_reports, only: %i[new create index update]
    resources :teams, only: %i[new create show edit index update destroy]
    resources :team_members, only: %i[new create edit update destroy]
    resources :reminders, only: %i[new update create destroy show edit index]
    resources :audit_requests, only: %i[index update create new edit show destroy]
    put '/audit_requests' => 'audit_requests#update'
    resource :help, only: :show do
      resource :questions
    end
    resource :projects, only: %i[index]
    get 'settings' => 'settings#show'
    get 'settings/:id' => 'settings#show'

    get 'profile' => 'profile#show'

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

    get 'project_posts/:id' => 'projects#show_post'
    get 'project_posts/:id/edit' => 'projects#update_post'

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

  resources :employees, path: 'employee', only: %i[new create index]
  get '/employees/mirror/:business_id', to: 'employees#mirror', as: 'mirror_business'
  get '/employees/stop-mirror', to: 'employees#stop_mirror', as: 'stop_mirror_business'

  namespace :specialists, path: 'specialist' do
    get '/onboarding' => 'onboarding#index'
    post '/onboarding' => 'onboarding#subscribe'
    get '/' => 'dashboard#show', as: :dashboard
    get '/locked' => 'dashboard#locked'
    resources :reminders, only: %i[new update create destroy edit show index]
    resources :addons, only: %i[index]
    resource :help, only: :show do
      resource :questions
    end
    resource :settings, only: :show do
      resource :password
      resource :contact_information, only: %i[show update]
      # resource :referrals, only: :show
      resources :subscription_settings, as: :subscriptions, path: 'subscriptions', only: %i[index update]
      resource :delete_account
      resources :delete_managed_accounts, only: :destroy
      resource :payment_settings, as: :payment, path: 'payment' do
        get :new_card
        post :create_card
        post :create_bank
        delete 'delete_card/:id', to: 'payment_settings#delete_card', as: 'delete_card'
        patch 'make_primary/:id', to: 'payment_settings#make_primary', as: 'make_primary'
        patch '/specialist/settings/payment/:id/validate', to: 'payment_settings#validate', as: 'validate'
      end
      resource :team

      resources :bank_accounts do
        patch :make_primary
      end
      resources :notification_settings, as: :notifications, path: 'notifications', only: %i[index update]
    end

    resources :ported_businesses, only: %i[index new create]
    get '/ported_businesses/buy' => 'ported_businesses#buy'
    post '/ported_businesses/buy' => 'ported_businesses#subscribe'
    delete '/ported_businesses/:id', to: 'ported_businesses#delete', as: 'delete_ported_businesses'
    resources :invitations, only: %i[create destroy]
    resources :projects, path: 'my-projects'
    concerns :favoriteable
    resources :messages
    resources :financials do
      get :invoice, on: :member
    end
  end

  resources :specialists, only: %i[index new create show]
  get '/profile/:id', to: 'specialists#edit', as: 'employee_profile'
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
    post 'exams/:uuid' => 'exams#email'
    patch 'exams/:uuid' => 'exams#show'

    resources :skills, only: :index
    resources :users, only: [] do
      collection do
        post :sign_in, to: 'authentication#create'
        post :password, to: 'passwords#create'
        put :password, to: 'passwords#update'
      end
    end
    scope 'projects/:project_id' do
      # resources :project_messages, path: 'messages(/:specialist_username)'
      resources :project_ends, path: 'end', only: %i[create update]
      resources :project_extensions, path: 'extension', only: %i[create update]
      resources :project_issues, path: 'issues', only: %i[create]
      resources :documents, only: %i[index create destroy]
      resource :project_rating, path: 'rating', only: [:create]
      # resource :project_rating, path: 'rating'
      # resource :project_overview, path: 'overview(/:specialist_username)', only: :show
    end

    namespace :settings do
      get 'general' => 'general#index'
      patch 'general' => 'general#update'
      get 'profile' => 'profile#index'
      patch 'profile' => 'profile#update'
      patch 'password' => 'password#update'
      get 'notifications' => 'notifications#index'
      patch 'notifications' => 'notifications#update'
      delete 'profile' => 'profile#destroy'
    end

    get 'local_projects/:project_id/messages' => 'project_messages#index'
    post 'local_projects/:project_id/messages' => 'project_messages#create'
    resources :direct_messages, path: 'messages/:recipient_username', only: %i[index create]
    resources :project_ratings, only: %i[index]
    namespace :business do
      resources :exams, only: %i[index show create update destroy] do
        resources :exam_requests, path: 'requests', only: %i[create update destroy] do
          resources :exam_request_files, path: 'documents', only: %i[create destroy]
        end
        post :invite, on: :member
        post :uninvite, on: :member
      end
      resources :file_folders, only: %i[index create destroy update show] do
        get :download_folder, on: :member
        get :check_zip, on: :member
        get :list_tree, on: :member
      end
      resources :file_docs, only: %i[create update destroy]
      resource :compliance_policy_configuration, only: %i[show update]
      get '/reminders/:id' => 'reminders#show'
      delete '/reminders/:id' => 'reminders#destroy'
      post '/reminders/:id' => 'reminders#update'
      get '/reminders/:id/messages' => '/api/reminder_messages#index'
      post '/reminders/:id/messages' => '/api/reminder_messages#create'
      get '/reminders/:date_from/:date_to' => 'reminders#by_date'
      get '/overdue_reminders' => 'reminders#overdue'
      post '/reminders' => 'reminders#create'
      resources :local_projects, only: %i[index create show update destroy]
      put 'local_projects/:id/complete' => 'local_projects#complete'
      resources :projects, only: %i[index show create update destroy] do
        resources :project_messages, path: 'messages', only: %i[index create]
        resources :job_applications, path: 'applications', only: %i[index] do
          post :shortlist
          post :hide
        end
        resources :hires, only: %i[create]
      end
      resources :compliance_policies, only: %i[index show create update destroy]
      get '/compliance_policies/:id/publish' => 'compliance_policies#publish'
      get '/compliance_policies/:id/download' => 'compliance_policies#download'
      resources :risks, only: %i[index show create update destroy]
      resources :projects, only: [] do
        resources :timesheets, except: %i[new edit], controller: 'timesheets'
      end
      resources :specialist_roles, only: :update
      resources :specialists, only: :index
      post '/seats/:seat_id/assign', to: 'seats#assign'
      resources :annual_reports, only: %i[index show create update destroy]
      get '/annual_reports/:id/clone' => 'annual_reports#clone'
      scope 'annual_reports/:report_id' do
        resources :review_categories, path: 'review_categories', only: %i[index create update destroy]
      end
      resources :ratings, only: %i[index]
      post '/upgrade/subscribe' => 'upgrade#subscribe'
      resources :payment_settings, only: %i[create update destroy index]
      put '/payment_settings/make_primary/:id' => 'payment_settings#make_primary'
      get '/favorites' => 'favorites#index'
      patch '/favorites' => 'favorites#update'
    end
    namespace :specialist do
      get '/projects/my' => 'projects#my'
      resources :projects, only: %i[index show] do
        resources :project_messages, path: 'messages', only: %i[index create]
        resources :timesheets, except: %i[new edit], controller: 'timesheets'
        resources :job_applications, path: 'applications', only: %i[show update create destroy]
        get :local
        get :calendar_hide
        get :calendar_show
      end
      post '/upgrade/subscribe' => 'upgrade#subscribe'
      delete '/upgrade/cancel' => 'upgrade#cancel'
      post '/payment_settings/create_card' => 'payment_settings#create_card'
      post '/payment_settings/create_bank' => 'payment_settings#create_bank'
      delete '/payment_settings/delete_source/:id' => 'payment_settings#delete_source'
      put '/payment_settings/make_primary/:id' => 'payment_settings#make_primary'
      put '/payment_settings/validate/:id' => 'payment_settings#validate'
      get '/payment_settings' => 'payment_settings#index'
      get '/favorites' => 'favorites#index'
      patch '/favorites' => 'favorites#update'
      post '/share_project' => 'share_project#create'
    end
    resources :businesses, only: [:create]
    resource :business, only: %i[update] do
      patch '/' => 'businesses#update', as: :update
    end
    put 'users/:user_id/confirm_email', to: 'email_confirmation#update'
    get 'users/:user_id/resend_email', to: 'email_confirmation#resend'
    resources :specialists, only: :create
    resource :specialist, only: %i[update] do
      patch '/' => 'specialists#update', as: :update
    end
    resources :otp_secrets, only: [:create]
  end
end
