class AlbumsController < ApplicationController
  before_filter :set_origin
  before_filter :load_page, :only => :show
  current_tab :music

  def index
    @sort_type = params.fetch(:sort_by, nil).to_sym rescue :latest
    sort_types = { :latest => 'year DESC', :alphabetical => 'albums.name'  }
    @collection = profile_artist.artist_albums.paginate :page => params[:page], :per_page => 5, :order => sort_types[@sort_type]
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
