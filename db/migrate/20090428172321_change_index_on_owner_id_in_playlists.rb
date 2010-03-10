class ChangeIndexOnOwnerIdInPlaylists < ActiveRecord::Migration
  def self.up
    add_index :playlists, [:owner_id, :created_at]
  end

  def self.down
    remove_index :playlists, :column => [:owner_id, :created_at]
  end
end
