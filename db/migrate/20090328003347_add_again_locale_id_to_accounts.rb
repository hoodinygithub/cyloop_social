class AddAgainLocaleIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :locale_id, :integer
  end

  def self.down
    remove_column :accounts, :locale_id
  end
end
