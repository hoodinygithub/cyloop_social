class AddEditorialPlayIconToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :progressbar_hexcolor, :string
    add_column :campaigns, :editorial_play_icon_file_name, :string
    add_column :campaigns, :editorial_play_icon_content_type, :string
    add_column :campaigns, :editorial_play_icon_file_size, :integer
    add_column :campaigns, :editorial_play_icon_updated_at, :datetime
  end

  def self.down
    remove_column :campaigns, :progressbar_hexcolor
    remove_column :campaigns, :editorial_play_icon_file_name
    remove_column :campaigns, :editorial_play_icon_content_type
    remove_column :campaigns, :editorial_play_icon_file_size
    remove_column :campaigns, :editorial_play_icon_updated_at
  end
end
