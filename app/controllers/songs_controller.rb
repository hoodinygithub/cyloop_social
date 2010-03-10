class SongsController < ApplicationController
  def show
    @song = profile_artist.songs.find(params[:id])
    respond_to do |format|
      format.html { render :text => @song.title, :layout => true }
      format.xml  { render :layout => false }
    end
  end

  def queue
    @song = profile_artist.songs.find(params[:id])
    RawSongPlay.create!(:song => @song, :site => current_site, :listener => current_account, :duration => 120) # TODO: A lot
    flash[:success] = t('songs.play_confirmation', :title => @song.title)
    redirect_to [profile_artist, @song]
  end
end
