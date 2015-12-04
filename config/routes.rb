Rails.application.routes.draw do

  devise_for :users
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
  end
  
  ActiveAdmin.routes(self)
  root to: 'visitors#index'
  resources :users
end
