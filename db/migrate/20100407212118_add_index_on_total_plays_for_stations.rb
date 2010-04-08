class AddIndexOnTotalPlaysForStations < ActiveRecord::Migration
  def self.up
    add_index :user_stations, [:owner_id, :total_plays]
    add_index :editorial_stations, [:mix_id, :total_plays]
    add_index :abstract_stations, [:artist_id, :total_plays]
  end

  def self.down
    remove_index :user_stations, :column =>  [:owner_id, :total_plays]
    remove_index :editorial_stations, :column =>  [:mix_id, :total_plays]
    remove_index :abstract_stations, :column => [:artist_id, :total_plays]
  end
end
