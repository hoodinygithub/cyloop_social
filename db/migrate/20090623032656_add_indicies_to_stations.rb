class AddIndiciesToStations < ActiveRecord::Migration
  def self.up
    add_index :stations, :available
  end

  def self.down
    remove_index :stations, :column => :available
  end
end
