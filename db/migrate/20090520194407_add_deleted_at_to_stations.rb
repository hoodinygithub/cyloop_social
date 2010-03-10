class AddDeletedAtToStations < ActiveRecord::Migration
  def self.up
    add_column :stations, :deleted_at, :datetime
  end

  def self.down
    remove_column :stations, :deleted_at
  end
end
