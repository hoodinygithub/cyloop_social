class AddLoginTypeIdToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :login_type_id, :integer
  end

  def self.down
    remove_column :sites, :login_type_id
  end
end
