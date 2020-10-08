Rails.application.routes.draw do
  get 'notifications/index'
  get 'notifications/destroy'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :charges, only: [ :new, :create ]
  resources :trips, only: [ :create, :show, :index, :update, :destroy ] do
    member do
      # Use the get_notified method as a post method
      patch :get_notified
      patch :disable_notifications

    end
  end

  resources :countries, only: [ :show, :index ] do
    collection do
      get :result
    end
  end
  resources :notifications, only: [ :index ]

  # for sidekiq
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
