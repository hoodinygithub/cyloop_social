class Discover::SongsController < ApplicationController
  layout 'discover'  
  
  def index
    #@songs = Song.all
  end
  
  def show
    @genre = params[:id]
  end
end
