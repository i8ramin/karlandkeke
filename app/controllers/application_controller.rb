class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private

  def cdn_cache
    disable_session
    expires_in 1.week, public: true
  end

  def disable_session
    request.session_options[:skip] = true
  end
end
