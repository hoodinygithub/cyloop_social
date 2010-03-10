class AddTimestampsToPlaylistItems < ActiveRecord::Migration
  def self.up
    add_column :playlist_items, :created_at, :datetime
    add_column :playlist_items, :updated_at, :datetime
  end

  def self.down
    remove_column :playlist_items, :updated_at
    remove_column :playlist_items, :created_at
  end
end
