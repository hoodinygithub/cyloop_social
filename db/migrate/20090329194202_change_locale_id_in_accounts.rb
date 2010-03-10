class ChangeLocaleIdInAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :locale_id
    add_column :accounts, :default_locale, :string
  end

  def self.down
    remove_column :accounts, :default_locale
    add_column :accounts, :locale_id, :integer
  end
end
