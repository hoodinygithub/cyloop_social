class Discover::StationsController < ApplicationController

  def index
    #@stations = UserStation.all
  end
  
  def show
    @genre = params[:id]
  end
end
