Rails.application.routes.draw do
  root "links#index"
  resource :session
  resources :passwords, param: :token
  resources :links
  get "up" => "rails/health#show", as: :rails_health_check
  
  # User sign up
  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"
end
