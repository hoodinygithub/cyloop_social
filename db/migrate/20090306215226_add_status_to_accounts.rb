class AddStatusToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :status, :string
  end

  def self.down
    remove_column :accounts, :status
  end
end
