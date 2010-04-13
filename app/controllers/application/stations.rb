module Application::Stations
  def self.included( base )
    base.send( :include, Application::Stations::InstanceMethods )
  end

  module InstanceMethods
    def create_user_station(station)
      if logged_in? && station && station.playable && station.playable.is_a? AbstractStation
        user_station = current_user.stations.find_by_abstract_station_id(station.playable_id)
        unless user_station
          current_user.create_user_station(:abstract_station_id => station.id, :current_site => current_site)
          record_station_activity(station)
        end
      end
    end
  end  
end