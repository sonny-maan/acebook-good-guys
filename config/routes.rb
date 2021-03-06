# frozen_string_literal: true

# This is your application's routing file which holds entries in a special DSL
# (domain-specific language) that tells Rails how to connect incoming requests to controllers and actions.

Rails.application.routes.draw do
  resources :comments
  resources :passwords, controller: 'clearance/passwords', only: %i[create new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  constraints Clearance::Constraints::SignedIn.new do
    root to: 'posts#index'
  end
  constraints Clearance::Constraints::SignedOut.new do
    root to: 'welcome#index'
  end
  resources :users, only: [:create] do
    resource :password,
             controller: 'clearance/passwords',
             only: %i[create edit update]
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'clearance/users#new', as: 'sign_up'

  resources :users,
            path_names: { show: 'wall' }

  resources :posts do
    resources :comments, except: :show
  end
  resources :albums do
    member do
      delete :delete_image_attachment
    end
  end
end
