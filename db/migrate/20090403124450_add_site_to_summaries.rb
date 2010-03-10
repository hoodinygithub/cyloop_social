class AddSiteToSummaries < ActiveRecord::Migration
  def self.up
    add_column :top_songs, :site_id, :integer
    add_column :top_songs, :song_id, :integer    
    add_column :top_albums, :site_id, :integer
    add_column :top_albums, :album_id, :integer    
    add_column :top_artists, :site_id, :integer
    add_column :top_artists, :artist_id, :integer    
    add_column :top_stations, :site_id, :integer
    add_column :top_stations, :station_id, :integer    
    add_column :top_stations, :station_count, :integer    
    add_index :top_songs, :site_id
    add_index :top_songs, :song_id
    add_index :top_albums, :site_id
    add_index :top_albums, :album_id
    add_index :top_artists, :site_id
    add_index :top_artists, :artist_id
    add_index :top_stations, :site_id
    add_index :top_stations, :station_id
  end

  def self.down
    remove_index :top_songs, :column => :site_id
    remove_index :top_songs, :column => :song_id
    remove_index :top_albums, :column => :site_id
    remove_index :top_albums, :column => :album_id
    remove_index :top_artists, :column => :site_id
    remove_index :top_artists, :column => :artist_id
    remove_index :top_stations, :column => :site_id
    remove_index :top_stations, :column => :station_id
    remove_column :top_songs, :site_id
    remove_column :top_songs, :song_id
    remove_column :top_albums, :site_id
    remove_column :top_albums, :album_id
    remove_column :top_artists, :site_id
    remove_column :top_artists, :artist_id
    remove_column :top_stations, :site_id
    remove_column :top_stations, :station_id
    remove_column :top_stations, :station_count
  end
end
