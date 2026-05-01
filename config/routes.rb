Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  namespace :api do
    namespace :v1 do
      resources :qualifying_predictions, only: [:index, :show, :create, :update]
      resources :qualifying_results, only: [:show, :update], param: :year
      resources :races do
        resources :race_tiers, shallow: true
        resources :race_results, shallow: true
      end
      resources :drivers
      resources :teams
      resources :picks
      resources :participants
      resources :race_tiers
      get "leaderboard/race/:race_id", to: "leaderboard#race"
      get "leaderboard/season/:season_year", to: "leaderboard#season"
    end
  end
end
