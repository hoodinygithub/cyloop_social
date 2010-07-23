class AddPlayerIdToEditorialStationsSites < ActiveRecord::Migration
  def self.up
    add_column :editorial_stations_sites, :player_id, :integer
  end

  def self.down
    remove_column :editorial_stations_sites, :player_id
  end
end
