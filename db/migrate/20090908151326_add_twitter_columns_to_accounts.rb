class AddTwitterColumnsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :twitter_username, :string
    add_column :accounts, :twitter_id, :integer
    
    add_index :accounts, :twitter_username
    add_index :accounts, :twitter_id    
  end

  def self.down
    remove_index :accounts, :twitter_id 
    remove_index :accounts, :twitter_username
    
    remove_column :accounts, :twitter_id       
    remove_column :accounts, :twitter_username
  end
end
