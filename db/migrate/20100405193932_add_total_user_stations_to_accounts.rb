class AddTotalUserStationsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :total_user_stations, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :accounts, :total_user_stations
  end
end
