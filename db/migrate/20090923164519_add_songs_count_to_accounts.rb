class AddSongsCountToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :songs_count, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :songs_count 
  end
end
