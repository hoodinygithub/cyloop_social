class AddHasCustomProfileToAccounts < ActiveRecord::Migration

  def self.up
    add_column :accounts, :has_custom_profile, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :has_custom_profile
  end

end
