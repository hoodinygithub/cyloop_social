
class Widget::StationsController < Widget::WidgetController

  def create
    @station = Station.available.first( :conditions => {:name => params[:station_name]} )
    if @station

      @station_object = if logged_in?
        user_station = current_user.stations.find_by_station_id(@station.id)
        unless user_station
          user_station = current_user.create_user_station(:station_id => @station.id, :current_site => current_site)
          record_activity(@station)
        end
        user_station
      else
        @station
      end

      respond_to do |format|
        format.xml do
          session[:current_station] = @station_object.id
          render :xml => Player::Station.from(@station_object, :ip => remote_ip, :user_id => logged_in? ? current_user.id : nil).to_xml(:root => @station_object.kind_of?(UserStation) ? 'user_station' : 'station')
        end
      end

    else

      not_found_message = t('stations.could_not_find_artist', :artist => params[:station_name])
      respond_to do |format|
        format.xml { render :xml => Player::Error.new(:error => not_found_message, :code => 404) }
      end

    end

  end

  def index
    @stations = Station.search(params[:q], :per_page => params[:limit] || 15, :page => 1)
    respond_to do |format|
      format.txt { render :text => @stations.join("\n") }
      format.xml { render :xml => @stations.to_xml(:only => [:id, :name], :skip_types => true) }
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

end