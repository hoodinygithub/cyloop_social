class AddTrackingColumnsToVariousTables < ActiveRecord::Migration
  def self.up
    add_column :accounts, :deleted_at, :datetime 
    add_column :accounts, :created_by_id, :integer 
    add_column :albums, :source, :string, :default => 'Manual'
    add_column :songs, :source, :string, :default => 'Manual' 
    add_column :raw_song_plays, :full, :boolean 
    add_column :raw_song_plays, :station_id, :integer 
    add_column :user_stations, :referrer_id, :integer 
  end

  def self.down
    remove_column :user_stations, :referrer_id
    remove_column :raw_song_plays, :station_id
    remove_column :raw_song_plays, :full
    remove_column :songs, :source
    remove_column :albums, :source
    remove_column :accounts, :created_by_id
    remove_column :accounts, :deleted_at
  end
end
