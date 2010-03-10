class AddIndexOnArtistIdToBandMembers < ActiveRecord::Migration
  def self.up
    add_index :band_members, :artist_id
  end

  def self.down
    remove_index :band_members, :column => :artist_id
  end
end
