Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :daycare, only: [:show, :grade] do
    collection do
      get "grade/:grade", to: "daycare#index"
    end
  end

  get "/map" => "daycare#map"
  # get "/auth/auth0/callback" => "auth0#callback"
  # get "/auth/failure" => "auth0#failure"

  root :to => "home#index"
end
