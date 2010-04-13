class AddTotalAlbumsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :total_albums, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :accounts, :total_albums
  end
end
