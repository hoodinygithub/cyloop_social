class AddMsnLiveIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :msn_live_id, :string
  end

  def self.down
    remove_column :accounts, :msn_live_id
  end
end
