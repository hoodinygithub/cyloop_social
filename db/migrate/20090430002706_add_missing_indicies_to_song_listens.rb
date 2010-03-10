class AddMissingIndiciesToSongListens < ActiveRecord::Migration
  def self.up
    add_index :song_listens, [:album_id, :total_listens]
    add_index :song_listens, [:artist_id, :listener_id, :updated_at]
  end

  def self.down
    remove_index :song_listens, :column => [:album_id, :total_listens]
    remove_index :song_listens, :column => [:artist_id, :listener_id, :updated_at]
  end
end
