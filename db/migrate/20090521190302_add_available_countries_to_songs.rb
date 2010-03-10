class AddAvailableCountriesToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :available_countries, :text
  end

  def self.down
    remove_column :songs, :available_countries
  end
end
