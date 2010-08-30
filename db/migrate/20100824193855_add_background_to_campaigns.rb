class AddBackgroundToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :campaign_background_file_name, :string
    add_column :campaigns, :campaign_background_content_type, :string
    add_column :campaigns, :campaign_background_file_size, :integer
    add_column :campaigns, :campaign_background_updated_at, :datetime
  end

  def self.down
    remove_column :campaigns, :campaign_background_file_name
    remove_column :campaigns, :campaign_background_content_type
    remove_column :campaigns, :campaign_background_file_size
    remove_column :campaigns, :campaign_background_updated_at
  end
end
