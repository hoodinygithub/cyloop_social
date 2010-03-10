class ChangeWlidIndexOnAccountsToIncludeDeletedAt < ActiveRecord::Migration
  def self.up
    remove_index :accounts, :column => :msn_live_id
    add_index :accounts, [:msn_live_id, :deleted_at]
  end

  def self.down
    remove_index :accounts, :column => [:msn_live_id, :deleted_at]
    add_index :accounts, :msn_live_id
  end
  
end
