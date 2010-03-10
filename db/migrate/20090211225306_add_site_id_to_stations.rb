class AddSiteIdToStations < ActiveRecord::Migration
  def self.up
    add_column :stations, :site_id, :integer
  end

  def self.down
    remove_column :stations, :site_id
  end
end
