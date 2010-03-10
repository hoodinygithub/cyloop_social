class ChangeLabelInAccountsAndAlbums < ActiveRecord::Migration
  def self.up
    remove_column :albums, :label
    add_column :albums, :label_id, :integer
    add_column :accounts, :label_id, :integer
  end

  def self.down
    remove_column :accounts, :label_id
    remove_column :albums, :label_id 
    add_column :albums, :label, :string 
  end
end
