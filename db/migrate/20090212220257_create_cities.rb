class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.integer :region_id
      t.string :name      
    end
    add_index :cities, :region_id
  end

  def self.down
    remove_index :cities, :column => :region_id
    drop_table :cities
  end
end
