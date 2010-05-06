class RemoveUserStationArtistsTable < ActiveRecord::Migration
  def self.up
    drop_table :user_station_artists
  end

  def self.down
    create_table :user_station_artists do |t|
      t.references :user_station
      t.references :artist
      t.references :album
      t.timestamps
    end
    add_index :user_station_artists, [:user_station_id, :artist_id]
    add_index :user_station_artists, :artist_id
  end
end
