Rails.application.routes.draw do

  devise_for :users
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :staffs, only: [:show, :update]
      resources :customers, only: [:show, :update]
      resources :blocked_users, only: [:index, :create, :show]
      delete 'un_blocked_user' => 'blocked_users#destroy'
      get 'eula/latest' => 'eulas#latest'
      get 'privacy/latest' => 'privacies#latest'
      resources :ratings, only: [:show, :create]
    end
  end
  
  ActiveAdmin.routes(self)
  root to: 'visitors#index'
  resources :users
end
