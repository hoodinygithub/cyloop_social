class AddArtistIdToPlaylistItems < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE playlist_items ADD artist_id int(11), ADD KEY index_playlist_items_on_artist_id(artist_id)"
  end

  def self.down
    ActiveRecord::Base.connection.execute "ALTER TABLE playlist_items DROP KEY index_playlist_items_on_artist_id, DROP artist_id"
  end
end
