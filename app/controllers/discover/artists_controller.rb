class Discover::ArtistsController < ApplicationController

  def index
    if request.xhr?
      @recommended_artists = rec_engine.get_recommended_artists(:number_of_records => 6)
      render :partial => 'recommended_artists', :object => @recommended_artists
    else
      #@artists = Artist.all
    end
  end
  
  def show
    @genre = params[:id]
  end
end
