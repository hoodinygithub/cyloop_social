class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.integer :owner_id
      t.string  :name
      t.integer :comments_count, :default => 0
      t.integer :songs_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :playlists
  end
end
