Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  root to: 'visitors#index'
  devise_for :users
  resources :users

end
