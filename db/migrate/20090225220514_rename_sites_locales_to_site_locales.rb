class RenameSitesLocalesToSiteLocales < ActiveRecord::Migration
  def self.up
    rename_table :sites_locales, :site_locales
  end

  def self.down
    rename_table :site_locales, :sites_locales
  end
end
