class CreateTopSongs < ActiveRecord::Migration
  def self.up
    create_table :top_songs do |t|
      t.string :title
      t.integer :artist_id
      t.integer :duration
      t.string  :copyright
      t.string :label
      t.string :distributor
      t.string :file_name
      t.integer :album_id
      t.integer :position
      t.string :source
      t.integer :total_listens     
      t.timestamps
    end
  end

  def self.down
    drop_table :top_songs
  end
end
