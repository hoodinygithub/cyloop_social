class Charts::SongsController < ApplicationController
  layout "profile"
  caches_action :index, :expires_delta => EXPIRATION_TIMES['artist_charts_song_action'], :layout => false,
                        :cache_path => Proc.new{|c| "#{CURRENT_SITE.cache_key}/#{c.params[:slug]}/#{c.params[:controller]}"},
                        :if => :is_artist?

  current_tab :charts
  current_filter :songs

  def index
    begin
      @songs = profile_account.most_listened_songs.paginate(:page => params[:page], :per_page => 10) unless is_cached?
    rescue ActiveRecord::RecordNotFound
      redirect_to profile_not_found_path(params[:slug])
    rescue NoMethodError
      redirect_to new_session_path
    rescue ArgumentError
      redirect_to profile_not_found_path(params[:slug])
    end
  end

private

  def has_slug?
    params.has_key?(:slug) && !params[:slug].nil?
  end
  
  def is_artist?
    profile_account.is_a? Artist
  end

  def is_cached?
    has_slug? && is_artist? && Rails.cache.exist?("#{CURRENT_SITE.cache_key}/#{params[:slug]}/#{params[:controller]}")
  end
end

