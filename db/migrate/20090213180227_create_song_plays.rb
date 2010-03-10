class CreateSongPlays < ActiveRecord::Migration
  def self.up
    create_table :song_plays do |t|
      t.integer :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :song_plays
  end
end
