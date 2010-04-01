class AddDeletedAtToUserStations < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE user_stations ADD deleted_at datetime, ADD KEY `index_user_stations_on_deleted_at_created_at` (deleted_at, created_at)"
  end

  def self.down
    ActiveRecord::Base.connection.execute "ALTER TABLE user_stations DROP COLUMN deleted_at, DROP KEY `index_user_stations_on_deleted_at_created_at`"
  end
end
