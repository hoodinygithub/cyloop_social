class CreateSongStats < ActiveRecord::Migration
  def self.up
    create_table :song_stats do |t|
      t.integer :song_id
      t.integer :total_listens

      t.timestamps
    end
  end

  def self.down
    drop_table :song_stats
  end
end
