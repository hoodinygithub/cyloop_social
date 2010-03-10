class AddLogoPathToSitesStations < ActiveRecord::Migration
  def self.up
    add_column :sites_stations, :logo_path, :string
  end

  def self.down
    remove_column :sites_stations, :logo_path
  end
end
