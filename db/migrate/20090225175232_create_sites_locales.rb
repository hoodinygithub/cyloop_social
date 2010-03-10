class CreateSitesLocales < ActiveRecord::Migration
  def self.up
    create_table :sites_locales do |t|
      t.integer :site_id
      t.integer :locale_id
    end
  end

  def self.down
    drop_table :sites_locales
  end
end
