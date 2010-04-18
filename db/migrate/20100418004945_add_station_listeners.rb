class AddStationListeners < ActiveRecord::Migration
  def self.up
    create_table :station_listeners do |t|
      t.references :station
      t.references :listener
      t.integer :total_plays
      t.timestamps
    end
    add_index :station_listeners, [:listener_id, :updated_at, :station_id, :total_plays], :name => 'index_station_listeners_by_listener'
    add_index :station_listeners, [:station_id,  :updated_at, :listener_id, :total_plays], :name =>  'index_station_listeners_by_station'
  end

  def self.down
    drop_table :station_listeners
  end
end
