class RenameConsumerIdToOwnerIdOnStations < ActiveRecord::Migration
  def self.up
    rename_column :stations, :consumer_id, :owner_id
  end

  def self.down
    rename_column :stations, :owner_id, :consumer_id
  end
end
