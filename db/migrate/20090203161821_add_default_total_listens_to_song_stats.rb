class AddDefaultTotalListensToSongStats < ActiveRecord::Migration
  def self.up
    change_column :song_stats, :total_listens, :integer, :default => 0
  end

  def self.down
    # This section intentionally left blank
  end
end
