class DashboardController < SecuredController
  def show
    @user = Hashie::Mash.new session[:userinfo]
  end
end
