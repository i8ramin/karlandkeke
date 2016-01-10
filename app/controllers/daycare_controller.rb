class DaycareController < ApplicationController
  before_action :set_defaults
  before_action :cdn_cache

  def index
    if @grade
      daycares = Daycare.where(grade: @grade.downcase)
    else
      daycares = Daycare
    end

    if params['nearby']
      lat, lon = params['nearby'].split(',')
      daycares.nearby([lon, lat])
    end

    @daycares = @query.present? ? Daycare.fulltext_search(@query) : daycares.page(@page)
  end

  def show
  	@daycare = Daycare.find_by(permalink: params[:id])
  end

private

  def set_defaults
    @query = params[:q]
    @page = params[:page]
    @grade = params[:grade]
    @grade_filter = @grade.present? ? @grade.upcase : 'All Grades'
  end
end
