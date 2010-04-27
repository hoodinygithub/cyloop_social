module Application::Stations
  def self.included( base )
    base.send( :include, Application::Stations::InstanceMethods )
  end

  module InstanceMethods
    def create_user_station(station)
      if logged_in? && station && station.playable && station.playable.is_a?(AbstractStation) && station.playable.deleted_at.nil?
        user_station = current_user.stations.find_by_abstract_station_id(station.playable_id)
        unless user_station
          user_station = current_user.create_user_station(:abstract_station => station.playable, :site => current_site)
          station = user_station if user_station
          record_station_activity(station)
        else
          station = user_station.station
        end
      end
    station  
    end
  end  
end