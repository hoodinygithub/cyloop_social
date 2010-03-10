class AddListenerIpAddressToRawSongPlays < ActiveRecord::Migration
  def self.up
    add_column :raw_song_plays, :listener_ip_address, :string
  end

  def self.down
    remove_column :raw_song_plays, :listener_ip_address
  end
end
