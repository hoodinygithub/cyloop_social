class CreateWeeklyTopStagingTables < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table :top_songs_by_site_by_week
    drop_table :top_stations_by_site_by_week
  end
end
