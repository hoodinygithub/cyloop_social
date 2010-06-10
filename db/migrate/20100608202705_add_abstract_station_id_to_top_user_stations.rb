class AddAbstractStationIdToTopUserStations < ActiveRecord::Migration
  def self.up
    add_column :top_user_stations, :abstract_station_id, :integer
  end

  def self.down
    remove_column :top_user_stations, :abstract_station_id
  end
end
