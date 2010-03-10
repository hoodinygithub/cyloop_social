class CreateBandMembers < ActiveRecord::Migration
  def self.up
    create_table :band_members do |t|
      t.references :artist
      t.string :name
      t.string :instrument
      t.text :bio

      t.timestamps
    end
  end

  def self.down
    drop_table :band_members
  end
end
