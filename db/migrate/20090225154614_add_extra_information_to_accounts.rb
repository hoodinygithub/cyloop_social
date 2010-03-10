class AddExtraInformationToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :websites, :text
    add_column :accounts, :bio, :text
  end

  def self.down
    remove_column :accounts, :bio
    remove_column :accounts, :websites
  end
end
