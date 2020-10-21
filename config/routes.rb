Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get 'about', to: 'pages#about', as: :about
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :charges, only: [ :new, :create ]
  resources :trips, only: [ :create, :show, :index, :update, :destroy ]
  resources :countries, only: [ :show, :index ] do
    collection do
      get :result
    end
  end

  # for sidekiq
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
