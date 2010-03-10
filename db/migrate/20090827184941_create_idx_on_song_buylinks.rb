class CreateIdxOnSongBuylinks < ActiveRecord::Migration
  def self.up
    add_index :song_buylinks, :song_id
    add_index :song_buylinks, :buylink_provider_id
  end

  def self.down
    remove_index :song_buylinks, :column => :song_id
    remove_index :song_buylinks, :column => :buylink_provider_id
  end
end
