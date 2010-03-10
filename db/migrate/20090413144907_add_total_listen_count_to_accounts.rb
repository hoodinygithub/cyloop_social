class AddTotalListenCountToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :total_listen_count, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :total_listen_count
  end
end
