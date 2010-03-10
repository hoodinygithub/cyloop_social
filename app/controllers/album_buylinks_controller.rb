class AlbumBuylinksController < ApplicationController

  def show
    @album = Album.find( params[:id], :include => [:owner, :album_buylinks]  )
    @buylinks = @album.album_buylinks
    respond_to do |format|
      format.html
      format.xml
    end
  end

end