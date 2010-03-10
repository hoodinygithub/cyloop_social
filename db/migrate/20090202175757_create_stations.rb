class CreateStations < ActiveRecord::Migration
  def self.up
    create_table :stations do |t|
      t.string :name
      t.integer :consumer_id
      t.integer :artist_id
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :stations
  end
end
