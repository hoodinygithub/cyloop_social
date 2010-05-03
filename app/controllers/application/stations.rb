module Application::Stations
  def self.included( base )
    base.send( :include, Application::Stations::InstanceMethods )
  end

  module InstanceMethods
    def create_user_station(station)
      if logged_in? && current_user && station && station.playable && station.playable.is_a?(AbstractStation) && station.playable.deleted_at.nil?
        user_station = UserStation.find_by_owner_id_and_abstract_station_id(current_user.id, station.playable_id)
        if user_station
          unless user_station.deleted_at.nil?
            user_station.activate! 
            record_station_activity(user_station)
          end
          station = user_station.station
        else
          user_station = current_user.create_user_station(:abstract_station => station.playable, :site => current_site, :name => station.playable.name)
          station = user_station if user_station
          record_station_activity(station)
        end
      end
      station
    end
  end  
end