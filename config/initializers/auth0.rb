Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    ENV['YOUR_CLIENT_ID'],
    ENV['YOUR_CLIENT_SECRET'],
    ENV['YOUR_NAMESPACE'],
    callback_path: "/auth/auth0/callback"
  )
end
