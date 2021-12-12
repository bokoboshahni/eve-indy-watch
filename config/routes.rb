# frozen_string_literal: true

class AdminConstraint
  def matches?(request)
    return false unless request.session[:current_user_id]

    user = User.find(request.session[:current_user_id])
    user&.admin?
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/admin/sidekiq', constraints: AdminConstraint.new
  mount PgHero::Engine => '/admin/pghero', constraints: AdminConstraint.new

  namespace :admin do
    resources :alliances, only: %i[index show edit update]
    resources :corporations, only: %i[index show edit update]
    resources :esi_authorizations
    resources :regions, only: %i[index show edit update]
    resources :structures, only: %i[index show edit update]
    resources :users
  end

  match 'auth/eve/callback' => 'sso#create', via: %i[get post]
  post 'auth/logout' => 'sso#destroy', as: :log_out

  resource :dashboard, only: :show
  resources :contracts, only: %i[index show]
  resources :fittings

  resource :settings, only: %i[show update destroy] do
    resources :esi_authorizations, path: 'authorizations', only: %i[create index destroy]
  end

  root to: 'home#index'
end
