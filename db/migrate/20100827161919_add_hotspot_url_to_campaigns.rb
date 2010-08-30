class AddHotspotUrlToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :hotspot_url, :string
  end

  def self.down
    remove_column :campaigns, :hotspot_url
  end
end
