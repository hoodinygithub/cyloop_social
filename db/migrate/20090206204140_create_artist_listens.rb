class CreateArtistListens < ActiveRecord::Migration
  def self.up
    create_table :artist_listens do |t|
      t.integer :listener_id
      t.integer :artist_id
      t.integer :total_listens

      t.timestamps
    end
  end

  def self.down
    drop_table :artist_listens
  end
end
