class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private

  def set_defaults
    @query  = params[:q]
    @nearby = params[:nearby]
    @bbox   = params[:bbox]
    @page   = params[:page] || 1
    @per_page = params[:per_page] || 25
    @grade  = params[:grade]
    @grade_filter = @grade.present? ? @grade.upcase : 'All Grades'
  end

  def cdn_cache
    disable_session
    expires_in 1.day, public: true
  end

  def disable_session
    request.session_options[:skip] = true
  end
end
