class AddIndexesToTopUserStations < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute <<-EOF
    ALTER TABLE top_user_stations 
    ADD KEY `index_top_user_stations_on_site_id` (site_id, user_station_id),
    EOF
  end

  def self.down
  end
end
