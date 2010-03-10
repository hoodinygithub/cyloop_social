class AddBuylinkCountToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :buylink_count, :integer, :default => 0
  end

  def self.down
    remove_column :songs, :buylink_count
  end
end
