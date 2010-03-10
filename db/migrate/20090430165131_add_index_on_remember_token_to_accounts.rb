class AddIndexOnRememberTokenToAccounts < ActiveRecord::Migration
  def self.up
    add_index :accounts, :remember_token
  end

  def self.down
    remove_index :accounts, :column => :remember_token
  end
end
