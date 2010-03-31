class AddTopUserStations < ActiveRecord::Migration
  def self.up
    create_table :top_user_stations do |t|
      t.references  :site
      t.references  :user_station
      t.integer     :total_requests
      t.timestamps
    end
  end

  def self.down
    drop_table :top_user_stations
  end
end
