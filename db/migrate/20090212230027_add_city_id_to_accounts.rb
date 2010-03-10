class AddCityIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :city_id, :integer
  end

  def self.down
    remove_column :accounts, :city_id
  end
end
