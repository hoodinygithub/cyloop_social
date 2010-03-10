class RemoveDistributorFromSongs < ActiveRecord::Migration
  def self.up
    remove_column :songs, :distributor
  end

  def self.down
    add_column :songs, :distributor, :string
  end
end
