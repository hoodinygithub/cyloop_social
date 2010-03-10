class AddMsnLiveAccountIdToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :msn_live_account_id, :string
  end

  def self.down
    remove_column :sites, :msn_live_account_id
  end
end
