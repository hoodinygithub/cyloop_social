class RadioController < ApplicationController
  protect_from_forgery :except => [:search, :artist_info]
  #Explicitly removing caching on radio per Demian - 2009-09-29
  #caches_action :show, :expires_in => EXPIRATION_TIMES['radio_show'], :cache_path => :radio_show_cache_key

  def index
    @top_stations = current_site.top_abstract_stations.limited_to(5)
    @source_ip = remote_ip
    if params[:station_id]
      @station_obj = Station.find(params[:station_id])
      @station_json = if @station_obj.playable.is_a? AbstractStation      
        "{type:'99',station_url:'#{RecEngine::BASE_URI}?request=getRecEnginePlayList&artistID=#{@station_obj.playable.amg_id}&ipAddress=#{@source_ip}',idpl:'#{@station_obj.id}',nom:'#{@station_obj.playable.name}'};"
      elsif @station_obj.playable.is_a? UserStation      
        "{type:'99',station_url:'#{RecEngine::BASE_URI}?request=getRecEnginePlayList&artistID=#{@station_obj.playable.amg_id}&ipAddress=#{@source_ip}',idpl:'#{@station_obj.id}',nom:'#{@station_obj.playable.name}',userID:#{@station_obj.playable.owner_id}};"
      end        
    elsif params[:artist_name]
      @station_obj = AbstractStation.find_by_name(params[:artist_name])
    end
    
    @station_obj.playable.track_a_play if @station_obj and @station_obj.playable
    
    if site_includes(:msnlatam, :msnmx)
      render :template => 'radio/custom'
    end
  end

  def twitstation
    @top_stations = current_site.summary_top_stations.limited_to(5)
    begin
      if params[:station_id]
        @station_obj = Station.find(params[:station_id])
      elsif params[:artist_name]
        @station_obj = AbstractStation.find_by_name(params[:artist_name])
      end
      render :layout => "twitstation"
    rescue
      respond_to do |format|
        format.html { redirect_to profile_not_found_path(params[:artist_name]) }
        format.xml  { render :xml => {:message => "Profile Not Found"} }
      end
    end
  end
  
  def show
    @station = Station.find(params[:station_id]).playable
    @songs = if @station.kind_of? AbstractStation
      rec_engine.get_rec_engine_play_list(:artist_id => @station.amg_id)
    elsif @station.kind_of? UserStation
      rec_engine.get_rec_engine_play_list(:artist_id => @station.amg_id)
    elsif @station.kind_of? EditorialStation
      if @station.sites_available.include? current_site.id
        @station.playlist
      else
        render :xml => { :alert => 'This station cannot play in this market' }.to_xml(:root => 'response')
      end
    end
    respond_to do |format|
      format.html { render :layout => false }
      format.xml { render :layout => false }
    end
    #end
  end

  def play
    @station = Station.find( params[:station_id] ).playable
    if @station
      respond_to do |format|
        format.html do
          redirect_to radio_path(:station_id => @station.station.id, :queue => true)
        end
        block = Proc.new do
          session[:current_station] = @station.id
          render :xml => Player::Station.from(@station, 
                 :ip => remote_ip, 
                 :user_id => @station.kind_of?(UserStation) ? @station.owner_id : nil).to_xml(:root => @station.kind_of?(UserStation) ? 'user_station' : 'station')
        end
        format.xml(&block)
        format.js(&block)
        format.rss
      end

    else

      not_found_message = t('stations.could_not_find_artist', :artist => params[:id])
      respond_to do |format|
        format.html do
          flash[:error] = not_found_message
          redirect_to radio_path
        end
        format.js { render :text => not_found_message, :layout => false }
        format.xml { render :xml => Player::Error.new(:error => not_found_message, :code => 404) }
        format.rss do
          feed_site = site_code.match(/^msnca.*/) ? "msncanada" : site_code 
          redirect_to "http://cm.cyloop.com/feeds/#{feed_site}/feed_top_stations_#{site_code}.xml" 
        end
      end

    end

  end

  def search
    @station = Station.available.first( :conditions => {:name => params[:station_name]} )
    if @station
      @station_object = if logged_in?
        user_station = current_user.stations.find_by_station_id(@station.id)
        unless user_station
          user_station = current_user.create_user_station(:station_id => @station.id, :current_site => current_site)
          record_station_activity(@station)
        end
        user_station
      else
        @station
      end

      respond_to do |format|
        format.html do
          redirect_to(radio_path(:station_id => @station.id, :queue => true))
        end
        block = Proc.new do
          session[:current_station] = @station_object.id
          render :xml => Player::Station.from(@station_object, 
           :ip => remote_ip, 
           :user_id => logged_in? ? current_user.id : nil).to_xml(:root => @station_object.kind_of?(UserStation) ? 'user_station' : 'station')
        end
        format.xml(&block)
        format.js(&block)
        format.rss
      end

    else

      not_found_message = t('stations.could_not_find_artist', :artist => params[:station_name])
      respond_to do |format|
        format.html do
          flash[:error] = not_found_message
          redirect_to radio_path
        end
        format.js { render :text => not_found_message, :layout => false }
        format.xml { render :xml => Player::Error.new(:error => not_found_message, :code => 404) }
        format.rss do
          feed_site = site_code.match(/^msnca.*/) ? "msncanada" : site_code 
          redirect_to "http://cm.cyloop.com/feeds/#{feed_site}/feed_top_stations_#{site_code}.xml" 
        end
      end

    end

  end

  def artist_info
    if(artist.nil?)
      render :nothing => true
    else
      render :partial => "radio/artist_info"
    end
  end

  private
  def radio_show_cache_key_url
    "#{CURRENT_SITE.cache_key}/#{current_country.code}/#{params[:station_id]}/station/#{params[:id]}"
  end

  def top_stations
    @top_stations ||= current_site.summary_top_stations(:include => :station).limited_to(5)
  end
  helper_method :top_stations

  def artist
    # changed from Artist. to Account. since the STI has a unique identifier of id.
    @artist ||= (Account.find(params[:artist_id])) rescue nil
  end
  helper_method :artist

  def recent_listeners
    @recent_listeners ||= artist.recent_listens(14) rescue []
  end
  helper_method :recent_listeners

  def similar_artists
    @similar_artists ||= artist.similar(4) #rescue []
    @similar_artists
  end
  helper_method :similar_artists

  def most_listened_songs
    @most_listened_songs ||= artist.most_listened_songs(5)
  end
  helper_method :most_listened_songs
end
