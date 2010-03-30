class AlbumsController < ApplicationController
  before_filter :set_origin
  before_filter :load_page, :only => :show
  current_tab :music

  def index
    @all_albums = profile_artist.artist_albums
    @albums = paginate( @all_albums )
  end

  def show
    # This stops /my/album routes until we have Artist private
    render( :nothing => true) && return if params[:slug].blank?

    @album = profile_artist.artist_albums.find( params[:id] )
    if !params[:song_id].blank? && params[:page].blank?
      @page = (songs.map(&:id).index(params[:song_id].to_i) / 15) + 1 rescue 1
    end
    
    @songs = paginate(@album.songs, :include => :genres)
  end
end