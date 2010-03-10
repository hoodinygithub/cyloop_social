class AddIndexOnSongIdAndArtistIdToSongListens < ActiveRecord::Migration
  def self.up
    add_index :song_listens, [:song_id, :artist_id]
  end

  def self.down
    remove_index :song_listens, :column => [:song_id, :artist_id]
  end
end
