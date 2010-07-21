class SongBuylinksController < ApplicationController

  def show
    @song = Song.find(params[:id]) rescue nil
    @buylinks = @song.nil? ? [] : @song.buylinks_by_site(current_site)
    respond_to do |format|
      format.html
      format.xml { render :layout => false }
    end
  end

end

