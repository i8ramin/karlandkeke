class DaycareController < ApplicationController
  def index
  	@daycares = Daycare.limit(50).to_a
  end

  def show
  	@daycare = Daycare.find_by(permalink: params[:id])
  end
end
