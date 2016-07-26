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
  end

  resources :projects do
    post :post, on: :member
    get :copy, on: :member
  end

  namespace :specialist do
    resource :settings, only: :show
  end

  resources :specialists
  get '/specialist' => 'specialist_dashboard#show', as: :specialist_dashboard

  namespace :api do
    resources :skills, only: :index
  end
end
