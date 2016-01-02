Rails.application.routes.draw do
  get "/" => "daycare#index"
  get "/daycare/:id" => "daycare#show"

  # get "/auth/auth0/callback" => "auth0#callback"
  # get "/auth/failure" => "auth0#failure"
end
