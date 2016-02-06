class HomeController < ApplicationController
  before_action :set_defaults
  before_action :cdn_cache

  def index
  end
end
