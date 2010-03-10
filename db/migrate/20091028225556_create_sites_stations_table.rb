class CreateSitesStationsTable < ActiveRecord::Migration
  def self.up
    create_table :sites_stations do |t|
      t.references :site
      t.references :account
      t.references :station
      t.references :playlist
      t.timestamps
    end
    add_index :sites_stations, [:site_id, :account_id]
  end

  def self.down
    drop_table :sites_stations
  end
end
