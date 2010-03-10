class AddFollowingsCountsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :followee_count, :integer, :default => 0
    add_column :accounts, :follower_count, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :follower_count
    remove_column :accounts, :followee_count
  end
end
