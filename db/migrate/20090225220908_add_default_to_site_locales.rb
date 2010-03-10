class AddDefaultToSiteLocales < ActiveRecord::Migration
  def self.up
    add_column :site_locales, :default, :boolean, :default => false
  end

  def self.down
    remove_column :site_locales, :default
  end
end
