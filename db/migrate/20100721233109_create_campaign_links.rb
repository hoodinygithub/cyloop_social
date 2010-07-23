class CreateCampaignLinks < ActiveRecord::Migration
  def self.up
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
    
    create_table :campaign_links do |t|
      t.integer :campaign_id
      t.string :url
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :campaign_links
  end
end
