class RecreateStations < ActiveRecord::Migration
  def self.up
    create_table :stations do |t|
      t.string :name
      t.string :amg_id, :limit => 10
      t.integer :artist_id
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :stations
  end
end
