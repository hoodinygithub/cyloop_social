class AddTotalTimeToAlbumsAndPlaylists < ActiveRecord::Migration
  def self.up
    add_column :albums, :total_time, :integer, :default => 0
    add_column :playlists, :total_time, :integer, :default => 0 
  end

  def self.down
    remove_column :albums, :total_time
    remove_column :playlists, :total_time
  end
end
