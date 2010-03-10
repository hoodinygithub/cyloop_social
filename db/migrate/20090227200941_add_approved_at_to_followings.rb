class AddApprovedAtToFollowings < ActiveRecord::Migration
  def self.up
    add_column :followings, :approved_at, :datetime
    change_column :accounts, :private_profile, :boolean, :default => false
  end

  def self.down
    change_column :accounts, :private_profile, :boolean, :default => nil
    remove_column :followings, :approved_at
  end
end
