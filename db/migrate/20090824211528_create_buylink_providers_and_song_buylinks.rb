class CreateBuylinkProvidersAndSongBuylinks < ActiveRecord::Migration
  def self.up
    create_table :buylink_providers do |t|
      t.string :name
      t.string :store_image
      t.timestamps
    end

    create_table :song_buylinks do |t|
      t.references :song
      t.references :buylink_provider
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :buylink_providers
    drop_table :song_buylinks
  end
end
