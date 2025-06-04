# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  root 'home#index'
  resources :links
  get 'up' => 'rails/health#show', as: :rails_health_check
end
