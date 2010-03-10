class AddIndiciesOnAmgIdToAccountsAndStations < ActiveRecord::Migration
  def self.up
    add_index :accounts, :amg_id
    add_index :stations, :amg_id
  end

  def self.down
    remove_index :accounts, :column => :amg_id
    remove_index :stations, :column => :amg_id
  end
end
