class AddLabelIdToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :label_id, :integer
    add_index :songs, :label_id
  end

  def self.down
    remove_index :songs, :column => :label_id
    remove_column :songs, :label_id
  end
end
