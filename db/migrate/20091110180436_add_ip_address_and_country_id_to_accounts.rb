class AddIpAddressAndCountryIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :ip_address, :string
    add_column :accounts, :country_id, :integer
    
    add_index :accounts, :country_id
  end

  def self.down
    remove_index :accounts, :country_id
    remove_column :accounts, :country_id
    remove_column :accounts, :ip_address
  end
end
