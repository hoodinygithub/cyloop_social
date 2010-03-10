class SetTotalListensDefaultOnSongListens < ActiveRecord::Migration
  def self.up
    change_column :song_listens, :total_listens, :integer, :default => 0
  end

  def self.down
    change_column :song_listens, :total_listens, :integer, :default => nil
  end
end
