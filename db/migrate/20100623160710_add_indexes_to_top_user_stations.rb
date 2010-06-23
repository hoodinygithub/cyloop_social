class AddIndexesToTopUserStations < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE top_user_stations ADD KEY `index_top_user_stations_on_site_id` (site_id, user_station_id)"
  end

  def self.down
    ActiveRecord::Base.connection.execute "ALTER TABLE top_user_stations DROP KEY `index_top_user_stations_on_site_id`"
  end
end
