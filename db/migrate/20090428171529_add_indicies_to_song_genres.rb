class AddIndiciesToSongGenres < ActiveRecord::Migration
  def self.up
    add_index :song_genres, :song_id
    add_index :song_genres, :genre_id
  end

  def self.down
    remove_index :song_genres, :column => :song_id
    remove_index :song_genres, :column => :genre_id
  end
end
