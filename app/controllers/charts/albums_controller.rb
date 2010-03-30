class Charts::AlbumsController < ApplicationController
  caches_action :index, :expires_delta => EXPIRATION_TIMES['artist_charts_song_action'], 
                        :cache_path => Proc.new{|c| "#{CURRENT_SITE.cache_key}/#{c.params[:slug]}/#{c.params[:controller]}"}, 
                        :if => :is_artist?,
                        :layout => false

  
  current_tab :charts
  current_filter :albums
  
  def index
    begin
      @albums = profile_artist.most_listened_albums.paginate :page => params[:page], :per_page => 10
    rescue ActiveRecord::RecordNotFound
      redirect_to profile_not_found_path(params[:slug])
    end
  end
  
private
  def is_artist?
    profile_account.is_a?(Artist)
  end
  
end
