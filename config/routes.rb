# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  root 'home#index'
  get 'dashboard', to: 'home#dashboard'
  resources :links

  namespace :admin do
    resources :users
    root 'users#index'
  end
  get 'up' => 'rails/health#show', as: :rails_health_check
end
