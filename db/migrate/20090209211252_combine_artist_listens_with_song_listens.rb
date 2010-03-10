class CombineArtistListensWithSongListens < ActiveRecord::Migration
  def self.up
    add_column :song_listens, :artist_id, :integer
    execute "UPDATE song_listens SET artist_id = (SELECT songs.artist_id FROM songs WHERE songs.id = song_listens.song_id)"

    drop_table :artist_listens
  end

  def self.down
    create_table :artist_listens do |t|
      t.integer :listener_id
      t.integer :artist_id
      t.integer :total_listens

      t.timestamps
    end

    remove_column :song_listens, :artist_id
  end
end
