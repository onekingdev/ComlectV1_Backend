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
end
