Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :charges, only: [ :new, :create ]
  resources :trips, only: [ :create, :show, :index, :destroy ]
  resources :countries, only: [ :show, :index ] do
    collection do
      get :result
    end
  end
end
