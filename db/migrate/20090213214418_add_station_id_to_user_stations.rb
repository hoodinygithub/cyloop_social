class AddStationIdToUserStations < ActiveRecord::Migration
  def self.up
    add_column :user_stations, :station_id, :integer
    remove_column :user_stations, :artist_id
    execute "delete from user_stations"
  end

  def self.down
    remove_column :user_stations, :station_id
    add_column :user_stations, :artist_id, :integer
  end
end
