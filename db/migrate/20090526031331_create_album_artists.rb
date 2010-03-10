class CreateAlbumArtists < ActiveRecord::Migration
  def self.up
    create_table :album_artists do |t|
      t.references :album
      t.references :artist
      t.timestamps
    end
    add_index :album_artists, :album_id
    add_index :album_artists, :artist_id
  end

  def self.down
    remove_index :album_artists, :column => :artist_id
    remove_index :album_artists, :column => :album_id
    drop_table :album_artists
  end
end
