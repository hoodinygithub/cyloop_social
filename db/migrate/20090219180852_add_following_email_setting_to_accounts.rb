class AddFollowingEmailSettingToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :receives_following_notifications, :boolean, :default => true
  end

  def self.down
    remove_column :accounts, :receives_following_notifications
  end
end
