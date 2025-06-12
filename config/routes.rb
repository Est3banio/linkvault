# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations], controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    resource :registration,
             only: [:show, :edit, :update, :destroy],
             path: 'users',
             path_names: { edit: 'edit' },
             controller: 'users/registrations',
             as: :user_registration do
      get :cancel
    end
  end

  root 'home#index'
  get 'dashboard', to: 'home#dashboard'
  resources :links do
    collection do
      get :import
      post :import_preview
      post :import_confirm
    end
  end

  namespace :admin do
    resources :users
    root 'users#index'
  end
  
  # PWA manifest and service worker
  get '/manifest' => 'pwa#manifest', as: :pwa_manifest
  get '/service-worker' => 'pwa#service_worker', as: :pwa_service_worker
  
  get 'up' => 'rails/health#show', as: :rails_health_check
end
