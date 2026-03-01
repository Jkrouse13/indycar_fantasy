Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
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