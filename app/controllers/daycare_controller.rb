class DaycareController < ApplicationController
  before_action :set_defaults
  # before_action :cdn_cache

  def index
    if params['nearby']
      geom_point   = params[:nearby].split(",").map(&:to_f)
      max_distance = (params[:max_distance] || 100).to_i
      min_distance = (params[:min_distance] || 0).to_i

      daycares = Daycare.where(:location => {
        '$near' => geom_point,
        '$maxDistance' => max_distance.fdiv(69),
        '$minDistance' => min_distance.fdiv(69)
      })
    end

    daycares = @grade.present? ? Daycare.where(grade: @grade.downcase) : Daycare

    @daycares = (@query.present? ? daycares.full_text_search(@query, match: :all) : daycares).page(@page)
  end

  def show
  	@daycare = Daycare.find_by(permalink: params[:id])
  end

private

  def set_defaults
    @query = params[:q]
    @page = params[:page] || 1
    @grade = params[:grade]
    @grade_filter = @grade.present? ? @grade.upcase : 'All Grades'
  end
end
