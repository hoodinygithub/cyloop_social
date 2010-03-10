class AddDefaultLocaleToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :default_locale, :string
    remove_column :sites, :default_country_id
  end

  def self.down
    remove_column :sites, :default_locale
    add_column :sites, :default_locale, :integer
  end
end
