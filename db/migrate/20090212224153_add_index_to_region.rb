class AddIndexToRegion < ActiveRecord::Migration
  def self.up
    add_index :regions, :country_id
  end

  def self.down
    remove_index :regions, :column => :country_id
  end
end
