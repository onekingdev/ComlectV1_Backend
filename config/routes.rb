# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root to: 'home#index'

  resources :businesses, only: %i(index new create show)
  resource :business, only: %i(edit) do
    patch '/' => 'businesses#update', as: :update
  end
  get '/business' => 'business_dashboard#show', as: :business_dashboard

  namespace :business do
    resource :settings, only: :show do
      resources :payment_settings, as: :payment, path: 'payment', except: %i(show) do
        patch :make_primary
      end
    end
    resources :specialists, only: :index
    resources :favorites, only: [] do
      post :toggle, on: :collection
    end

    resources :projects do
      post :post, on: :member
      get :copy, on: :member
    end
  end

  namespace :specialists, path: 'specialist' do
    get '/' => 'dashboard#show', as: :dashboard
    resource :settings, only: :show
    resources :projects, path: 'my-projects'
  end

  resources :specialists, only: %i(index new create show)
  resource :specialist, only: %i(edit) do
    patch '/' => 'specialists#update', as: :update
  end

  resources :project_invites, path: 'invite'

  namespace :api do
    resources :skills, only: :index
  end
end
