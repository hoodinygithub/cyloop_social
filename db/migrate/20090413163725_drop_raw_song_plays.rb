class DropRawSongPlays < ActiveRecord::Migration
  def self.up
    drop_table :raw_song_plays
  end

  def self.down
    create_table :raw_song_plays do |t|
      t.integer    :duration
      t.string     :source
      t.references :country
      t.references :listener
      t.references :song
      t.references :site
      t.string     :listener_ip_address
      t.boolean    :full
      t.references :station
      t.timestamps
    end
  end
end
