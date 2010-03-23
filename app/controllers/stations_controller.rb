class StationsController < ApplicationController
  # TODO: Let's keep this as a reminder of the refactoring we *must* do
  def index
    # @stations = Station.available.starts_with(params[:q]).all(:limit => 15)
    @stations = Station.search(params[:q], :per_page => params[:limit] || 15, :page => 1)
    respond_to do |format|
      format.txt  { render :text => @stations.join("\n") }
      format.xml  { render :xml => @stations.to_xml(:only => [:id, :name], :skip_types => true) }
      format.js   { render :text => @stations.collect{|s| {:id => s.id, :name => s.name} }.to_json }
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
