class ChangeTopStationsToAbstract < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE top_stations CHANGE station_id abstract_station_id int(11)"
    ActiveRecord::Base.connection.execute "RENAME TABLE top_stations TO top_abstract_stations"
  end

  def self.down
    ActiveRecord::Base.connection.execute "RENAME TABLE top_abstract_stations TO top_stations"
    ActiveRecord::Base.connection.execute "ALTER TABLE top_stations CHANGE abstract_station_id station_id int(11)"
  end
end
