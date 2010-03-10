class AddFolloweeCacheToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :followee_cache, :text
  end

  def self.down
    remove_column :users, :followee_cache
  end
end
