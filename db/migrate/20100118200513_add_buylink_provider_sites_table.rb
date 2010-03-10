class AddBuylinkProviderSitesTable < ActiveRecord::Migration
  def self.up
    create_table :buylink_providers_sites do |t|
      t.references :buylink_provider
      t.references :site
      t.references :country
      t.timestamps
    end
    
    add_index :buylink_providers_sites, [:site_id, :country_id]
    add_index :buylink_providers_sites, :buylink_provider_id
  end

  def self.down
    drop_table :buylink_providers_sites
  end
end
