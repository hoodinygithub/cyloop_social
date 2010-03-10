class AddDefaultCountryIdToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :default_country_id, :integer
  end

  def self.down
    remove_column :sites, :default_country_id
  end
end
