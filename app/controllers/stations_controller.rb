class StationsController < ApplicationController
  before_filter :login_required, :only => [:edit, :delete]  
  # caches_action :top, :cache_path => :stations_cache_path_url, :expires_delta => EXPIRATION_TIMES['radio_top_stations']
  # TODO: Let's keep this as a reminder of the refactoring we *must* do  
  
  def index
    @stations = AbstractStation.search(params[:q], :per_page => params[:limit] || 15, :page => 1)
    respond_to do |format|
      format.txt  { render :text => @stations.join("\n") }
      format.xml  { render :xml => @stations.to_xml(:only => [:id, :name], :skip_types => true) }
      format.js  { render :text => @stations.collect{|s| "#{s.station.id}|#{s.name}|#{s.station_queue(:ip_address => remote_ip)}" }.join("\n") }
      #format.js   { render :json => @stations.collect{|s| {:id => s.id, :name => s.name} }.to_json }
    end
  end

  def edit
    @station = Station.find(params[:id]) rescue nil
    if @station and @station.playable.owner_is?(current_user)
    else
      render :partial => 'no_edit_rights'
    end
  end

  def edit_widget_station
    @station = Station.find(params[:id]) rescue nil
    render :layout => false
  end

  def delete
    @station = Station.find(params[:id]) rescue nil
    if @station and @station.playable.owner_is?(current_user)
      @station.playable.deactivate!
      render :text => 'destroyed'
    else
      render :partial => 'no_edit_rights'
    end
  end

  def delete_confirmation
    @station = Station.find(params[:id]) rescue nil    
    if @station and @station.playable.owner_is?(current_user)
      respond_to do |format|
        format.html do
          render :layout => false
        end
      end
    else
      render :partial => 'no_edit_rights'
    end
  end

  def delete_widget_station_confirmation
    respond_to do |format|
      format.html do
        render :layout => false
      end
    end
  end

  def top
    limit = params[:limit].to_i == 0 ? 4 : params[:limit].to_i
    @stations = current_site.top_abstract_stations(limit).compact
    @stations.reject! { |station| station.artist.nil? }
    @stations = Player::Station.from( @stations, :ip => remote_ip )
    respond_to do |format|
      format.xml { render :xml => @stations.to_xml( :root => 'stations' ) }
    end
  end

  def top_station_html
    artist = Artist.find(params[:artist_id])
    @locals = {:node => artist, :place_type => :recommended_station}
    @locals[:style] = 'last_box' if params[:last_bot]
    render :layout => false
  end

# private
# 
#   def stations_cache_path_url
#     "#{site_cache_key}/#{controller_name}/#{action_name}/#{params[:format]}"
#   end

end
