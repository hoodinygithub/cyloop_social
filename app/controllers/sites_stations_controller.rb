class SitesStationsController < ApplicationController
  before_filter :assert_radio_is_enabled

  def index
    # NIL account_id     => sites_stations returns for the current site
    # NOT NIL account_id => sites_stations returns for the defined account on the current site
    block = Proc.new do
      if params[:player_id] 
        @editorial_playlist = current_site.editorial_stations_sites.find_all_by_player_id(params[:player_id], :conditions => ['editorial_station_id > 0'], :group => 'editorial_station_id')
      else
        @editorial_playlist = current_site.editorial_stations_sites.find_all_by_profile_id(params["account_id"], :conditions => ['editorial_station_id > 0'], :group => 'editorial_station_id')
      end
      
      if !@editorial_playlist.empty?
        render :xml => Player::Editorial.from(@editorial_playlist, :ip => remote_ip).to_xml(:root => 'editorial_stations')
        #@editorial_playlist.to_xml(:root => 'editorial_stations') 
      else
        render :xml => { :alert => 'Market does not contain editorial stations' }.to_xml(:root => 'response')
      end
    end
    respond_to do |format|
      format.xml(&block)
      format.js(&block)
      format.html { render :text => 'request[.xml, .js]' }
    end
  end

  def show
    @playlist = current_site.stations.find(params[:id])
    respond_to do |format|
      format.html {}
      format.xml { render :layout => false }
    end
  end

  private
  def assert_radio_is_enabled
    unless current_country.radio_enabled?
      render :xml => { :alert => 'Radio is not available in this country.' }.to_xml(:root => 'response')
    else
      true
    end
  end

end
