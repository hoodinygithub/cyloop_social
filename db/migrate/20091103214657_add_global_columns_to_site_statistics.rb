class AddGlobalColumnsToSiteStatistics < ActiveRecord::Migration
  def self.up
    add_column :site_statistics, :total_global_users, :integer, :default => 0
    add_column :site_statistics, :total_global_registrations, :integer, :default => 0
  end

  def self.down
    remove_column :site_statistics, :total_global_users
    remove_column :site_statistics, :total_global_registrations
  end
end
