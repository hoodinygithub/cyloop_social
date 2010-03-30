class Discover::SongsController < ApplicationController
  
  def index
    #@songs = Song.all
  end
  
  def show
    @genre = params[:id]
  end
end
