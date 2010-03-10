class DefaultTypeToUserInAccounts < ActiveRecord::Migration
  def self.up
    execute "UPDATE accounts SET type = 'User' WHERE type = 'Consumer' OR type IS NULL"
  end

  def self.down
    execute "UPDATE accounts SET type = 'Consumer' WHERE type = 'User' OR type IS NULL"
  end
end
