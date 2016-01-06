class DaycareController < ApplicationController
  before_action :set_selected_grade_filter
  before_action :cdn_cache

  def index
    query = params[:q]
    @daycares = query.present? ? Daycare.fulltext_search(query) : Daycare.page(params[:page])
  end

  def show
  	@daycare = Daycare.find_by(permalink: params[:id])
  end

  def grade
  	@daycares = Daycare.where(grade: params[:grade].downcase).page(params[:page])
  end

private

  def set_selected_grade_filter
    @grade_filter = (params[:grade] || '').upcase || 'All'
  end
end
