class HomeController < ApplicationController
  def show
  	@daycares = Daycare.limit(10).to_a
  end
end
