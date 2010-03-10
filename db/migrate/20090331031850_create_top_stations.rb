class CreateTopStations < ActiveRecord::Migration
  def self.up
    create_table :top_stations do |t|
      t.string   :name
      t.string   :amg_id
      t.integer  :artist_id
      t.text     :includes_cache
      t.boolean  :available
      t.integer  :order
      t.timestamps
    end
  end

  def self.down
    drop_table :top_stations
  end
end
