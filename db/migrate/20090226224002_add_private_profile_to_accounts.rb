class AddPrivateProfileToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :private_profile, :boolean
  end

  def self.down
    remove_column :accounts, :private_profile
  end
end
