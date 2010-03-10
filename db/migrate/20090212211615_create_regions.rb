class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.integer :country_id
      t.string :name
      t.string :code, :limit => 10
    end
  end

  def self.down
    drop_table :regions
  end
end
