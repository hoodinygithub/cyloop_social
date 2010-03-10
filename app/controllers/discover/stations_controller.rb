class Discover::StationsController < ApplicationController
  layout 'discover'  
  
  def index
    #@stations = UserStation.all
  end
  
  def show
    @genre = params[:id]
  end
end
