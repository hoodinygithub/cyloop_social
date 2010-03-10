class AddNewIndiciesToAccounts < ActiveRecord::Migration
  def self.up
    add_index :accounts, :email
    add_index :accounts, :reset_code
    add_index :accounts, :confirmation_code
    end

  def self.down
    remove_index :accounts, :column => :email
    remove_index :accounts, :column => :reset_code
    remove_index :accounts, :column => :confirmation_code
  end
end
