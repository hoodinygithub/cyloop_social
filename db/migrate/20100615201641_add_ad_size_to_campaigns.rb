class AddAdSizeToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :ad_size, :string
  end

  def self.down
    remove_column :campaigns, :ad_size
  end
end
