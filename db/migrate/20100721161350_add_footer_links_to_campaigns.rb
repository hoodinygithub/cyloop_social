class AddFooterLinksToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :link1_url, :string
    add_column :campaigns, :link1_name, :string
    add_column :campaigns, :link2_url, :string
    add_column :campaigns, :link2_name, :string
    add_column :campaigns, :link3_url, :string
    add_column :campaigns, :link3_name, :string
    add_column :campaigns, :link4_url, :string
    add_column :campaigns, :link4_name, :string
    add_column :campaigns, :link5_url, :string
    add_column :campaigns, :link5_name, :string
    add_column :campaigns, :link6_url, :string
    add_column :campaigns, :link6_name, :string
  end

  def self.down
    remove_column :campaigns, :link1_url
    remove_column :campaigns, :link1_name
    remove_column :campaigns, :link2_url
    remove_column :campaigns, :link2_name
    remove_column :campaigns, :link3_url
    remove_column :campaigns, :link3_name
    remove_column :campaigns, :link4_url
    remove_column :campaigns, :link4_name
    remove_column :campaigns, :link5_url
    remove_column :campaigns, :link5_name
    remove_column :campaigns, :link6_url
    remove_column :campaigns, :link6_name
  end
end
