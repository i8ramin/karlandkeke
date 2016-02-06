Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # get "/auth/auth0/callback" => "auth0#callback"
  # get "/auth/failure" => "auth0#failure"

  resources :daycare, only: [:show, :grade] do
    collection do
      get "/", to: "daycare#index"
      get "grade/:grade", to: "daycare#index"
    end
  end

  get "/map" => "daycare#map"

  root :to => "home#index"
end
