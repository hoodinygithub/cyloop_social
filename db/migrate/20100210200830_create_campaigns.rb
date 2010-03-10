class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.boolean :active, :default => false
      t.string :hexcolor
      t.text :adcode
      t.timestamps
    end
  end

  def self.down
    drop_table :campaings
  end
end
