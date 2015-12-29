Rails.application.routes.draw do

  apipie
  devise_for :users, ActiveAdmin::Devise.config
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :staffs, only: [:show, :update]
      resources :customers, only: [:show, :update]
      resources :blocked_users, only: [:index, :create, :show]
      delete 'un_blocked_user' => 'blocked_users#destroy'
      get 'eula/latest' => 'eulas#latest'
      get 'privacy/latest' => 'privacies#latest'
      resources :ratings, only: [:show, :create, :update]
      resources :reported_ratings, only: [:show, :create]
      resources :jobs
      resources :notifications, only: [:index, :destroy]
    end
  end
  ActiveAdmin.routes(self)
  root 'admin/dashboard#index'
  resources :users
end
