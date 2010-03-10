class AddAmgIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :amg_id, :string, :limit => 10
  end

  def self.down
    remove_column :accounts, :amg_id
  end
end
