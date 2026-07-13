Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords"
  }

  devise_scope :user do
    get "password_sent", to: "users/passwords#sent"
    get "password_changed", to: "users/passwords#changed"
  end

  get "welcome", to: "welcome#index"

  root "guides#show"
  post "complete_guide", to: "guides#complete"

  get "dashboard", to: "home#index"

resources :decisions do
  collection do
    get :timeline
  end

  resources :options, only: [:create]
end

resources :categories do
  collection do
    get :search
  end
end



  get "up" => "rails/health#show", as: :rails_health_check


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # Defines the root path route ("/")
  # root "posts#index"
end
