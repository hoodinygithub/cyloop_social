class RenameSongPlaysRawSongPlays < ActiveRecord::Migration
  def self.up
    rename_table :song_plays, :raw_song_plays
  end

  def self.down
    rename_table :raw_song_plays, :song_plays
  end
end
