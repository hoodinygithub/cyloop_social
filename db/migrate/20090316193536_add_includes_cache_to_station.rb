class AddIncludesCacheToStation < ActiveRecord::Migration
  def self.up
    add_column :stations, :includes_cache, :text
  end

  def self.down
    remove_column :stations, :includes_cache
  end
end
