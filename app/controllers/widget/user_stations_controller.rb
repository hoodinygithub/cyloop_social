
class Widget::UserStationsController < Widget::WidgetController

  def index
    respond_to do |format|
      format.xml do
        if logged_in?
          @stations = profile_user.stations
          @stations.reject! { |station| station.artist.nil? }
          render :xml => Player::Station.from(@stations, :ip => remote_ip, :user_id => logged_in? ? current_user.id : nil).to_xml(:root => 'user_stations')
        else
          format.xml { render :xml => { :error => 'authentication required' }.to_xml(:root => 'response') }
        end
      end
        
    end
  end

  def update
    @user_station = UserStation.find_by_id_and_owner_id!(params[:id], profile_user.id)
    @user_station.update_attribute(:name, params[:user_station][:name])
    respond_to do |format|
      format.xml do
        render :xml => Player::Message.new( :message => t('messenger_player.station_edit_success') )
      end
    end
  end

  def destroy
    UserStation.find_by_id_and_owner_id!(params[:id], profile_user.id).destroy
    respond_to do |format|
      format.xml do
        render :xml => Player::Message.new( :message => t('stations.deleted') )
      end
    end
  end  

end