class AddExtraInfoToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :site_id, :integer
    add_column :campaigns, :player_id, :integer
    add_column :campaigns, :code, :string
    add_column :campaigns, :notes, :text
    
    ['main_image', 'footer_logo'].each do |field|
      add_column :campaigns, "#{field}_file_name", :string
      add_column :campaigns, "#{field}_content_type", :string
      add_column :campaigns, "#{field}_file_size", :integer
      add_column :campaigns, "#{field}_updated_at", :datetime
    end
  end

  def self.down
    ['site_id', 'player_id', 'code', 'notes'].each do |field|
      remove_column :campaings, field
    end
    
    ['main_image', 'footer_logo'].each do |field|
      remove_column :campaigns, "#{field}_file_name"
      remove_column :campaigns, "#{field}_content_type"
      remove_column :campaigns, "#{field}_file_size"
      remove_column :campaigns, "#{field}_updated_at"
    end
  end
end
