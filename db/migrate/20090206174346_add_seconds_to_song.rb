class AddSecondsToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :seconds, :integer
  end

  def self.down
    remove_column :songs, :seconds
  end
end
