class AddFileNameToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :file_name, :string
  end

  def self.down
    remove_column :songs, :file_name
  end
end
