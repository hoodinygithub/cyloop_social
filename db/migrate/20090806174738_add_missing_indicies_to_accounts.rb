class AddMissingIndiciesToAccounts < ActiveRecord::Migration
  def self.up
    add_index :accounts, :msn_live_id
  end

  def self.down
    remove_index :accounts, :column => :msn_live_id
  end
end
