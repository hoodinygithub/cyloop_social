class RenameUsersToAccounts < ActiveRecord::Migration
  def self.up
    rename_table :users, :accounts
  end

  def self.down
    rename_table :accounts, :users
  end
end
