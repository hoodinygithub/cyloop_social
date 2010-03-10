class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name
      t.string :code, :limit => 2
      t.integer :latitude
      t.integer :longitude
    end
  end

  def self.down
    drop_table :countries
  end
end
