# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  if Rails.env.production? || Rails.env.staging?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == ENV.fetch('SIDEKIQ_USERNAME') && password == ENV.fetch('SIDEKIQ_PASSWORD')
    end
  end
  mount Sidekiq::Web => '/sidekiq'

  devise_for :admin_users, ActiveAdmin::Devise.config
  begin
    ActiveAdmin.routes(self)
  rescue ActiveRecord::StatementInvalid, PG::UndefinedTable => e
    Rails.logger.info "ActiveAdmin could not load: #{e.message}"
  end

  root to: 'landing_page#show'
  get 'r/:token' => 'referrals#show', as: :referrals

  # BUMP
  # get '/ask-a-specialist/search' => 'forum_questions#search', as: :forum_search
  # resources :forum_questions, path: 'ask-a-specialist', param: :url
  # resources :forum_answers, only: :create
  # get '/ask-a-specialist/upvote/:id' => 'forum_votes#upvote'
  # get '/ask-a-specialist/downvote/:id' => 'forum_votes#downvote'
  # get '/forum_subscriptions/create' => 'forum_subscriptions#create'
  # get '/forum_subscriptions/upgrade' => 'forum_subscriptions#upgrade'
  # get '/forum_subscriptions/cancel' => 'forum_subscriptions#cancel'

  concern :favoriteable do
    resources :favorites, only: [] do
      post :toggle, on: :collection
    end
  end

  # resources :flags, only: %i[new create]

  namespace :stripe do
    resources :webhooks, only: :create
  end

  devise_for :users, only: []

  namespace :api do
    get 'static_collection' => 'static_collection#index'
    post 'exams/:uuid' => 'exams#email'
    patch 'exams/:uuid' => 'exams#show'

    resources :skills, only: :index
    resources :users, only: [] do
      collection do
        post :sign_in, to: 'authentication#create'
        delete :sign_out, to: 'authentication#destroy'
        post :password, to: 'passwords#create'
        put :password, to: 'passwords#update'
      end
    end

    resources :payment_settings, only: [] do
      collection do
        post :apply_coupon
      end
    end

    scope 'projects/:project_id' do
      # resources :project_messages, path: 'messages(/:specialist_username)'
      resources :documents, only: %i[index create destroy], controller: 'project_documents'
      resources :project_ends, path: 'end', only: %i[create update]
      resources :project_extensions, path: 'extension', only: %i[create update]
      resources :project_issues, path: 'issues', only: %i[create]
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

      post 'email' => 'email#create'
      patch 'email' => 'email#update'

      post 'verify_change_email' => 'email#verify_change_email'
      post 'update_login_email'  => 'email#update_login_email'
    end

    get 'local_projects/:project_id/messages' => 'project_messages#index'
    post 'local_projects/:project_id/messages' => 'project_messages#create'
    post 'local_projects/:project_id/specialists' => 'local_projects#add_specialist'
    delete 'local_projects/:project_id/specialists/:specialist_id' => 'local_projects#remove_specialist'
    resources :direct_messages, path: 'messages/:recipient_id', only: %i[index create]
    get 'messages' => 'direct_messages#show'
    resources :project_ratings, only: %i[index]
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
      resources :projects, only: %i[index show create update destroy] do
        resources :project_messages, path: 'messages', only: %i[index create]
        resources :job_applications, path: 'applications', only: %i[index] do
          post :shortlist
          post :hide
        end
        resources :hires, only: %i[create]
      end
      get '/compliance_policies/download' => 'compliance_policies#download_all'
      get '/compliance_policies/combined_policy' => 'compliance_policies#combined_policy'
      resources :compliance_policies, only: %i[index show create update destroy]
      get '/compliance_policies/:id/publish' => 'compliance_policies#publish'
      get '/compliance_policies/:id/download' => 'compliance_policies#download'
      post '/compliance_policies/update_position' => 'compliance_policies#update_position'
      resources :risks, only: %i[index show create update destroy]
      resources :projects, only: [] do
        resources :timesheets, except: %i[new edit], controller: 'timesheets'
      end
      resources :specialist_roles, only: :update
      resources :specialists, only: :index
      resources :annual_reports, only: %i[index show create update destroy] do
        resources :documents, only: %i[index create destroy], controller: 'annual_report_documents'
      end
      get '/annual_reports/:id/clone' => 'annual_reports#clone'
      get '/annual_reports/:id/download' => 'annual_reports#download'
      scope 'annual_reports/:report_id' do
        resources :review_categories, path: 'review_categories', only: %i[index create update destroy]
      end
      resources :ratings, only: %i[index]
      post '/upgrade/subscribe' => 'upgrade#subscribe'
      resources :payment_settings, only: %i[create update destroy index]
      put '/payment_settings/make_primary/:id' => 'payment_settings#make_primary'
      get '/favorites' => 'favorites#index'
      patch '/favorites' => 'favorites#update'

      get '/financials/processed' => 'financials#processed'
      get '/financials/payments' => 'financials#payments'
      get '/financials/budget' => 'financials#get_budget_data'
      patch '/financials/annual_budget' => 'financials#set_annual_budget'

      resources :team_members, only: %i[index create update destroy] do
        collection do
          get :specialists
        end

        member do
          patch :archive
          patch :unarchive
        end
      end

      resources :seats, only: [] do
        collection do
          get :available_seat_count
        end
      end
    end

    namespace :specialist do
      get '/projects/my' => 'projects#my'
      resources :projects, only: %i[index show] do
        resources :project_messages, path: 'messages', only: %i[index create]
        resources :timesheets, except: %i[new edit], controller: 'timesheets'
        get '/applications/my' => 'job_applications#my'
        resources :job_applications, path: 'applications', only: %i[show update create destroy]
        get :local
        get :calendar_hide
        get :calendar_show
      end

      resources :payment_settings, only: %i[index destroy]
      put '/payment_settings/validate/:id' => 'payment_settings#validate'
      post '/payment_settings/create_card' => 'payment_settings#create_card'
      post '/payment_settings/create_bank' => 'payment_settings#create_bank'
      put '/payment_settings/make_primary/:id' => 'payment_settings#make_primary'

      post '/upgrade/subscribe' => 'upgrade#subscribe'
      delete '/upgrade/cancel' => 'upgrade#cancel'
      get '/favorites' => 'favorites#index'
      patch '/favorites' => 'favorites#update'
      post '/share_project' => 'share_project#create'
      resources :roles, only: ['index']

      get '/financials/processed' => 'financials#processed'
      get '/financials/payments' => 'financials#payments'
      get '/financials/revenue' => 'financials#get_revenue_data'
      patch '/financials/annual_revenue' => 'financials#set_annual_revenue'

      resources :billings, only: %i[index create update]
      resources :bank_accounts, only: %i[create]
      resources :work_experiences, only: %i[create update destroy index]
    end

    resources :businesses, only: [:create] do
      collection do
        patch :auto_populate
      end
    end

    resources :specialists, only: [:create] do
      collection do
        get :current
      end
    end

    get '/businesses/current' => 'businesses#current'
    resource :business, only: %i[update] do
      patch '/' => 'businesses#update', as: :update
    end
    put 'users/confirm_email', to: 'email_confirmation#update'
    get 'users/resend_email', to: 'email_confirmation#resend'
    resource :specialist, only: %i[update] do
      patch '/' => 'specialists#update', as: :update
    end
    resources :otp_secrets, only: [:create]
  end
end
