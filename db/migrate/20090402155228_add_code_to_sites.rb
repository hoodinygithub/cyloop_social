class AddCodeToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :code, :string
  end

  def self.down
    remove_column :sites, :code
  end
end
