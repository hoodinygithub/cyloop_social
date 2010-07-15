class AddOptimizationsToPlaylistItems < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute <<-EOF
    ALTER TABLE playlist_items
    DROP KEY `index_playlist_items_on_artist_id`,
    ADD KEY `index_playlists_items_on_updated_at_for_latest_sort_for_artists` (`artist_id`,`playlist_id`,`updated_at`)
    EOF
  end

  def self.down
    ActiveRecord::Base.connection.execute <<-EOF
    ALTER TABLE playlist_items
    DROP KEY `index_playlists_items_on_updated_at_for_latest_sort_for_artists`,
    ADD KEY `index_playlist_items_on_artist_id`(`artist_id`)
    EOF
  end
end
