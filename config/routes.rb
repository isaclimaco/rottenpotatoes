Rails.application.routes.draw do
  resources :movies
  resources :movies do
    collection do
      post :search_tmdb
    end
  end
  get "movies/:id/same_director", to: "movies#same_director", as: :same_director_movie
  get "up" => "rails/health#show", as: :rails_health_check


end
