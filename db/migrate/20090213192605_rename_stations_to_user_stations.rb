class RenameStationsToUserStations < ActiveRecord::Migration
  def self.up
    rename_table :stations, :user_stations
  end

  def self.down
    rename_table :user_stations, :stations
  end
end
