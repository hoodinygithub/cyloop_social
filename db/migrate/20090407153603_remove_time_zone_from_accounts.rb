class RemoveTimeZoneFromAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :time_zone
  end

  def self.down
    add_column :accounts, :time_zone, :string
  end
end
