class Widget::SitesStationsController < Widget::WidgetController

  def index
    respond_to do |format|
      format.xml do
        @editorial_playlist = current_site.sites_stations.all(:conditions => ['station_id > 0'])
        unless @editorial_playlist.blank?
          render :xml => Player::Editorial.from(@editorial_playlist, :ip => remote_ip).to_xml(:root => 'editorial_stations')
        else
          render :xml => { :alert => 'Market does not contain editorial stations' }.to_xml(:root => 'response')
        end
      end
    end
  end

  def show
    @playlist = current_site.sites_stations.find(params[:id]).playlist
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end

end
