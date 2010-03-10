class AddGridToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :grid, :string
    add_column :songs, :isrc, :string
  end

  def self.down
    remove_column :songs, :grid
    remove_column :songs, :isrc
  end
end
