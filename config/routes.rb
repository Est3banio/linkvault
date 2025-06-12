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
  
  # PWA manifest and service worker
  get '/manifest' => 'pwa#manifest', as: :pwa_manifest
  get '/service-worker' => 'pwa#service_worker', as: :pwa_service_worker
  
  get 'up' => 'rails/health#show', as: :rails_health_check
end
