class AddCopyrightAndLabelAndDistributorToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :copyright, :string
    add_column :songs, :label, :string
    add_column :songs, :distributor, :string
    rename_column :songs, :length, :duration
  end

  def self.down
    rename_column :songs, :duration, :length
    remove_column :songs, :distributor
    remove_column :songs, :label
    remove_column :songs, :copyright
  end
end
