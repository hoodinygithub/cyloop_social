class AddSortingIndiciesToUserStations < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE user_stations ADD KEY ix_sort_by_name_for_abstract_station_id (abstract_station_id, name), ADD KEY ix_sort_by_total_plays_for_abstract_station_id (abstract_station_id, total_plays), ADD KEY ix_sort_by_created_at_for_abstract_station_id (abstract_station_id, created_at)"
  end

  def self.down
    ActiveRecord::Base.connection.execute "ALTER TABLE user_stations DROP KEY ix_sort_by_name_for_abstract_station_id, DROP KEY ix_sort_by_total_plays_for_abstract_station_id, DROP KEY ix_sort_by_created_at_for_abstract_station_id"
  end
end
