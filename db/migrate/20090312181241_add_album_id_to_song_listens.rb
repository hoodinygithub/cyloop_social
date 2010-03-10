class AddAlbumIdToSongListens < ActiveRecord::Migration
  def self.up
    add_column :song_listens, :album_id, :integer
  end

  def self.down
    remove_column :song_listens, :album_id
  end
end
