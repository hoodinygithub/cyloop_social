class AddIndexToStationsOnName < ActiveRecord::Migration
  def self.up
    add_index :stations, [:name, :available]
  end

  def self.down
    remove_index :stations, :column => [:name, :available]
  end
end
