# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :esi_authorizations
    resources :users
  end

  match 'auth/eve/callback' => 'sso#create', via: %i[get post]
  post 'auth/logout' => 'sso#destroy', as: :log_out

  resource :dashboard, only: :show

  resource :settings, only: %i[show update destroy] do
    resources :esi_authorizations, path: 'authorizations', only: %i[create index destroy]
  end

  root to: 'home#index'
end
