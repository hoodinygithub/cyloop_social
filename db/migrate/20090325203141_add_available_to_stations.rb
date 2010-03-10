class AddAvailableToStations < ActiveRecord::Migration
  def self.up
    add_column :stations, :available, :boolean, :default => true
  end

  def self.down
    remove_column :stations, :available
  end
end
