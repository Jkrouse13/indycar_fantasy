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
      resources :pool_entries
      resources :race_tiers
      get "leaderboard/race/:race_id", to: "leaderboard#race"
      get "leaderboard/season/:season_year", to: "leaderboard#season"
      post "import_results/parse",   to: "import_results#parse"
      post "import_results/confirm", to: "import_results#confirm"
      get  "races/:race_id/car_liveries", to: "car_liveries#index"
      post "car_liveries/parse",   to: "car_liveries#parse"
      post "car_liveries/confirm", to: "car_liveries#confirm"
    end
  end
end
