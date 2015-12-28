class HomeController < ApplicationController
  def show
  	@daycares = Daycare.limit(50).to_a
  end
end
