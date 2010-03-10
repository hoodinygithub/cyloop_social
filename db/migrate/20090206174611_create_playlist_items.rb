class CreatePlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :playlist_items do |t|
      t.integer :playlist_id
      t.integer :song_id
      t.integer :position
    end
  end

  def self.down
    drop_table :playlist_items
  end
end
