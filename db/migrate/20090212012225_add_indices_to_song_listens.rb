class AddIndicesToSongListens < ActiveRecord::Migration
  def self.up
    add_index :song_listens, :listener_id
    add_index :song_listens, :artist_id
    add_index :song_listens, :song_id
  end

  def self.down
    remove_index :song_listens, :column => :song_id
    remove_index :song_listens, :column => :artist_id
    remove_index :song_listens, :column => :listener_id
  end
end
