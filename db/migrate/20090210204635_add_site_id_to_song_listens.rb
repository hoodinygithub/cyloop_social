class AddSiteIdToSongListens < ActiveRecord::Migration
  def self.up
    add_column :song_listens, :site_id, :integer
  end

  def self.down
    remove_column :song_listens, :site_id
  end
end
