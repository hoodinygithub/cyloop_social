class AddEntryPointIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :entry_point_id, :integer
  end

  def self.down
    remove_column :accounts, :entry_point_id
  end
end
