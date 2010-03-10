class AddColorSettingsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :color_header_bg, :string, :limit => 6
    add_column :accounts, :color_main_font, :string, :limit => 6
    add_column :accounts, :color_links, :string, :limit => 6
    add_column :accounts, :color_bg, :string, :limit => 6
  end

  def self.down
    remove_column :accounts, :color_bg 
    remove_column :accounts, :color_links
    remove_column :accounts, :color_main_font
    remove_column :accounts, :color_header_bg
  end
end
