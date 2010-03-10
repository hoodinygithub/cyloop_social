class AddIndexToAlbumsOnReleasedOn < ActiveRecord::Migration
  def self.up
    add_index :albums, :released_on
  end

  def self.down
    remove_index :albums, :column => :released_on
  end
end
