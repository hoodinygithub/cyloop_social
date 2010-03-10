class AddRemainingIndiciesOnForeignKeys < ActiveRecord::Migration
  def self.up
    add_index :accounts, :city_id 
    add_index :albums, :owner_id 
    add_index :blocks, :blocker_id 
    add_index :blocks, :blockee_id 
    add_index :followings, :follower_id 
    add_index :followings, :followee_id 
    add_index :playlist_items, :playlist_id 
    add_index :playlist_items, :song_id 
    add_index :playlists, :owner_id 
    add_index :song_listens, :site_id 
    add_index :songs, :artist_id 
    add_index :songs, :album_id 
    add_index :stations, :artist_id 
    add_index :user_stations, :owner_id 
    add_index :user_stations, :site_id 
    add_index :user_stations, :station_id 
    add_index :user_stations, :referrer_id 
  end

  def self.down
    remove_index :user_stations, :column => :referrer_id     
    remove_index :user_stations, :column => :station_id 
    remove_index :user_stations, :column => :site_id 
    remove_index :user_stations, :column => :owner_id 
    remove_index :stations, :column => :artist_id 
    remove_index :songs, :column => :album_id 
    remove_index :songs, :column => :artist_id 
    remove_index :song_listens, :column => :site_id 
    remove_index :playlists, :column => :owner_id 
    remove_index :playlist_items, :column => :song_id 
    remove_index :playlist_items, :column => :playlist_id 
    remove_index :followings, :column => :followee_id 
    remove_index :followings, :column => :follower_id 
    remove_index :blocks, :column => :blockee_id 
    remove_index :blocks, :column => :blocker_id 
    remove_index :albums, :column => :owner_id 
    remove_index :accounts, :column => :city_id 
  end
end
