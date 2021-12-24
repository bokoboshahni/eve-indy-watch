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
    resources :markets
    resources :regions, only: %i[index show edit update]
    resources :structures, only: %i[index show edit update]
    resources :users

    root to: 'dashboards#show'
  end

  match 'auth/eve/callback' => 'sso#create', via: %i[get post]
  post 'auth/logout' => 'sso#destroy', as: :log_out

  resource :dashboard, only: :show

  resources :contracts, only: %i[index show] do
    member do
      get :list_fittings_card
    end
  end

  resources :fittings do
    member do
      get :inventory_chart_data
      get :stock_levels
    end
  end

  resources :types do
    member do
      get :intraday_prices
    end
  end

  resource :search, only: :show

  resource :settings, only: %i[show update destroy] do
    resources :esi_authorizations, path: 'authorizations', only: %i[create index destroy]
  end

  root to: 'home#index'
end
