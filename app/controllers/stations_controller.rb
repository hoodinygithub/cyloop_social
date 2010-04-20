class StationsController < ApplicationController
  before_filter :login_required, :only => [:edit]
  # TODO: Let's keep this as a reminder of the refactoring we *must* do
  def index
    @stations = AbstractStation.search(params[:q], :per_page => params[:limit] || 15, :page => 1)
    respond_to do |format|
      format.txt  { render :text => @stations.join("\n") }
      format.xml  { render :xml => @stations.to_xml(:only => [:id, :name], :skip_types => true) }
      format.js  { render :text => @stations.collect{|s| "#{s.station.id}|#{s.name}" }.join("\n") }
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

  def top
    limit = params[:limit].to_i == 0 ? 4 : params[:limit].to_i
    @stations = current_site.summary_top_stations.limited_to( limit ).map { |t| t.station }.compact
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

end
