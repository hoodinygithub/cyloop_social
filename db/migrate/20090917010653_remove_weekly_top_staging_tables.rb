class RemoveWeeklyTopStagingTables < ActiveRecord::Migration
  def self.up
    drop_table :top_songs_by_site_by_week
    drop_table :top_stations_by_site_by_week
  end

  def self.down
    create_table :top_songs_by_site_by_week do |t|
      t.integer :song_id
      t.integer :site_id
      t.integer :play_count
    end

    create_table :top_stations_by_site_by_week do |t|
      t.integer :station_id
      t.integer :site_id
      t.integer :listener_count
    end
  end
end
