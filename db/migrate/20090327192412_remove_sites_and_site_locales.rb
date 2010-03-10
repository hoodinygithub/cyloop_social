class RemoveSitesAndSiteLocales < ActiveRecord::Migration
  def self.up
    drop_table :locales
    drop_table :site_locales
  end

  def self.down
    create_table :locales do |t|
      t.integer :country_id
      t.string  :name
      t.string  :code
      t.boolean :supported
      t.timestamps!
    end
    
    create_table :site_locales do |t|
      t.integer :site_id
      t.integer :locale_id
      t.boolean :default, :default => false
    end
  end
end
