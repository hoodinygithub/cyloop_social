class ChangeSortingIndexesOnUserStations < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute <<-EOF
    ALTER TABLE `user_stations`
    ADD KEY `ix_sort_by_updated_at_for_abstract_station_id` (abstract_station_id, updated_at),
    ADD KEY `ix_sort_by_updated_at_for_site_id` (site_id, updated_at),
    ADD KEY `ix_sort_by_created_at_for_site_id` (site_id, created_at),
    ADD KEY `ix_sort_by_updated_at_for_owner_id` (owner_id, updated_at),
    DROP KEY `index_user_stations_on_site_id`,
    DROP KEY `index_user_stations_on_station_id`
    EOF
  end

  def self.down
    ActiveRecord::Base.connection.execute <<-EOF
    ALTER TABLE `user_stations`
    ADD KEY `index_user_stations_on_site_id` (site_id),
    ADD KEY `index_user_stations_on_station_id` (abstract_station_id),
    DROP KEY `ix_sort_by_updated_at_for_abstract_station_id`,
    DROP KEY `ix_sort_by_updated_at_for_site_id`,
    DROP KEY `ix_sort_by_created_at_for_site_id`,
    DROP KEY `ix_sort_by_updated_at_for_owner_id`
    EOF
  end
end
