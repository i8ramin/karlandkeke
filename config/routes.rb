Rails.application.routes.draw do
  resources :daycare, only: [:show, :grade] do
    collection do
      get "grade/:grade", to: "daycare#grade"
    end
  end

  # get "/daycare/:id" => "daycare#show"
  # get "/grade/:grade" => "daycare#grade"

  # get "/auth/auth0/callback" => "auth0#callback"
  # get "/auth/failure" => "auth0#failure"

  root :to => "daycare#index"
end
