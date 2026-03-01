Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :races do
        resources :race_tiers, shallow: true
        resources :race_results, shallow: true
      end
      resources :drivers
      resources :teams
      resources :picks
      resources :participants
    end
  end
end