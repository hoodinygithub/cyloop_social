class AddAlertsToFollowings < ActiveRecord::Migration
  def self.up
    add_column :followings, :songs, :boolean
    add_column :followings, :playlists, :boolean
    add_column :followings, :stations, :boolean
  end

  def self.down
    remove_column :followings, :stations
    remove_column :followings, :playlists
    remove_column :followings, :songs
  end
end
