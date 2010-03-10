class CreateSongGenres < ActiveRecord::Migration
  def self.up
    create_table :song_genres do |t|
      t.references :song
      t.references :genre
      t.timestamps
    end
  end

  def self.down
    drop_table :song_genres
  end
end
