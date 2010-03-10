class AddTimestampsToStations < ActiveRecord::Migration
  def self.up
    remove_column :stations, :deleted_at
    add_column :stations, :created_at, :datetime
    add_column :stations, :updated_at, :datetime
  end

  def self.down
    remove_column :stations, :updated_at
    remove_column :stations, :created_at
    add_column :stations, :deleted_at, :datetime
  end
end
