# frozen_string_literal: true

class AdminConstraint
  def matches?(request)
    return false unless request.session[:current_user_id]

    user = User.find(request.session[:current_user_id])
    user&.admin?
  end
end

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  mount Sidekiq::Web => '/admin/sidekiq', constraints: AdminConstraint.new
  mount PgHero::Engine => '/admin/pghero', constraints: AdminConstraint.new

  resource :test_login, only: %i[show create destroy] if Rails.env.test?

  use_doorkeeper do
    controllers authorizations: 'oauth_authorizations'

    skip_controllers :applications, :authorized_applications
  end

  namespace :api do
    get 'user' => 'me#show'

    root to: 'root#index'
  end

  namespace :admin do
    resources :alliances, only: %i[index show edit update]
    resources :corporations, only: %i[index show edit update]
    resources :esi_authorizations
    resources :markets
    resources :regions, only: %i[index show edit update]
    resources :reports, only: %i[index show]
    resources :structures, only: %i[index show edit update]
    resources :users

    root to: 'dashboards#show'
  end

  get 'auth' => 'sso#new'
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

  resources :procurement_orders, path: 'orders', only: %i[index new create show update destroy] do
    collection do
      get :history
      get :item
    end

    member do
      post :accept
      post :deliver
      post :undeliver
      post :receive
      post :redraft
      post :release
      get :list_items_card
    end
  end

  resource :search, only: :show

  get '/autocomplete/types', to: 'autocompletes#types'
  get '/autocomplete/market-types', to: 'autocompletes#market_types'

  resource :settings, only: %i[show update destroy] do
    resources :esi_authorizations, path: 'authorizations', only: %i[create index destroy]
    resources :personal_access_tokens, path: 'tokens', only: %i[index new create show destroy]
  end

  root to: 'home#index'
end
