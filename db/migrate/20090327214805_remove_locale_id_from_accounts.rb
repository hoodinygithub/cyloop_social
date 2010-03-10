class RemoveLocaleIdFromAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :locale_id
  end

  def self.down
    add_column :accounts, :locale_id, :integer
  end
end
