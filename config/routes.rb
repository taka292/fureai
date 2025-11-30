Rails.application.routes.draw do
  get "messages/new"
  get "messages/create"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # チャット機能
  resources :chats do
    resources :messages, only: %i[new create]
    resources :ai_messages, only: [ :create ]
    member do
      post :clear_messages
      get :edit_background
      patch :update_background
      get :delete_background_images
      delete :destroy_selected_background_images
    end
  end

  # AIキャラクター設定
  resources :ai_characters, only: %i[edit update]

  resource :profile, only: [ :edit, :update ], controller: "profiles"

  resources :mental_conditions
  resources :diaries

    namespace :api do
      post "ai_response", to: "ai_responses#create"
    end
  end
