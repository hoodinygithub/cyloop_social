class CreateAlbumBuylinks < ActiveRecord::Migration
  def self.up
    create_table :album_buylinks do |t|
      t.references :album
      t.references :buylink_provider
      t.string :url
      t.timestamps
    end
    add_index :album_buylinks, :album_id 
    add_index :album_buylinks, :buylink_provider_id 
    add_column :albums, :buylink_count, :integer, :default => 0
  end

  def self.down
    drop_table :album_buylinks 
    remove_column :albums, :buylink_count
  end
end
