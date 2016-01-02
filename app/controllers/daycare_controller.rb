class DaycareController < ApplicationController
  def index
  	@daycares = Daycare.page(params[:page])
  end

  def show
  	@daycare = Daycare.find_by(permalink: params[:id])
  end
end
