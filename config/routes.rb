Rails.application.routes.draw do
  resources :movies
  resources :movies do
    collection do
      post :search_tmdb
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check


end
