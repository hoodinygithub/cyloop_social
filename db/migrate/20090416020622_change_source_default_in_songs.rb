class ChangeSourceDefaultInSongs < ActiveRecord::Migration
  def self.up
    remove_column :songs, :source
    add_column :songs, :source, :string, :default => 'Ingest'
  end

  def self.down
    remove_column :songs, :source
    add_column :songs, :source, :string, :default => 'Manual'
  end
end
