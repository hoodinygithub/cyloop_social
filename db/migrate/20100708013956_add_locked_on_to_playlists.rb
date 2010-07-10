class AddLockedOnToPlaylists < ActiveRecord::Migration
  def self.up
    add_column :playlists, :locked_at, :datetime
  end

  def self.down
    remove_column :playlists, :locked_at
  end
end
