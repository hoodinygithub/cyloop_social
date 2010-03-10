class AddLocationToCities < ActiveRecord::Migration
  def self.up
    execute("ALTER TABLE cities ENGINE=MyISAM")
    add_column :cities, :location, :string
    add_index :cities, :location
  end

  def self.down
    remove_index :cities, :column => :location
    remove_column :cities, :location
    execute("ALTER TABLE cities ENGINE=innodb")
  end
end
