class AddExtraColumnsToAlbums < ActiveRecord::Migration
  def self.up
    add_column :albums, :grid, :string
    add_column :albums, :released_on, :datetime
    add_column :albums, :copyright, :string
  end

  def self.down
    remove_column :albums, :copyright
    remove_column :albums, :released_on
    remove_column :albums, :grid
  end
end
