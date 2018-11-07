Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  # mount Sidekiq::Web => '/sidekiq'

  authenticate :user, lambda { |u| u.administrator? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  apipie
  # devise_for :users, ActiveAdmin::Devise.config
  devise_for :users, {
      path: ActiveAdmin.application.default_namespace || "/",
      controllers: {
          passwords: "active_admin/devise/passwords",
          confirmations: 'active_admin/devise/confirmations',
          sessions: "active_admin/devise/sessions"
      },
      path_names: {sign_in: 'login', sign_out: "logout"},
      sign_out_via: [*::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].uniq
  }
  devise_for :project_managers , {
      path: :pm,
      controllers: {
          passwords: "active_admin/devise/passwords",
          confirmations: 'active_admin/devise/confirmations',
          sessions: "active_admin/devise/sessions"
      },
      path_names: { sign_in: 'login', sign_out: "logout"},
      sign_out_via: [*::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].uniq
  }
  namespace :api, defaults: {format: 'json'} do
     namespace :v1 do
       mount_devise_token_auth_for 'User', at: 'auth', :controllers => {  sessions: "api/v1/users/sessions"}
       mount_devise_token_auth_for 'LandManager', at: 'auth', :controllers => { registrations: "api/v1/users/registrations"}
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
       resources :feedbacks, only: [:show, :create]
       resources :reported_ratings, only: [:show, :create]
       resources :reported_chats, only: [:show, :create]
       resources :jobs
       resources :notifications, only: [:index, :destroy]
       delete 'notifications' => 'notifications#destroy_all'
       resources :tutorials
       resources :pages do
         collection do
           get :about
         end
       end
       resources :documents
       resources :categories
       resources :sub_categories, only: [:index]
       resources :submissions, only: [:create, :show]
       resources :projects, only: [:index, :species, :leave] do
         get :species
         collection do
           post :leave
           post :join
         end
       end
     end
   end
  ActiveAdmin.routes(self)
  devise_scope :user do
    get '/land_manager/confirmation', to: 'users/confirmations#show', as: :land_manager_confirmation
    get '/land_manager_confirmed', to: 'users#land_manager_confirmed', as: :land_manager_confirmed
  end

  scope :pm, :controller => 'invitations'  do
    get 'accept_invitation', as: :pm_accept_invitation
    get 'reject_invitation', as: :pm_reject_invitation
    post 'accept', as: :pm_accept
  end


  root 'admin/dashboard#index'
  resources :users
  match '*unmatched', to: 'application#route_not_found', via: :all
end
