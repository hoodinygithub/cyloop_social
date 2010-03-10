class CreateSiteStatisticsTable < ActiveRecord::Migration
  def self.up
    create_table :site_statistics do |t|
      t.references :site
      t.integer :total_artists, :default => 0
      t.integer :total_songs, :default => 0
      t.integer :total_users, :default => 0
      t.integer :total_registrations, :default => 0
    end
    add_index :site_statistics, :site_id
  end

  def self.down
    drop_table :site_statistics
  end
end
