class CreateSongListens < ActiveRecord::Migration
  def self.up
    create_table :song_listens do |t|
      t.integer :listener_id
      t.integer :song_id
      t.integer :total_listens

      t.timestamps
    end
  end

  def self.down
    drop_table :song_listens
  end
end
