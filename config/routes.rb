Rails.application.routes.draw do
  root "links#index"
  resource :session
  resources :passwords, param: :token
  resources :links
  get "up" => "rails/health#show", as: :rails_health_check
end
