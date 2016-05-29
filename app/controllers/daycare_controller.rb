class DaycareController < ApplicationController
  before_action :set_defaults
  before_action :cdn_cache
  respond_to :html, :json

  def index
    if @nearby.present?
      geom_point   = @nearby.split(",").map(&:to_f)
      max_distance = (params[:max_distance] || 100).to_i
      min_distance = (params[:min_distance] || 0).to_i

      daycares = Daycare.where(:location => {
        '$near' => geom_point,
        '$maxDistance' => max_distance.fdiv(69),
        '$minDistance' => min_distance.fdiv(69)
      })
    end

    daycares = daycares || Daycare
    daycares = @grade.present? ? daycares.where(grade: @grade.downcase) : daycares

    @daycares = (@query.present? ? daycares.full_text_search(@query, match: :all) : daycares).page(@page)

    respond_with(@daycares)
  end

  def show
    @daycare = Daycare.find_by(permalink: params[:id])

    respond_with(@daycare)
  end

  def map
    @daycares= Daycare.all
  end
end
