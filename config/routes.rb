Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  apipie
  # devise_for :users, ActiveAdmin::Devise.config
  devise_for :users, {
      path: ActiveAdmin.application.default_namespace || "/",
      controllers: {
          sessions: "users/sessions"
      },
      path_names: {sign_in: 'login', sign_out: "logout"},
      sign_out_via: [*::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].uniq
  }
  namespace :api, defaults: {format: 'json'} do
     namespace :v1 do
       mount_devise_token_auth_for 'User', at: 'auth', :controllers => { :registrations => "api/v1/users/registrations",
                                                                         sessions: "api/v1/users/sessions"}
       resources :conversations, only: [:index, :create, :destroy] do
         resources :messages, only: [:index, :create, :update, :destroy]
         get :participants
         put :add_participants
       end
       resources :land_managers, only: [:show, :update, :index]
       resources :project_managers, only: [:show, :update]
       resources :blocked_users, only: [:index, :create, :show]
       delete 'un_blocked_user' => 'blocked_users#destroy'
       get 'eula/latest' => 'eulas#latest'
       get 'privacy/latest' => 'privacies#latest'
       resources :ratings, only: [:show, :create, :update]
       resources :reported_ratings, only: [:show, :create]
       resources :reported_chats, only: [:show, :create]
       resources :jobs
       resources :notifications, only: [:index, :destroy]
     end
   end
  ActiveAdmin.routes(self)   
  root 'admin/dashboard#index'
  resources :users
end
