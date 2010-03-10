class AddMarketingOptOutToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :marketing_opt_out, :boolean
  end

  def self.down
    remove_column :users, :marketing_opt_out
  end
end
