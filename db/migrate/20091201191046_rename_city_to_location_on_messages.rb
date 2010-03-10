class RenameCityToLocationOnMessages < ActiveRecord::Migration
  def self.up
    rename_column :messages, :city, :location
  end

  def self.down
    rename_column :messages, :location, :city
  end
end
