class AddDeletedAtToAlbumsAndSongs < ActiveRecord::Migration
  def self.up
    add_column :albums, :deleted_at, :datetime
    add_column :songs, :deleted_at, :datetime
  end

  def self.down
    remove_column :albums, :deleted_at
    remove_column :songs, :deleted_at
  end
end
