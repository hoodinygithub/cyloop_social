class RenameSecondsToLengthOnSongs < ActiveRecord::Migration
  def self.up
    rename_column :songs, :seconds, :length
  end

  def self.down
    rename_column :songs, :length, :seconds
  end
end
