class RemoveBioFromAccountsTable < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :bio
  end

  def self.down
    add_column :accounts, :bio, :text
  end
end
