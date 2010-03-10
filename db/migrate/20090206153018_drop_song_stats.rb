class DropSongStats < ActiveRecord::Migration
  def self.up
    drop_table :song_stats
  end

  def self.down
    create_table :song_stats do |t|
      t.integer  :song_id
      t.integer  :total_listens, :default => 0
      t.timestamps
    end
  end
end
